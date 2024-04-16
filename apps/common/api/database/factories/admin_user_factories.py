import factory
from factory.alchemy import SQLAlchemyModelFactory

from app import models
from config.settings import db


class AdminUserFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.AdminUser
        sqlalchemy_session = db
        sqlalchemy_session_persistence = "commit"

    email = factory.Sequence(lambda n: f"test{n}@example.com")
    password = factory.Faker("pystr", min_chars=10, max_chars=20)
    is_active = factory.Faker("boolean")
    name = factory.Faker("name")
