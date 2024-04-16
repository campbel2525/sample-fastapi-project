from typing import List

from pydantic import BaseModel

from app.schemas.resources.user_resources import UserResource


class UserListResponse(BaseModel):
    data: List[UserResource]
