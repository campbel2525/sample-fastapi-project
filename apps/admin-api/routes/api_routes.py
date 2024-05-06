from app.routers import account_routers, hc_routers, user_routers


def routing(app):
    app.include_router(hc_routers.router)
    app.include_router(account_routers.router)
    app.include_router(user_routers.router)
