from datetime import datetime

from pytz import timezone  # type: ignore
from sqlalchemy import BigInteger, Boolean, Column, DateTime, String, text
from sqlalchemy.orm import declarative_mixin

from config.settings import TIME_ZONE


def current_timestamp():
    jst = timezone(TIME_ZONE)
    return datetime.now(jst)


@declarative_mixin
class AdminUserMixin:
    __tablename__ = "admin_users"

    id = Column(
        BigInteger,
        primary_key=True,
    )
    email = Column(
        String(255),
        nullable=False,
        unique=True,
        comment="メールアドレス",
    )
    password = Column(
        String(255),
        nullable=False,
        comment="パスワード",
    )
    is_active = Column(
        Boolean,
        nullable=False,
        default=True,
        comment="アクティブかどうか",
    )
    name = Column(
        String(255),
        nullable=False,
        comment="名前",
    )
    created_at = Column(
        DateTime,
        nullable=False,
        default=current_timestamp,
        server_default=text("CURRENT_TIMESTAMP"),
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        default=current_timestamp,
        server_default=text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
    )
