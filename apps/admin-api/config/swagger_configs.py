from app.helpers import env_helpers
from config import settings


def get_schemas():
    DEFAULT_MESSAGE = "ログインを行ってjwtを取得後、headerにaccess_tokenを設定してください。"

    return {
        "hc": {
            "tags": ["hc"],
            "summary": "ヘルスチェック用のエンドポイント",
            "description": "ヘルスチェック",
        },
        # accounts
        "accounts_sign_in": {
            "tags": ["accounts"],
            "summary": "ログイン",
            "description": "",
        },
        "accounts_me": {
            "tags": ["accounts"],
            "summary": "自分の情報を取得",
            "description": DEFAULT_MESSAGE,
        },
        "accounts_refresh_token": {
            "tags": ["accounts"],
            "summary": "トークンのリフレッシュ",
            "description": "",
        },
        # users
        "users_index": {
            "tags": ["users"],
            "summary": "user index",
            "description": DEFAULT_MESSAGE,
        },
        "users_retrieve": {
            "tags": ["users"],
            "summary": "user retrieve",
            "description": DEFAULT_MESSAGE,
        },
        "users_create": {
            "tags": ["users"],
            "summary": "user create",
            "description": DEFAULT_MESSAGE,
        },
        "users_update": {
            "tags": ["users"],
            "summary": "user update",
            "description": DEFAULT_MESSAGE,
        },
        "users_destroy": {
            "tags": ["users"],
            "summary": "user destroy",
            "description": DEFAULT_MESSAGE,
        },
    }


def get_swagger_info():
    title = settings.APP_NAME
    version = settings.APP_VERSION
    description = ""
    docs_url = None
    redoc_url = None
    openapi_url = None
    if env_helpers.is_local():
        description = "swaggerです"
        docs_url = "/docs"
        redoc_url = "/redoc"
        openapi_url = "/openapi.json"

    return {
        "title": title,
        "version": version,
        "description": description,
        "docs_url": docs_url,
        "redoc_url": redoc_url,
        "openapi_url": openapi_url,
    }
