from django.db import models

class Hotel(models.Model):
    title = models.CharField(max_length=50)
    desc = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    rating = models.CharField(max_length=50)
    review = models.CharField(max_length=50, blank=True)
    price = models.CharField(max_length=50)
    image = models.ImageField()

