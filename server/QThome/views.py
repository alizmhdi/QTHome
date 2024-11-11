# myapp/views.py

# from rest_framework import viewsets
# from .models import Data
# from .serializers import DataSerializer

# class DataViewSet(viewsets.ModelViewSet):
#     queryset = Data.objects.all()
#     serializer_class = DataSerializer

from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

channel_layer = get_channel_layer()

def notify_clients(data):
    async_to_sync(channel_layer.group_send)(
        "data_updates",
        {
            "type": "send_data_update",
            "message": data,
        }
    )
