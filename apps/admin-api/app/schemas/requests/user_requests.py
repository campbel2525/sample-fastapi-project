from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class UserUpdateRequest(BaseModel):
    email: EmailStr = Field(
        min_length=1,
        example="xx@example.com",
        description="メールアドレス",
    )
    password: Optional[str] = Field(
        min_length=0,
        example="test1234",
        description="パスワード 変更する場合のみ入力",
    )
    is_active: bool = Field(
        example=True,
        description="有効かどうか",
    )
    name: str = Field(
        min_length=1,
        example="campbel",
        description="名前",
    )
