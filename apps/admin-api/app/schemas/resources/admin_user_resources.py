from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class AdminUserResource(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int = Field(
        example=1,
        description="",
    )
    email: str = Field(
        example="xx@example.com",
        description="メール",
    )
    is_active: bool = Field(
        example=True,
        description="有効かどうか",
    )
    name: str = Field(
        example="campbel",
        description="名前",
    )
    created_at: datetime = Field(
        example="2021-01-01 00:00:00",
        description="",
    )
    updated_at: datetime = Field(
        example="2021-01-01 00:00:00",
        description="",
    )
