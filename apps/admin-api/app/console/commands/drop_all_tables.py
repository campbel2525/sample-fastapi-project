import typer
from sqlalchemy import MetaData, text

from app.helpers import env_helpers
from config.settings import db, engine

app = typer.Typer()


class DropAllTables:
    def __init__(self, db):
        self.db = db

    def handle(self):
        if not env_helpers.is_local():
            typer.echo("ローカル環境以外では実行できません。")
            return

        self.db.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))

        metadata = MetaData()
        metadata.reflect(bind=engine)
        tables = metadata.tables
        for table in tables:
            self.db.execute(text(f"DROP TABLE IF EXISTS {table}"))

        self.db.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))
        self.db.commit()


@app.command()
def drop_all_tables():
    DropAllTables(db).handle()


if __name__ == "__main__":
    app()
