import typer

from app.helpers import env_helpers
from common.database.seeders.admin_user_seeder import AdminUserSeeder
from common.database.seeders.user_seeder import UserSeeder

app = typer.Typer()


class Seeds:
    def __init__(self):
        pass

    def handle(self):
        if not env_helpers.is_local():
            typer.echo("ローカル環境以外では実行できません。")
            return

        UserSeeder().handle()
        AdminUserSeeder().handle()


@app.command()
def seeds():
    Seeds().handle()


if __name__ == "__main__":
    app()
