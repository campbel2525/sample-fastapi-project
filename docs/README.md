## 1 対多のサンプル

```python
from typing import TYPE_CHECKING
from sqlalchemy.orm import Mapped, declarative_mixin, declared_attr, relationship


if TYPE_CHECKING:
    from app.models.orders import Order

@declarative_mixin
class UserMixin:
    __tablename__ = "users"

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

    @declared_attr
    def orders(cls) -> Mapped["Order"]:
        return relationship("Order", backref="user")

@declarative_mixin
class OrderMixin:
    __tablename__ = "orders"

    id = Column(
        BigInteger,
        primary_key=True,
    )
    name = Column(
        String(255),
        nullable=False,
        comment="名前",
    )
    user_id = Column(
        BigInteger,
        ForeignKey("users.id"),
        nullable=False,
    )
```
