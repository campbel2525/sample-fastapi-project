from pydantic import BaseModel, Field


class JwtResponse(BaseModel):
    access_token: str = Field(
        example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOSwiZXhwIjoxNzA1MDkzMjcxLCJ0eXAiOiJhY2Nlc3NfdG9rZW4ifQ.Qt9aU3F2tY8rKTWQBybT2Mfb36hw9VLTcSH3RObNW_I",  # noqa
        description="アクセストークン",
    )
    refresh_token: str = Field(
        example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOSwiZXhwIjoxNzA1OTUzNjcxLCJ0eXAiOiJyZWZyZXNoX3Rva2VuIn0.XU-gxVl2SdMMf_TYfV0Zu8VxkCzJT-Pt6v3hwxKMZrs",  # noqa
        description="リフレッシュトークン",
    )
