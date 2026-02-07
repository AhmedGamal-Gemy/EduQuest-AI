from enum import StrEnum

class Tags(StrEnum):
    AUTH = "Auth"
    CHAT = "Chat"
    USERS = "Users"
    COURSES = "Courses"

class Collections(StrEnum):
    USERS = "users"
    CHATS = "chats"
    COURSES = "courses"

class LogEvents(StrEnum):
    STARTUP = "startup"
    SHUTDOWN = "shutdown"
    REQUEST = "request"
    DATABASE = "database"
    AUTH = "auth"

class AuthRoutes(StrEnum):
    JWT = "/jwt"
    REGISTER = "/register"
    RESET_PASSWORD = "/reset-password"
    VERIFY = "/verify"

class UserRole(StrEnum):
    INSTRUCTOR = "instructor"
    STUDENT = "student"

class CourseLevel(StrEnum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"
