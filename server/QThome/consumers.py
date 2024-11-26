# your_app_name/consumers.py

import json
from channels.generic.websocket import AsyncWebsocketConsumer

class QTConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.group_name = 'QT'
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)

    async def send_message(self, event):
        message = event['message']
        await self.send(text_data=json.dumps({'message': message}))