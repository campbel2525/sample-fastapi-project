from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app import models
from app.auth import authentication
from app.schemas.requests.account_requests import (
    AccountRefreshTokenRequest,
    AccountSignInRequest,
    AccountSignUpRequest,
)
from app.schemas.resources.user_resources import UserResource
from app.schemas.responses.account_responses import JwtResponse
from config import settings, swagger_configs

router = APIRouter()


@router.post(
    "/v1/accounts/sign-up",
    response_model=JwtResponse,
    summary=str(swagger_configs.get_schemas()["accounts_sign_up"]["summary"]),
    description=str(swagger_configs.get_schemas()["accounts_sign_up"]["description"]),
    tags=list(swagger_configs.get_schemas()["accounts_sign_up"]["tags"]),
)
async def sign_up(
    request: AccountSignUpRequest,
    db: Session = Depends(settings.get_db),
) -> JwtResponse:
    """
    新規登録
    """
    # emailがすでに登録済みでないか
    is_exists = models.User.exist_user(db, request.email)
    if is_exists is True:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="すでに登録済みのメールアドレスです。",
        )

    # ユーザーを登録
    user = models.User()
    user.name = request.name
    user.email = request.email
    user.password = models.User.password_to_hash(request.password)
    db.add(user)
    db.commit()
    db.refresh(user)

    # トークンを返す
    access_token = authentication.create_access_token(user)
    refresh_token = authentication.create_refresh_token(user)
    return JwtResponse(access_token=access_token, refresh_token=refresh_token)


@router.post(
    "/v1/accounts/sign-in",
    response_model=JwtResponse,
    summary=str(swagger_configs.get_schemas()["accounts_sign_in"]["summary"]),
    description=str(swagger_configs.get_schemas()["accounts_sign_in"]["description"]),
    tags=list(swagger_configs.get_schemas()["accounts_sign_in"]["tags"]),
)
async def sign_in(
    request: AccountSignInRequest,
    db: Session = Depends(settings.get_db),
) -> JwtResponse:
    """
    ログイン
    """
    # emailを元にユーザーを取得
    user = db.query(models.User).filter(models.User.email == request.email).first()

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
    request: AccountRefreshTokenRequest,
    db: Session = Depends(settings.get_db),
) -> JwtResponse:
    """
    トークンのリフレッシュ
    """

    user_id = authentication.auth_user_id_from_refresh_token(request.refresh_token)
    user = db.query(models.User).filter(models.User.id == user_id).first()
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
    response_model=UserResource,
    summary=str(swagger_configs.get_schemas()["accounts_me"]["summary"]),
    description=str(swagger_configs.get_schemas()["accounts_me"]["description"]),
    tags=list(swagger_configs.get_schemas()["accounts_me"]["tags"]),
    dependencies=[
        Depends(authentication.get_user_by_access_token),
    ],
)
async def me(
    auth_user=Depends(authentication.get_user_by_access_token),
) -> UserResource:
    """
    自分の情報を取得
    """
    return UserResource.model_validate(auth_user)
