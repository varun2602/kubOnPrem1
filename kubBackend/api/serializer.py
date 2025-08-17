from rest_framework.serializers import ModelSerializer, ValidationError
from . import models 


class StudentSerializer(ModelSerializer):
    class Meta:
        fields = "__all__"
        model = models.Student

    def validate_roll_no(self, roll_no):
        if roll_no > 0 and roll_no <= 200:
            return roll_no 
        raise ValidationError("Roll number should be between 0 and 200")