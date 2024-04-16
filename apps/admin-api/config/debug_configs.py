from app.helpers.env_helpers import is_local
from config import settings


def run_debug():
    """
    debugpyはlocaldevv環境でのみinstallしているため
    import debugpy
    はこの関数内でやること
    """
    if is_local() and settings.DEBUG:
        import debugpy

        debugpy.listen(("0.0.0.0", 9000))
