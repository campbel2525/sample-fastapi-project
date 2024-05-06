from pydantic import BaseModel, EmailStr, Field


class LoginRequest(BaseModel):
    email: EmailStr = Field(
        min_length=1,
        example="admin1@example.com",
        description="メールアドレス",
    )
    password: str = Field(
        min_length=1,
        example="test1234",
        description="パスワード",
    )


class RefreshTokenRequest(BaseModel):
    refresh_token: str = Field(
        example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOSwiZXhwIjoxNzA1OTUzNjcxLCJ0eXAiOiJyZWZyZXNoX3Rva2VuIn0.XU-gxVl2SdMMf_TYfV0Zu8VxkCzJT-Pt6v3hwxKMZrs",  # noqa
        description="リフレッシュトークン",
    )
