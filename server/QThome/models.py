# myapp/models.py

from django.db import models

class Data(models.Model):
    LIGHT_CHOICES = [
        ('dark', 'Dark'),
        ('light', 'Light'),
    ]

    MOTION_CHOICES = [
        ('detected', 'Detected'),
        ('not_detected', 'Not Detected'),
    ]

    LAMP_CHOICES = [
        ('ON', 'On'),
        ('OFF', 'Off'),
    ]

    CURTAIN_CHOICES = [
        ('open', 'Open'),
        ('close', 'Close'),
    ]

    COOLER_CHOICES = [
        ('high', 'High'),
        ('medium', 'Medium'),
        ('low', 'Low'),
    ]

    lightSensor = models.CharField(max_length=5, choices=LIGHT_CHOICES)
    temperatureSensor = models.FloatField()
    motionSensor = models.CharField(max_length=12, choices=MOTION_CHOICES)
    lampState = models.CharField(max_length=3, choices=LAMP_CHOICES)
    curtainState = models.CharField(max_length=5, choices=CURTAIN_CHOICES)
    coolerState = models.CharField(max_length=6, choices=COOLER_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)