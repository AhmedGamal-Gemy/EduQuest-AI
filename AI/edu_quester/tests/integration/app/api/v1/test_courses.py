import pytest
import uuid
import jwt
from app.core.config import settings

@pytest.mark.asyncio(loop_scope="module")
async def test_course_crud_and_enrollment(client):
    # 1. Register Instructor
    instr_email = f"instr_{uuid.uuid4()}@example.com"
    instr_pass = "password123"
    await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": instr_email,
        "password": instr_pass,
        "first_name": "Course",
        "last_name": "Instructor",
        "role": "instructor"
    })
    
    # Login Instructor
    login_res = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={
        "username": instr_email,
        "password": instr_pass
    })
    assert login_res.status_code == 200, f"Login failed: {login_res.text}"
    instr_token = login_res.json()["access_token"]
    instr_headers = {"Authorization": f"Bearer {instr_token}"}
    
    # 2. Register Student
    stud_email = f"stud_{uuid.uuid4()}@example.com"
    stud_pass = "password123"
    await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": stud_email,
        "password": stud_pass,
        "first_name": "Course",
        "last_name": "Student",
        "role": "student"
    })
    
    # Login Student
    login_res = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={
        "username": stud_email,
        "password": stud_pass
    })
    assert login_res.status_code == 200
    stud_token = login_res.json()["access_token"]
    stud_headers = {"Authorization": f"Bearer {stud_token}"}
    
    # 3. Create Course (as Instructor)
    course_data = {
        "title": f"FastAPI Masterclass {uuid.uuid4()}",
        "description": "Learn FastAPI from scratch",
        "github_repo_url": "https://github.com/fastapi/fastapi",
        "level": "intermediate"
    }
    create_res = await client.post(f"{settings.API_V1_STR}/courses/", json=course_data, headers=instr_headers)
    assert create_res.status_code == 201
    course_id = create_res.json()["id"]
    
    # 4. List Courses
    list_res = await client.get(f"{settings.API_V1_STR}/courses/")
    assert list_res.status_code == 200
    assert any(c["id"] == course_id for c in list_res.json())
    
    # 5. Enroll in Course (as Student)
    enroll_res = await client.post(f"{settings.API_V1_STR}/courses/{course_id}/enroll", headers=stud_headers)
    assert enroll_res.status_code == 200
    
    # Get student ID from login response (need to register/login again or decode token)
    stud_payload = jwt.decode(stud_token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM], audience="fastapi-users:auth")
    stud_id = stud_payload["sub"] # fastapi-users uses 'sub' for user ID
    
    assert stud_id in enroll_res.json()["student_ids"]
    
    # 6. Update Course
    update_res = await client.patch(f"{settings.API_V1_STR}/courses/{course_id}", json={"title": "Updated FastAPI"}, headers=instr_headers)
    assert update_res.status_code == 200
    assert update_res.json()["title"] == "Updated FastAPI"
    
    # 7. Delete Course
    delete_res = await client.delete(f"{settings.API_V1_STR}/courses/{course_id}", headers=instr_headers)
    assert delete_res.status_code == 204

@pytest.mark.asyncio(loop_scope="module")
async def test_instructor_rbac(client):
    # Register Student
    stud_email = f"stud_rbac_{uuid.uuid4()}@example.com"
    stud_pass = "password123"
    await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": stud_email,
        "password": stud_pass,
        "role": "student"
    })
    
    # Login Student
    login_res = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={
        "username": stud_email,
        "password": stud_pass
    })
    stud_token = login_res.json()["access_token"]
    stud_headers = {"Authorization": f"Bearer {stud_token}"}
    
    # Try to create course as student
    response = await client.post(f"{settings.API_V1_STR}/courses/", json={"title": "Forbidden"}, headers=stud_headers)
    assert response.status_code == 403
    assert response.json()["detail"] == "Only instructors can create courses"
