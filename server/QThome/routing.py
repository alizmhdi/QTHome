from django.urls import path
from ..server import consumers

websocket_urlpatterns = [
    path("ws/data/", consumers.DataConsumer.as_asgi()),
]
