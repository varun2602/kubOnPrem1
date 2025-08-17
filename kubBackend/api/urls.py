from django.urls import path 
from . import views 

urlpatterns = [
    path("get-students/", views.StudentListCreate.as_view()),
    path("create-student-entry", views.StudentListCreate.as_view()),
    path("get-cache", views.GetRedisData.as_view())
]