import hashlib

from sqlalchemy import exists
from sqlalchemy.orm import Session

from common.database.model_mixins.admin_user_mixins import AdminUserMixin
from config.settings import Base


class AdminUser(Base, AdminUserMixin):
    @classmethod
    def exist_user(cls, db: Session, email: str) -> bool:
        return db.query(exists().where(AdminUser.email == email)).scalar()

    @classmethod
    def password_to_hash(cls, password: str) -> str:
        return hashlib.sha512(password.encode("utf-8")).hexdigest()

    def check_password(self, raw_password: str) -> bool:
        return self.password == AdminUser.password_to_hash(raw_password)
