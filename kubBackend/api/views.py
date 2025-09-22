from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.generics import ListCreateAPIView, ListAPIView
# from django_redis_sentinel import BaseCache
from django.core.cache import cache
# from django_redis.cache import BaseCache
from rest_framework.status import *
from . import models 
from . import serializer
# base_cache_instance = BaseCache(params={"TIMEOUT":300})

class StudentListCreate(ListCreateAPIView):
    queryset = models.Student.objects.all()
    serializer_class = serializer.StudentSerializer 
    def post(self, request, *args, **kwargs):
        # base_cache_instance.set(key="req_debug_cache", value=request.data)
        cache.set("req_debug_cache", request.data)
        serialized = self.serializer_class(data = request.data)
        if serialized.is_valid():
            serialized.save()
            return Response({"msg":"Entry created successfully", "data":f"{request.data}"}, status = HTTP_200_OK)
        return Response(serialized.errors, status=HTTP_500_INTERNAL_SERVER_ERROR)
    
class GetRedisData(ListAPIView):

    def get(self, request, *args, **kwargs):
        value = cache.get("req_debug_cache")
        if not value:
            return Response({}, status=HTTP_200_OK)
        cache.delete("req_debug_cache")
        return Response({"req_debug_cache":value})
 