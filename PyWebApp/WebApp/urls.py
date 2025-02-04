from django.conf.urls import url
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index),
    path('catalog', views.catalog),
    path('catalog/<str:modo>', views.catalog),
    path('login', views.login),
    path('registrar', views.registrar),
    path('loginrequest', views.loginRequest),
    path('registerrequest', views.registerRequest),
    path('view/<int:id>', views.view),
    path('directorio', views.directorio),
    path('vende', views.vende),
    path('contacto', views.contacto),
    # path('perfil/<int:id>', views.perfil),
    # path('editar/perfil', views.editarPerfil),
    path('panel/admin', views.panelAdmin),
    path('panel/admin/<str:path>', views.panelAdminPath),
    path('panel/admin/<str:path>/<str:mode>', views.panelAdminPath),
    path('panel/venta', views.panelVenta),
    path('panel/venta/<str:path>', views.panelVenta),
    path('panel/venta/<str:path>/<str:mode>', views.panelVenta),
    path('api/<str:table>/<str:option>', views.api),
]
