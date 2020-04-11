# -*- coding: utf-8 -*-
import json
from datetime import datetime

import pyodbc
from django.http import HttpResponse
from django.http import JsonResponse
from django.http import HttpResponseForbidden
from django.http import HttpResponseNotFound
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
    cursor.execute("SELECT * FROM TipoVehiculo;")
    preset['tipos'] = [i for i in cursor.fetchall()]
    preset['logged'] = False
    preset['admin'] = False
    if "LoginID" in request.COOKIES:
        cursor.execute("SELECT usuario FROM Usuario WHERE usuario='%s'" % (request.COOKIES['LoginID']))
        datos = cursor.fetchone()
        preset['logged'] = (datos is not None)
        if preset['logged']:
            preset['admin'] = (
                    cursor.execute("SELECT usuario FROM Admin WHERE usuario='%s'" % (datos[0])).rowcount != 0)
    return preset


def index(request):
    context = presetContext(request)
    cursor.execute("SELECT * FROM Ciudad ORDER BY nombre;")
    context['ciudades'] = cursor.fetchall()
    cursor.execute("SELECT * FROM Marca ORDER BY nombre;")
    context['marcas'] = cursor.fetchall()
    context['years'] = range(1970, datetime.now().year + 2)
    return render(request, 'index.html', context)


def catalog(request):
    context = presetContext(request)
    cursor.execute("SELECT * FROM Ciudad ORDER BY nombre;")
    context['ciudades'] = cursor.fetchall()
    context['title'] += ' - Cátalogo'
    cursor.execute("SELECT * FROM Marca ORDER BY nombre;")
    context['marcas'] = cursor.fetchall()
    return render(request, 'catalog.html', context)


def login(request):
    context = presetContext(request)
    context['title'] = 'Inicio de sección'
    context['msg'] = "Conectece" if 'm' in request.GET else ""
    return render(request, 'login.html', context)


def registrar(request):
    context = presetContext(request)
    context['title'] += ' - Registración'
    context['base'] = 'base.html'
    return render(request, 'registrar.html', context)


def loginRequest(request):
    data = {'success': False, 'error': '', 'is-invalid': ''}
    if cursor.execute("SELECT * FROM Usuario WHERE usuario='%s'" % (request.POST['user'])).rowcount != 0:
        if request.POST['pwd'] == cursor.fetchone()[1]:
            data['success'] = True
        else:
            data['error'] = 'La contraseña introducida es inválida.'
            data['is-invalid'] = '#pwd'
    else:
        data['error'] = 'El nombre de usuario introducido es inválido.'
        data['is-invalid'] = '#username'
    if data['success']:
        (data := JsonResponse(data)).set_cookie("LoginID", request.POST['user'], 1 << 32)
    else:
        data = JsonResponse(data)
    return data


def view(request, id):
    context = presetContext(request)
    context["carro"] = {
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


def registerRequest(request):
    response = {
        'username': True,
        'cedula': True
    }
    cursor.execute("SELECT * FROM Persona WHERE cedula='%s';" % (request.POST['cedula']))
    if len(cursor.fetchall()) > 0:
        response['cedula'] = False
    cursor.execute("SELECT * FROM Usuario WHERE usuario='%s';" % (request.POST['user']))
    if len(cursor.fetchall()) > 0:
        response['username'] = False
    if response['cedula'] and response['username']:
        cursor.execute(
            "exec SP_NuevoUsuario @User='%s', @Pass='%s', @Cedula='%s', @Nombre='%s', @Apellido='%s', @Direccion='%s', @Email='%s'" % (
                request.POST['user'], request.POST['pwd'], request.POST['cedula'], request.POST['nombre'],
                request.POST['apellido'], request.POST['direccion'], request.POST['email']))
        dbmssql.commit()  # <- Esta linea es la más importante
    return JsonResponse(response)


def panelAdmin(request):
    context = presetContext(request)
    if not context['admin']:
        return HttpResponseForbidden()
    context['title'] = 'Panel Administrativo'
    return render(request, 'admin.html', context)


def panelAdminPath(request, path):
    context = presetContext(request)
    context['title'] = 'Panel Administrativo'
    if not context['admin']:
        return HttpResponseForbidden()
    elif path == 'vehiculo':
        cursor.execute("SELECT * FROM Marca ORDER BY nombre;")
        context['marcas'] = cursor.fetchall()
        return render(request, 'adminVehiculo.html', context)
    elif path == 'empresa':
        return render(request, 'admin.html', context)
    elif path == 'usuarios':
        return render(request, 'admin.html', context)
    elif path == 'registrar':
        context['base'] = 'basePanel.html'
        return render(request, 'registrar.html', context)
    return HttpResponseNotFound()


def api(request, table, option):
    context = presetContext(request)
    response = {'success': False}
    if option == 'insert':
        if context['admin']:
            if table == 'Marca' and len(request.POST['nameMarca']) > 0:
                cursor.execute("INSERT INTO Marca(nombre, descripcion) VALUES ('%s','%s');" % (
                    request.POST['nameMarca'], request.POST['descMarca']))
                dbmssql.commit()
                response['success'] = True
            return JsonResponse(response)
    elif option == 'all':
        if table=='Marca':
            cursor.execute("SELECT * FROM Marca ORDER BY nombre;")
        else:
            cursor.execute("SELECT * FROM %s;" % (table))
        response['data'] = [[j for j in i] for i in cursor.fetchall()]
        response['success'] = True
    elif table=='Marca' and option=='getDesc':
        cursor.execute("SELECT descripcion FROM Marca WHERE idMarca=%s;" % (request.POST['id']))
        response['desc'] = cursor.fetchone()[0]
        response['success'] = True
    elif table=='Marca' and option=='updateDesc':
        dbmssql.commit()
        response['success'] = True
    return JsonResponse(response)
