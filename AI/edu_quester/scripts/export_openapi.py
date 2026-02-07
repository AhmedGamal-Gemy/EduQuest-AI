import json
import os
import sys
import subprocess

# Add the project root to sys.path to allow imports from app
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from fastapi.openapi.utils import get_openapi
from app.main import app

def export_openapi():
    # 1. Export OpenAPI JSON
    # Use app.openapi() which now includes the custom HTTPBearer scheme
    openapi_schema = app.openapi()
    
    # Force HTTPBearer as the primary security scheme for Postman
    # Replaces OAuth2PasswordBearer with HTTPBearer in all paths
    for path, methods in openapi_schema.get("paths", {}).items():
        for method, operation in methods.items():
            if "security" in operation:
                # Replace security list with just HTTPBearer
                operation["security"] = [{"HTTPBearer": []}]

    openapi_file = "openapi.json"
    postman_file = "postman_collection.json"
    options_file = "postman-options.json"
    
    with open(openapi_file, "w") as f:
        json.dump(openapi_schema, f, indent=2)
    
    print(f"OpenAPI schema exported to {openapi_file}")
    
    # 2. Convert to Postman Collection using npx
    try:
        print("Converting OpenAPI to Postman Collection...")
        # Use options config file for more reliable conversion
        subprocess.run(
            [
                "npx", "openapi-to-postmanv2", 
                "-s", openapi_file, 
                "-o", postman_file, 
                "-p", 
                "-c", options_file
            ],
            check=True
        )
        print(f"Postman collection exported to {postman_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error converting to Postman: {e}")
    except FileNotFoundError:
        print("npx/node not found. Skipping Postman conversion.")

if __name__ == "__main__":
    export_openapi()
