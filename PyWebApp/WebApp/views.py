# -*- coding: utf-8 -*-
import json
from datetime import datetime

import pyodbc
from django.http import HttpResponse
from django.shortcuts import render

# Create your views here.
with open('config.json', 'r', encoding='utf-8') as f:
    config = json.load(f)

temp = config["Base de Datos"]
dbmssql = pyodbc.connect(
    "DRIVER={SQL Server};SERVER=" + temp["IP"] + ";DATABASE=" + temp["Database"] + ";UID=" + temp["User"] + ";PWD=" +
    temp["Pass"])
cursor = dbmssql.cursor()

def presetContext(request):
    preset = {
        "Empresa": config["Empresa"],
        "title": config['Empresa']["Nombre"]
    }
    cursor.execute("SELECT descripcion FROM TipoVehiculo;")
    preset['tipos'] = [i[0] for i in cursor.fetchall()]
    preset['logged'] = False
    return preset


def index(request):
    context = presetContext(request)
    cursor.execute("SELECT nombre FROM Provincias;")
    context['provincias'] = [i[0] for i in cursor.fetchall()]
    context['marcas'] = ['Ferrari','Mercedes','Magia']
    context['years'] = range(1970, datetime.now().year + 2)
    return render(request, 'index.html', context)


def catalog(request):
    context = presetContext(request)
    cursor.execute("SELECT nombre FROM Provincias;")
    context['provincias'] = [i[0] for i in cursor.fetchall()]
    context['title'] += ' - Cátalogo'
    context['marcas'] = ['Ferrari', 'Mercedes', 'Magia']
    return render(request, 'catalog.html', context)


def login(request):
    context = presetContext(request)
    context['title'] = 'Inicio de sección'
    return render(request, 'login.html', context)


def registrar(request):
    context = presetContext(request)
    context['title'] += 'Registración'
    return render(request, 'registrar.html', context)


def loginrequest(request):
    tresponse = HttpResponse('fail');
    if request.POST['user'] == 'znzn00' and request.POST['pwd'] == '1653800406BFC343A9EAB36E6E548B82':
        tresponse = HttpResponse('1')
    return tresponse


def view(request, id):
    context = presetContext(request)
    context["carro"]={
        "marca": 'Toyota',
        "modelo": 'Nose',
        "year": 2010,
        "precio": 10000
    }
    return render(request, 'view.html', context)


def perfil(request, id):
    context = presetContext(request)
    return render(request, 'perfil.html', context)


def contacto(request):
    context = presetContext(request)
    context['title'] += ' - Contacto'
    return render(request, 'contacto.html', context)


def directorio(request):
    context = presetContext(request)
    context['title'] += ' - Directorio'
    return render(request, 'directorio.html', context)


def vende(request):
    context = presetContext(request)
    context['title'] += ' - Vende'
    return render(request, 'vende.html', context)


def editarPerfil(request):
    context = presetContext(request)
    return render(request, 'vende.html', context)


def registerrequest(request):
    return HttpResponse('yes')
