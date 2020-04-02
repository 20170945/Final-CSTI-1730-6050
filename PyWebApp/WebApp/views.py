import json
from datetime import datetime

import pyodbc
from django.http import HttpResponse
from django.shortcuts import render

# Create your views here.
with open('config.json', 'r') as f:
    config = json.load(f)

temp = config["Base de Datos"]
dbmssql = pyodbc.connect(
    "DRIVER={SQL Server};SERVER=" + temp["IP"] + ";DATABASE=" + temp["Database"] + ";UID=" + temp["User"] + ";PWD=" +
    temp["Pass"])
cursor = dbmssql.cursor()


def presetContext(request):
    preset = {
        "Empresa": config["Empresa"]
    }
    cursor.execute("SELECT descripcion FROM TipoVehiculo;")
    preset['tipos'] = [i[0] for i in cursor.fetchall()]
    preset['logged'] = False
    return preset


def index(request):
    context = presetContext(request)
    cursor.execute("SELECT nombre FROM Provincias;")
    context['provincias'] = [i[0] for i in cursor.fetchall()]
    context['years'] = range(1970, datetime.now().year + 2)
    print(request.COOKIES)
    return render(request, 'index.html', context)


def catalog(request):
    context = presetContext(request)
    return render(request, 'catalog.html', context)

def login(request):
    context = presetContext(request)
    return render(request, 'login.html', context)

def loginrequest(request):
    context = presetContext(request)
    print(request.POST)
    return render(request, 'login.html', context)