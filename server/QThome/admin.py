from django.contrib import admin
from .models import Data
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

@admin.register(Data)
class ActivitiesAdmin(admin.ModelAdmin):
    list_display = ('lightSensor', 'temperatureSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')
    list_filter = ('lightSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')
    actions = ['enable_lamp', 'disable_lamp', 'enable_cooler', 'disable_cooler', 'open_curtain', 'close_curtain']
    
    #change_list_template = 'admin/myapp/data/change_list.html'
    
    def send_data(self, request, key, value):
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            "QT", 
            {
                'type': 'send_message',
                key: value
            }
        )
        self.message_user(request, "Message sent.")
    
    def enable_lamp(self, request, queryset):
        self.send_data(request, "lampState", "On")
    def disable_lamp(self, request, queryset):
        self.send_data(request, "lampState", "Off")
    def enable_cooler(self, request, queryset):
        self.send_data(request, "coolerState", "High Speed")
    def disable_cooler(self, request, queryset):
        self.send_data(request, "coolerState", "Off")
    def open_curtain(self, request, queryset):
        self.send_data(request, "curtainState", "Open")
    def close_curtain(self, request, queryset):
        self.send_data(request, "curtainState", "Close")
