from django.urls import re_path, path

from . import consumer

websocket_urlpatterns = [
    re_path(
        r"ws/bar/",
        consumer.ProgressBarConsumer.as_asgi(),
    ),
    path("ws/test", consumer.MyTestWebsocketRoute.as_asgi())
]        