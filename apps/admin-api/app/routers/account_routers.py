from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app import models
from app.auth import authentication
from app.schemas.requests.account_requests import LoginRequest, RefreshTokenRequest
from app.schemas.resources.admin_user_resources import AdminUserResource
from app.schemas.responses.account_responses import JwtResponse
from config import settings, swagger_configs

router = APIRouter()


@router.post(
    "/v1/accounts/login",
    response_model=JwtResponse,
    summary=str(swagger_configs.get_schemas()["accounts_login"]["summary"]),
    description=str(swagger_configs.get_schemas()["accounts_login"]["description"]),
    tags=list(swagger_configs.get_schemas()["accounts_login"]["tags"]),
)
async def login(
    request: LoginRequest,
    db: Session = Depends(settings.get_db),
) -> JwtResponse:
    """
    ログイン
    """
    # emailを元にユーザーを取得
    user = (
        db.query(models.AdminUser)
        .filter(models.AdminUser.email == request.email)
        .first()
    )

    # ユーザーが存在するか
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="メールアドレスもしくはパスワードが間違っています",
        )

    # パスワードが正しいか
    if user.check_password(request.password) is False:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="メールアドレスもしくはパスワードが間違っています",
        )

    # トークンを返す
    access_token = authentication.create_access_token(user)
    refresh_token = authentication.create_refresh_token(user)
    return JwtResponse(access_token=access_token, refresh_token=refresh_token)


@router.post(
    "/v1/accounts/refresh-token",
    response_model=JwtResponse,
    summary=str(swagger_configs.get_schemas()["accounts_refresh_token"]["summary"]),
    description=str(
        swagger_configs.get_schemas()["accounts_refresh_token"]["description"]
    ),
    tags=list(swagger_configs.get_schemas()["accounts_refresh_token"]["tags"]),
)
async def refresh_token(
    request: RefreshTokenRequest,
    db: Session = Depends(settings.get_db),
) -> JwtResponse:
    """
    トークンのリフレッシュ
    """

    user_id = authentication.auth_user_id_from_refresh_token(request.refresh_token)
    user = db.query(models.AdminUser).filter(models.AdminUser.id == user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtの設定が正しくありません",
        )

    access_token = authentication.create_access_token(user)
    refresh_token = authentication.create_refresh_token(user)
    return JwtResponse(access_token=access_token, refresh_token=refresh_token)


@router.get(
    "/v1/accounts/me",
    response_model=AdminUserResource,
    summary=str(swagger_configs.get_schemas()["accounts_me"]["summary"]),
    description=str(swagger_configs.get_schemas()["accounts_me"]["description"]),
    tags=list(swagger_configs.get_schemas()["accounts_me"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def me(
    auth_user=Depends(authentication.get_user_by_access_token),
) -> AdminUserResource:
    """
    自分の情報を取得
    """
    return AdminUserResource.model_validate(auth_user)
