import hashlib

from sqlalchemy import exists
from sqlalchemy.orm import Session

from core.database.model_mixins.user_mixins import UserMixin
from config.settings import Base


class User(Base, UserMixin):
    @classmethod
    def exist_user(cls, db: Session, email: str) -> bool:
        return db.query(exists().where(User.email == email)).scalar()

    @classmethod
    def password_to_hash(cls, password: str) -> str:
        return hashlib.sha512(password.encode("utf-8")).hexdigest()

    def check_password(self, raw_password: str) -> bool:
        return self.password == User.password_to_hash(raw_password)
