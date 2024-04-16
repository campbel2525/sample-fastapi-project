from app import models
from common.database.factories.admin_user_factories import AdminUserFactory


class AdminUserSeeder:
    default_password = "test1234"

    def handle(self) -> None:
        password = models.User.password_to_hash(self.default_password)

        AdminUserFactory.create(
            email="admin1@example.com",
            password=password,
            is_active=True,
            name="admin1",
        )
