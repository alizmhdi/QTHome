import json
from channels.generic.websocket import AsyncWebsocketConsumer

class DataConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.channel_layer.group_add("data_updates", self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("data_updates", self.channel_name)

    async def receive(self, text_data):
        await self.save_data(data)
        await self.send(text_data=json.dumps({"status": "success", "message": "Data received and saved"}))

    async def send_data_update(self):
        data = {
        "lightSensor": light_sensor,
        "temperatureSensor": temperature_sensor,
        "motionSensor": motion_sensor,
        "lampState": lamp_state,
        "curtainState": curtain_state,
        "coolerState": cooler_state
        }
        await self.send(text_data=json.dumps(data))

 @sync_to_async
    def save_data(self, data):
        # Parse and save data fields to the model
        Data.objects.create(
            lightSensor=data.get("lightSensor"),
            temperatureSensor=data.get("temperatureSensor"),
            motionSensor=data.get("motionSensor"),
            lampState=data.get("lampState"),
            curtainState=data.get("curtainState"),
            coolerState=data.get("coolerState"),
        )