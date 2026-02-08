from enum import StrEnum

class Tags(StrEnum):
    AUTH = "Auth"
    CHAT = "Chat"
    USERS = "Users"

class Collections(StrEnum):
    USERS = "users"
    CHATS = "chats"

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
