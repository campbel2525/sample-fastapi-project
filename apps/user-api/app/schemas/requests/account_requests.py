from pydantic import BaseModel, EmailStr, Field


class AccountSignUpRequest(BaseModel):
    name: str = Field(
        min_length=1,
        example="campbel",
        description="名前",
    )
    email: EmailStr = Field(
        min_length=1,
        example="xx@example.com",
        description="メールアドレス",
    )
    password: str = Field(
        min_length=5,
        example="test1234",
        description="パスワード",
    )


class AccountSignInRequest(BaseModel):
    email: EmailStr = Field(
        min_length=1,
        example="user1@example.com",
        description="メールアドレス",
    )
    password: str = Field(
        min_length=1,
        example="test1234",
        description="パスワード",
    )


class AccountRefreshTokenRequest(BaseModel):
    refresh_token: str = Field(
        example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOSwiZXhwIjoxNzA1OTUzNjcxLCJ0eXAiOiJyZWZyZXNoX3Rva2VuIn0.XU-gxVl2SdMMf_TYfV0Zu8VxkCzJT-Pt6v3hwxKMZrs",  # noqa
        description="リフレッシュトークン",
    )
