from django.conf.urls import url
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index),
    path('catalog', views.catalog),
    path('login', views.login),
    path('registrar', views.registrar),
    path('loginrequest', views.loginrequest),
    path('registerrequest', views.registerrequest),
    path('view/<int:id>', views.view),
    path('directorio', views.directorio),
    path('vende', views.vende),
    path('contacto', views.contacto),
    path('perfil/<int:id>', views.perfil),
    path('editar/perfil', views.editarPerfil),
]
