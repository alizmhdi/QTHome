import json
from django.shortcuts import render
from django.http import JsonResponse
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from .models import Data
from rest_framework import viewsets
from .serializers import DataSerializer

class DataViewSet(viewsets.ModelViewSet):
     queryset = Data.objects.all() 
     serializer_class = DataSerializer

def custom_actions_view(request):
    return render(request, 'custom_actions.html')

def perform_action(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        channel_layer = get_channel_layer()

        # Ensure to update or create the object based on the given id
        Data.objects.update_or_create(id=1, defaults=data)

        if 'lampState' in data:
            async_to_sync(channel_layer.group_send)("QT", {'type': 'send_message', 'lampState': data['lampState']})
        if 'curtainState' in data:
            async_to_sync(channel_layer.group_send)("QT", {'type': 'send_message', 'curtainState': data['curtainState']})
        if 'coolerState' in data:
            async_to_sync(channel_layer.group_send)("QT", {'type': 'send_message', 'coolerState': data['coolerState']})

        if 'lightSensor' in data:
            Data.objects.update_or_create(id=1, defaults={'lightSensor': data['lightSensor']})
        if 'temperatureSensor' in data:
            Data.objects.update_or_create(id=1, defaults={'temperatureSensor': data['temperatureSensor']})
        if 'motionSensor' in data:
            Data.objects.update_or_create(id=1, defaults={'motionSensor': data['motionSensor']})

        return JsonResponse({"status": "success", "message": "Action performed successfully."})

    return JsonResponse({"status": "error", "message": "Invalid request."})


def get_sensor_data(request):
    data = Data.objects.latest('created_at')

    sensor_data = {
        'lightSensor': data.lightSensor,
        'temperatureSensor': data.temperatureSensor,
        'motionSensor': data.motionSensor,
        'lampState': data.lampState,
        'curtainState': data.curtainState,
        'coolerState': data.coolerState,
    }
    return JsonResponse(sensor_data)

