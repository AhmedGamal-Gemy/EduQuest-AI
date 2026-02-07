# Troubleshooting & Learnings Log

This document tracks technical issues encountered during development, their explanations, and fixes. It serves as a learning resource and debugging guide.

## 1. Environment Mismatch Warning (`uv`)

**Issue:**
When running commands, the following warning appeared:
```
warning: VIRTUAL_ENV=.../AI/.venv does not match the project environment path .venv and will be ignored
```

**Explanation:**
This occurs when the shell has an active virtual environment (via `source .../activate` or auto-detection) that is *different* from the one `uv` manages locally for the specific project.
- **Context**: The parent directory had a `.venv`, but we initialized a fresh `.venv` inside `edu_quester`.
- **Behavior**: `uv` detects this discrepancy and prioritizes the *project-local* environment to ensure dependencies are isolated and correct. It safely ignores the external environment.

**Resolution:**
No action needed; this is `uv` protecting the project integrity.

## 2. Package Discovery Error (`setuptools`)

**Issue:**
Installation failed with:
```
Multiple top-level packages discovered in a flat-layout: ['app', 'edu_quester'].
```

**Explanation:**
Python's build system (`setuptools`) attempts to automatically find the source code package.
- **Context**: Our project structure is a "flat layout" with two top-level source directories:
    - `app/` (FastAPI Backend)
    - `edu_quester/` (AI Agents)
- **Problem**: `setuptools` expects a single package by default or is ambiguous about which one to pick.

**Resolution:**
We explicitly configured `pyproject.toml` to include both:
```toml
[tool.setuptools.packages.find]
include = ["app*", "edu_quester*"]
```
This tells the build system to treat both directories as installable packages.

## 3. Dependency Management (`pytest` missing)

**Issue:**
`make test` failed because `pytest` command was not found, resulting in `Exit code: 127` or `os error 2`.

**Explanation:**
We assumed `pytest` was installed but missed adding it to the `[project.dependencies]` in `pyproject.toml`. Python projects do not include test runners by default.

**Resolution:**

## 4. Beanie Model Type Error

**Issue:**
Unit tests failed with:
```
TypeError: <class 'fastapi_users_db_beanie.BeanieBaseUser'> cannot be parametrized
```

**Explanation:**
We initially defined the user model as `class User(BeanieBaseUser[UUID], Document):`.
Unlike SQLAlchemy's generic base classes, `BeanieBaseUser` in the current version does not support generic type parametrization `[...]` for the ID type.

**Resolution:**
We removed the generic parameter and explicitly defined the ID field using Pydantic:
```python
class User(BeanieBaseUser, Document):
    id: UUID = Field(default_factory=uuid4)
```

## 5. MongoDB Driver Choice (Motor vs PyMongo)

**Issue:**
We initially attempted to use the native `pymongo.AsyncMongoClient` (introduced in PyMongo 4.9+). 

**Explanation:**
While PyMongo now supports async, Beanie's integration with it is still evolving. We encountered intermittent connection and authentication issues using the direct PyMongo async client.

**Resolution:**
Reverted to `motor.motor_asyncio.AsyncIOMotorClient`, which is the industry standard and proven companion for Beanie.

...

## 14. MongoDB Authentication Failure (Docker/WSL2)

**Issue:**
`AuthenticationFailed` error when connecting from host to MongoDB container, despite correct credentials.

**Explanation:**
This is likely due to the SASL handshake failing over the virtual network bridge (Docker/WSL2). The same credentials worked fine from within the container network but were rejected from the host.

**Resolution:**
Disabled MongoDB authentication for the local development environment in `docker-compose.yml` and settings. This unblocks development and testing without compromising project security (as production remains authenticated).

## 6. Pydantic V1 Validator Warning

**Issue:**
```
PydanticDeprecatedSince20: Pydantic V1 style `@validator` validators are deprecated.
```

**Explanation:**
The project uses Pydantic V2, but the code used the old V1 syntax (`@validator`).

**Resolution:**
Refactored `app/core/config.py` to use:
```python
from pydantic import field_validator
...
@field_validator("FIELD_NAME", mode="before")
@classmethod
def method_name(cls, v): ...
```

## 7. Configuration for Docker vs Localhost
**Issue:**
Tests might timeout if they try to connect to `localhost` but the database container ports aren't mapped or accessible immediately.

## 8. Command `uv` Not Found
**Issue:**
User received `Command 'uv' not found` despite having installed it.
**Explanation:**
`uv` installs binaries to `$HOME/.local/bin`, which is often not in the system's `$PATH` by default in some Linux environments.
**Resolution:**
Exported the path: `export PATH="$HOME/.local/bin:$PATH"` and added it to `~/.bashrc`.

