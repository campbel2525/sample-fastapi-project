import time

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer
from fastapi.security.http import HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app import models
from config import settings

bearer_scheme = HTTPBearer()


def get_user_by_access_token(
    authorization: HTTPAuthorizationCredentials = Depends(HTTPBearer()),
    db: Session = Depends(settings.get_db),
):
    if authorization is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません1",
        )

    payload = __decode_jwt_token(authorization.credentials, "access_token")

    auth_user = (
        db.query(models.User)
        .filter(models.User.id == payload["id"])
        # .filter(models.User.email == payload["email"])
        .filter(models.User.is_active.is_(True))
        .first()
    )

    if auth_user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません2",
        )

    return auth_user


def create_access_token(auth_user: models.User) -> str:
    """
    access_tokenを生成する
    """
    return __create_jwt_token(
        auth_user,
        int(time.time()) + settings.JWT_ACCESS_TOKEN_EXPIRES_SECONDS,
        "access_token",
    )


def create_refresh_token(auth_user: models.User) -> str:
    """
    refresh_tokenを生成する
    """
    return __create_jwt_token(
        auth_user,
        int(time.time()) + settings.JWT_REFRESH_TOKEN_EXPIRES_SECONDS,
        "refresh_token",
    )


def auth_user_id_from_refresh_token(refresh_token: str) -> int:
    """
    refresh_tokenの検証を行い認証ユーザーidを取得する
    """
    payload = __decode_jwt_token(refresh_token, "refresh_token")

    return payload["id"]


def __create_jwt_token(
    auth_user: models.User,
    exp: int,
    typ: str,
) -> str:
    """
    jwtを生成する
    """
    payload = {
        "id": auth_user.id,
        # "email": auth_user.email,
        "exp": exp,
        "typ": typ,
    }

    encoded_jwt = jwt.encode(
        payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM
    )

    return encoded_jwt


def __decode_jwt_token(access_token: str, typ: str) -> dict:
    """
    jwtをデコードして検証する
    """
    try:
        payload = jwt.decode(
            access_token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM]
        )

    # 期限(exp)を過ぎている場合
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません3",
        )

    # jwtが不正な場合
    except jwt.InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません4",
        )

    if "id" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません5",
        )

    # if "email" not in payload:
    #     raise HTTPException(
    #         status_code=status.HTTP_401_UNAUTHORIZED,
    #         detail="jwtが正しく設定されていません6",
    #     )

    if "exp" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません7",
        )

    if "typ" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません8",
        )

    print(payload["typ"])
    print(typ)

    if payload["typ"] != typ:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="jwtが正しく設定されていません9",
        )

    return payload
