from app import models
from common.database.factories.user_factories import UserFactory


class UserSeeder:
    default_password = "test1234"

    def handle(self) -> None:
        password = models.User.password_to_hash(self.default_password)

        UserFactory.create(
            email="user1@example.com",
            password=password,
            is_active=True,
            name="user1",
        )

        UserFactory.create()
        UserFactory.create()
        UserFactory.create()
        UserFactory.create()
