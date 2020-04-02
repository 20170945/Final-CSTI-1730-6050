from django.conf.urls import url
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index),
    path('catalog', views.catalog),
    path('login', views.login),
]
