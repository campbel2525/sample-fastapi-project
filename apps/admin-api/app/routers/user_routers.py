from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import Response
from sqlalchemy.orm import Session

from app import models
from app.auth import authentication
from app.schemas.requests.user_requests import UserUpdateRequest
from app.schemas.resources.user_resources import UserResource
from app.schemas.responses.user_responses import UserListResponse
from config import settings, swagger_configs

router = APIRouter()


@router.get(
    "/v1/users",
    response_model=UserListResponse,
    summary=str(swagger_configs.get_schemas()["users_index"]["summary"]),
    description=str(swagger_configs.get_schemas()["users_index"]["description"]),
    tags=list(swagger_configs.get_schemas()["users_index"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def index(
    # auth_user=Depends(authentication.get_user_by_access_token),
    db: Session = Depends(settings.get_db),
) -> UserListResponse:
    users = db.query(models.User).all()
    return UserListResponse(data=[UserResource.from_orm(user) for user in users])


@router.get(
    "/v1/users/{user_id}",
    response_model=UserResource,
    summary=str(swagger_configs.get_schemas()["users_retrieve"]["summary"]),
    description=str(swagger_configs.get_schemas()["users_retrieve"]["description"]),
    tags=list(swagger_configs.get_schemas()["users_retrieve"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def retrieve(
    user_id: int,
    # auth_user=Depends(authentication.get_user_by_access_token),
    db: Session = Depends(settings.get_db),
) -> UserResource:
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    return UserResource.from_orm(user)


@router.put(
    "/v1/users/{user_id}",
    response_model=UserResource,
    summary=str(swagger_configs.get_schemas()["users_update"]["summary"]),
    description=str(swagger_configs.get_schemas()["users_update"]["description"]),
    tags=list(swagger_configs.get_schemas()["users_update"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def update(
    user_id: int,
    request: UserUpdateRequest,
    # auth_user=Depends(authentication.get_user_by_access_token),
    db: Session = Depends(settings.get_db),
) -> UserResource:
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    user.email = request.email
    if request.password:
        user.password = models.User.password_to_hash(request.password)
    user.is_active = request.is_active
    user.name = request.name
    db.commit()
    db.refresh(user)

    return UserResource.from_orm(user)


@router.delete(
    "/v1/users/{user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary=str(swagger_configs.get_schemas()["users_destroy"]["summary"]),
    description=str(swagger_configs.get_schemas()["users_destroy"]["description"]),
    tags=list(swagger_configs.get_schemas()["users_destroy"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def destroy(
    user_id: int,
    # auth_user=Depends(authentication.get_user_by_access_token),
    db: Session = Depends(settings.get_db),
) -> Response:
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    db.delete(user)
    db.commit()

    return Response(content="", status_code=status.HTTP_204_NO_CONTENT)
