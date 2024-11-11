import json
from channels.generic.websocket import AsyncWebsocketConsumer

class DataConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.channel_layer.group_add("data_updates", self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("data_updates", self.channel_name)

    async def receive(self, text_data):
        pass  # We’re not handling any client messages in this example

    async def send_data_update(self, event):
        message = event["message"]
        await self.send(text_data=json.dumps(message))
