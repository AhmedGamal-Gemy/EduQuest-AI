from __future__ import annotations

"""
Unified application logger with per-scan log files.
Shared between App and Agents.
"""

import sys
import logging
import warnings
from pathlib import Path
from typing import Optional
from loguru import logger as loguru_logger

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #

# Remove default handler
loguru_logger.remove()

# Silence third-party loggers
warnings.filterwarnings("ignore", message="MCPTool class is deprecated", category=DeprecationWarning)
warnings.filterwarnings("ignore", message=".*BaseAuthenticatedTool.*", category=UserWarning)
warnings.filterwarnings("ignore", message=".*PydanticSerializationUnexpectedValue.*", category=UserWarning)
warnings.filterwarnings("ignore", message="Pydantic serializer warnings:", category=UserWarning)

logging.getLogger("google").setLevel(logging.WARNING)
logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)
logging.getLogger("google_adk").setLevel(logging.WARNING)
logging.getLogger("LiteLLM").setLevel(logging.WARNING)
logging.getLogger("uvicorn").setLevel(logging.WARNING)
logging.getLogger("uvicorn.access").setLevel(logging.WARNING)

# ANSI Color Codes
RESET = "\033[0m"
AGENT_COLORS = {
    "orchestrator": "\033[34m",  # Blue
    "recon": "\033[35m",         # Magenta
    "auth": "\033[33m",          # Yellow
    "sqli": "\033[31m",          # Red
    "unknown": "\033[36m",       # Cyan
    "user": "\033[32m",          # Green
    "system": "\033[36m",        # Cyan
    "api": "\033[96m",           # Bright Cyan for FastAPI
}

BASE_FORMAT = (
    "<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | "
    "<level>{level: <8}</level> | "
    "{extra[colored_author]} | "
    "<level>{message}</level>"
)

FILE_FORMAT = (
    "{time:YYYY-MM-DD HH:mm:ss.SSS} | "
    "{level: <8} | "
    "[{extra[author]: ^12}] | "
    "{message}"
)

def patcher(record):
    """Add default values for optional extra fields and handle agent coloring with ANSI."""
    author = record["extra"].get("author", "system")
    record["extra"].setdefault("author", author)
    
    author_lower = author.lower()
    color_code = AGENT_COLORS.get("unknown")
    
    for key, val in AGENT_COLORS.items():
        if key in author_lower:
            color_code = val
            break
            
    # For Terminal: Use ANSI
    record["extra"]["colored_author"] = f"{color_code}[{author: ^12}]{RESET}"
    
    record["extra"].setdefault("step", None)
    record["extra"].setdefault("trace_id", None)
    record["extra"].setdefault("node", None)
    return record


# --------------------------------------------------------------------------- #
# Console logging
# --------------------------------------------------------------------------- #
loguru_logger = loguru_logger.patch(patcher)
loguru_logger.add(
    sys.stdout,
    format=BASE_FORMAT,
    colorize=True,
    backtrace=True,
    diagnose=True,
    level="INFO",
)

# --------------------------------------------------------------------------- #
# Global file logging
# --------------------------------------------------------------------------- #
# Path("logs").mkdir(exist_ok=True)
# loguru_logger.add(
#     "logs/app.log",
#     format=FILE_FORMAT,
#     rotation="7 days",
#     retention="30 days",
#     compression="zip",
#     level="DEBUG",
#     enqueue=True,
#     backtrace=True,
#     diagnose=True,
# )

# --------------------------------------------------------------------------- #
# Logger Wrapper
# --------------------------------------------------------------------------- #
class Logger:
    def __init__(self, logger):
        self._logger = logger
        self._scan_handler_id: Optional[int] = None

    def step(self, step_name: str):
        return self._logger.bind(step=step_name)

    def trace(self, trace_id: str):
        return self._logger.bind(trace_id=trace_id or "none")

    def node(self, node_name: str):
        return self._logger.bind(node=node_name)

    def start_scan_logging(self, log_file: Path):
        self.stop_scan_logging()
        self._scan_handler_id = self._logger.add(
            str(log_file),
            format=FILE_FORMAT,
            level="DEBUG",
            enqueue=True,
            backtrace=True,
            diagnose=True,
        )
        self._logger.debug(f"📁 Scan logging started: {log_file}")
    
    def stop_scan_logging(self):
        if self._scan_handler_id is not None:
            try:
                self._logger.remove(self._scan_handler_id)
            except ValueError:
                pass
            self._scan_handler_id = None

    def __getattr__(self, name):
        return getattr(self._logger, name)


logger = Logger(loguru_logger)


class InterceptHandler(logging.Handler):
    """
    Default handler from examples in loguru documentation.
    See https://loguru.readthedocs.io/en/stable/overview.html#entirely-compatible-with-standard-logging
    """

    def emit(self, record):
        # Get corresponding Loguru level if it exists
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        # Find caller from where originated the logged message
        frame, depth = logging.currentframe(), 2
        while frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(
            level, record.getMessage()
        )
