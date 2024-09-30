from typing import List

from pydantic import BaseModel

from app.schemas.resources.user_resources import UserResource


class IndexResponse(BaseModel):
    data: List[UserResource]