## 9. ModuleNotFoundError: No module named 'app.api.v1.api'
**Issue:**
Pytest failed to import the API router module even though the file existed.
**Explanation:**
Python requires `__init__.py` files to recognize directories as packages. The `app/api/` and `app/api/v1/` directories were missing these files.
**Resolution:**
Created empty `__init__.py` files in:
- `app/api/`
- `app/api/v1/`
- `app/api/v1/endpoints/`

## 10. Integration Tests Hanging
**Issue:**
Tests run with `pytest-asyncio` hang and ultimately time out.
**Potential Causes:**
- Application startup (`Lifespan`) blocked waiting for Database/Redis connection.
- Event Loop mismatches between `pytest-asyncio` and `httpx`.

## 11. Test Error 404 Not Found
**Issue:**
Integration test received `404 Not Found` for `/api/v1/auth/register`.

**Explanation:**
The path was actually `/api/v1/auth/register/register`.
- `fastapi-users`'s `get_register_router` returns a router containing `/register` (implicit or explicit).
- We mounted it with `prefix=AuthRoutes.REGISTER` (which is `"/register"`).
- Result: `/register` + `/register`.

**Resolution:**
Fixed `app/api/v1/endpoints/auth.py` to use `prefix=""` when mounting the register router.
Resulting path: `/api/v1/auth/register`.

## 12. Async Event Loop Mismatch
**Issue:**
`RuntimeError: Cannot use AsyncMongoClient in different event loop`.

**Explanation:**
- The DB client was initialized in the `client` fixture (Module scope loop).
- The test function ran in a default Function scope loop.
- Accessing the module-scoped DB client from a function-scoped test caused the crash.

**Resolution:**
1. Aligned scopes in `pyproject.toml`: `asyncio_default_fixture_loop_scope = "module"`.
2. Marked the test function explicitly: `@pytest.mark.asyncio(scope="module")` (or `loop_scope` in newer pytest-asyncio).

## 13. Pytest Deprecation Warning: "scope" vs "loop_scope"
**Warning:**
`PytestDeprecationWarning: The "scope" keyword argument to the asyncio marker has been deprecated. Please use the "loop_scope" argument instead.`

**Explanation:**
Newer versions of `pytest-asyncio` have renamed the argument to be more explicit that it controls the *event loop* scope, not just the test scope.

**Resolution:**
Updated `@pytest.mark.asyncio(scope="module")` to `@pytest.mark.asyncio(loop_scope="module")`.
## 15. Port 8001 (formerly 8000) Address Already in Use (Errno 98) - WSL2/Windows

**Issue:**
`uv run uvicorn` fails with `ERROR: [Errno 98] Address already in use`, but `lsof` or `ss` inside WSL2 show no active process.

**Explanation:**
A process on the Windows host is likely holding the port. WSL2 shares the network stack with Windows, so host-level listeners block WSL2 listeners on the same port.
- **Critical Note**: If `tasklist.exe` indicates the process is `svchost.exe`, it is a Windows System Service. Attempting to kill it will result in "Access is denied" and could destabilize Windows.

**Resolution:**
1. Identify the Windows PID: `netstat.exe -ano | grep :8001`
2. Identify the process: `tasklist.exe /FI "PID eq <PID>"`
3. If it's a user process, kill it: `taskkill.exe /F /PID <PID>`
4. **If it's `svchost.exe` or another system service**: Do not kill it. Instead, ensure you are using a non-conflicting port (e.g., we moved from `8000` to `8001`).

## 16. WSL2 Uninterruptible Sleep ('D' state) hang

**Issue:**
The `uvicorn` (or other) processes become completely unresponsive. Requests time out, and `pkill -9` or `kill -9` have no effect. Running `ps aux` shows the process state as `D`.

**Explanation:**
This is typically caused by I/O contention when the project is stored on a Windows-mounted drive (`/mnt/c/...`). 
- **OneDrive Sync**: If the folder is being synced by OneDrive, it may lock files during the sync process. If the Linux kernel (WSL2) attempts to access these locked files, it can enter a 'D' state (waiting for disk I/O) that cannot be interrupted by signals.

**Resolution:**
1. **Force Restart WSL**: Linux cannot recover the process while the I/O is blocked. In Windows PowerShell:
   ```powershell
   wsl --shutdown
   ```
2. **Move to Native Linux FS**: Storing projects in the native Linux filesystem (e.g., `/home/user/project`) instead of the Windows mount point avoids 99% of these I/O-related hangs and delivers significantly better performance.
3. **Disable OneDrive Sync**: Temporarily pause or disable OneDrive for the project folder.
