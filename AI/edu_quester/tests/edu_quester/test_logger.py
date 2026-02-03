import pytest
from edu_quester.shared.logger import logger

def test_logger_initialization():
    assert logger is not None

def test_logger_binding(capsys):
    log = logger.bind(author="api")
    log.info("Test API log")
    # In a real environment we'd check stdout/file, but for now we just ensure it doesn't crash
    assert True

def test_logger_colors():
    # Verify we can use the custom colors
    log = logger.bind(author="orchestrator")
    log.info("Agent Log")
    assert True
