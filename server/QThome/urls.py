# myapp/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import DataViewSet
from . import views

router = DefaultRouter()
router.register(r'data', DataViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('custom-actions/', views.custom_actions_view, name='custom_actions'),
    path('perform-action/', views.perform_action, name='perform_action'),
    path('get-sensor-data/', views.get_sensor_data, name='get_sensor_data'),
]