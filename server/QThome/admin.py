# myapp/admin.py

from django.contrib import admin
from .models import Data
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from channels.layers import InMemoryChannelLayer
@admin.register(Data)
class ActivitiesAdmin(admin.ModelAdmin):
    list_display = ('lightSensor', 'temperatureSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')
    list_filter = ('lightSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')
    actions = ['enable_lamp', 'disable_lamp', 'enable_cooler', 'disable_cooler', 'open_curtain', 'close_curtain']

    def send_data(self, request, message):
        channel_layer = get_channel_layer()
        print(channel_layer)
        async_to_sync(channel_layer.group_send)(
            "QT", 
            {
                'type': 'send_message',
                'message': message
            }
        )
        self.message_user(request, "Message sent.")
    
    def enable_lamp(self, request, queryset):
        self.send_data(request, "Lamp is enabled.")
    def disable_lamp(self, request, queryset):
        self.send_data(request, "Lamp is disabled.")
    def enable_cooler(self, request, queryset):
        self.send_data(request, "Cooler is enabled.")
    def disable_cooler(self, request, queryset):
        self.send_data(request, "Cooler is disabled.")
    def open_curtain(self, request, queryset):
        self.send_data(request, "Curtain is opened.")
    def close_curtain(self, request, queryset):
        self.send_data(request, "Curtain is closed.")
