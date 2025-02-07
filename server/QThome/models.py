# myapp/models.py

from django.db import models

class Data(models.Model):
    LIGHT_CHOICES = [
        ('very_dark', 'Very Dark'),
        ('dark', 'Dark'),
        ('medium', 'Medium'),
        ('bright', 'Bright'),
        ('very_bright', 'Very Bright')
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
        ('closed', 'Closed'),
    ]

    COOLER_CHOICES = [
        ("off", "Off"),
        ("low_speed", "Low Speed"),
        ("medium_speed", "Medium Speed"),
        ("high_speed", "High Speed")
    ]

    lightSensor = models.CharField(max_length=13, choices=LIGHT_CHOICES)
    temperatureSensor = models.FloatField()
    motionSensor = models.CharField(max_length=13, choices=MOTION_CHOICES)
    lampState = models.CharField(max_length=13, choices=LAMP_CHOICES)
    curtainState = models.CharField(max_length=13, choices=CURTAIN_CHOICES)
    coolerState = models.CharField(max_length=13, choices=COOLER_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)
