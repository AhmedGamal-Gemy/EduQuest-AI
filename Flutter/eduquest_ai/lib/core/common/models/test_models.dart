/* 
  ! POST: /api/v1/chat/
    Request: {message*: string,session_id: string } .... what session_id
    Response: {"response": "string","session_id": "string"}
  
  ! Get: /api/v1/courses/ -> Unauthorized (List_courses)
    Request: none
    Response:[
              {
                "title": "string",
                "description": "string",
                "github_repo_url": "https://example.com/",
                "level": "beginner",
                "is_published": false,
                "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                "instructor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                "student_ids": [],
                "created_at": "2026-02-08T19:38:51.333Z",
                "updated_at": "2026-02-08T19:38:51.333Z"
              }
            ]

  !Post: /api/v1/courses/ -> Unauthorized (Create_course)
    Request: {
              "title"*: "string",
              "description": "string",
              "github_repo_url": "https://example.com/",
              "level": "beginner",
              "is_published": false
            }
    Response:{
              "title": "string",
              "description": "string",
              "github_repo_url": "https://example.com/",
              "level": "beginner",
              "is_published": false,
              "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "instructor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "student_ids": [],
              "created_at": "2026-02-08T19:41:45.710Z",
              "updated_at": "2026-02-08T19:41:45.710Z"
            }
  !Get: /api/v1/courses/{course_id} (Get_course)
    Params:{course_id*: string}
    Response:{
              "title": "string",
              "description": "string",
              "github_repo_url": "https://example.com/",
              "level": "beginner",
              "is_published": false,
              "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "instructor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "student_ids": [],
              "created_at": "2026-02-08T19:45:53.624Z",
              "updated_at": "2026-02-08T19:45:53.624Z"
            }

  !Patch: /api/v1/courses/{course_id} (Update_course)
    Params:  {course_id*: string}
    Request:{
            "title": "string",
            "description": "string",
            "github_repo_url": "https://example.com/",
            "level": "beginner",
            "is_published": true
          }
    Response:{
              "title": "string",
              "description": "string",
              "github_repo_url": "https://example.com/",
              "level": "beginner",
              "is_published": false,
              "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "instructor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "student_ids": [],
              "created_at": "2026-02-08T19:46:39.606Z",
              "updated_at": "2026-02-08T19:46:39.606Z"
            }
  !Delete: /api/v1/courses/{course_id} (Delete_course)
    Params: {course_id*: string}
    Response:	Todo (Successful Response)

  !Post: /api/v1/courses/{course_id}/enroll (Enroll_in_course)
    Params: {course_id*: string}
    Response:{
              "title": "string",
              "description": "string",
              "github_repo_url": "https://example.com/",
              "level": "beginner",
              "is_published": false,
              "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "instructor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "student_ids": [],
              "created_at": "2026-02-08T19:52:17.005Z",
              "updated_at": "2026-02-08T19:52:17.005Z"
            }

*/
