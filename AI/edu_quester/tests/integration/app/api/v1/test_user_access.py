import uuid

import pytest

from app.core.config import settings


@pytest.mark.asyncio(loop_scope="module")
async def test_user_access_permissions(client):
    # 1. Register and Login Student A
    email_a = f"stud_a_{uuid.uuid4()}@example.com"
    pass_a = "password123"
    reg_a = await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": email_a,
        "password": pass_a,
        "role": "student"
    })
    id_a = reg_a.json()["id"]

    login_a = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={"username": email_a, "password": pass_a})
    token_a = login_a.json()["access_token"]
    headers_a = {"Authorization": f"Bearer {token_a}"}

    # 2. Register and Login Student B
    email_b = f"stud_b_{uuid.uuid4()}@example.com"
    pass_b = "password123"
    reg_b = await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": email_b,
        "password": pass_b,
        "role": "student"
    })
    id_b = reg_b.json()["id"]

    login_b = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={"username": email_b, "password": pass_b})
    token_b = login_b.json()["access_token"]
    # headers_b not used in this test


    # 3. Register and Login Instructor
    email_i = f"instr_access_{uuid.uuid4()}@example.com"
    pass_i = "password123"
    reg_i = await client.post(f"{settings.API_V1_STR}/auth/register", json={
        "email": email_i,
        "password": pass_i,
        "role": "instructor"
    })
    id_i = reg_i.json()["id"]

    login_i = await client.post(f"{settings.API_V1_STR}/auth/jwt/login", data={"username": email_i, "password": pass_i})
    token_i = login_i.json()["access_token"]
    headers_i = {"Authorization": f"Bearer {token_i}"}

    # --- VERIFY GET /{id} ---

    # Student A can GET self
    res = await client.get(f"{settings.API_V1_STR}/students/{id_a}", headers=headers_a)
    assert res.status_code == 200
    assert res.json()["email"] == email_a

    # Student A CANNOT GET Student B
    res = await client.get(f"{settings.API_V1_STR}/students/{id_b}", headers=headers_a)
    assert res.status_code == 403

    # Instructor CAN GET Student A
    res = await client.get(f"{settings.API_V1_STR}/students/{id_a}", headers=headers_i)
    assert res.status_code == 200
    assert res.json()["id"] == id_a

    # Student A CANNOT GET Instructor
    res = await client.get(f"{settings.API_V1_STR}/students/{id_i}", headers=headers_a)
    assert res.status_code == 403

    # --- VERIFY PATCH /{id} ---

    # Student A can PATCH self
    res = await client.patch(f"{settings.API_V1_STR}/students/{id_a}", json={"first_name": "NewName"}, headers=headers_a)
    assert res.status_code == 200
    assert res.json()["first_name"] == "NewName"

    # Instructor CANNOT PATCH Student A
    res = await client.patch(f"{settings.API_V1_STR}/students/{id_a}", json={"first_name": "BadName"}, headers=headers_i)
    assert res.status_code == 403

    # --- VERIFY DELETE /{id} ---

    # Instructor CANNOT DELETE Student A
    res = await client.delete(f"{settings.API_V1_STR}/students/{id_a}", headers=headers_i)
    assert res.status_code == 403

    # Student A can DELETE self
    res = await client.delete(f"{settings.API_V1_STR}/students/{id_a}", headers=headers_a)
    assert res.status_code == 204

    # Verify Student A is gone
    res = await client.get(f"{settings.API_V1_STR}/students/{id_a}", headers=headers_i)
    assert res.status_code == 404
