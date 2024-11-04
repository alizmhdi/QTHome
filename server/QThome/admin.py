# myapp/admin.py

from django.contrib import admin
from .models import Data

@admin.register(Data)
class ActivitiesAdmin(admin.ModelAdmin):
    list_display = ('lightSensor', 'temperatureSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')
    list_filter = ('lightSensor', 'motionSensor', 'lampState', 'curtainState', 'coolerState', 'created_at')