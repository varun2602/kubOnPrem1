from django.db import models

class Student(models.Model):
    name = models.CharField(max_length=200, blank=True, null = True)
    email = models.CharField(max_length=200, blank=True, null=True)
    position = models.CharField(max_length = 200, blank=True, null=True)
    password = models.CharField(max_length = 200, blank=True, null=True)

    def __str__(self):
        return f"{self.name}_{self.email}" 
    
