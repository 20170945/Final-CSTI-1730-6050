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
# dbmssql = pyodbc.connect(
#     "DRIVER={ODBC Driver 17 for SQL Server};SERVER=" + temp["IP"] + ";DATABASE=" + temp["Database"] + ";UID=" + temp[
#         "User"] + ";PWD=" +
#     temp["Pass"])
dbmssql = pyodbc.connect(
    "DRIVER={SQL Server};SERVER=" + temp["IP"] + ";DATABASE=" + temp["Database"] + ";UID=" + temp["User"] + ";PWD=" +
    temp["Pass"])
cursor = dbmssql.cursor()
cursor.execute("SELECT * FROM TipoVehiculo;")
tipos = [i for i in cursor.fetchall()]


def presetContext(request):
    preset = {
        "Empresa": config["Empresa"],
        "title": config['Empresa']["Nombre"],
        'tipos': tipos,
        'logged': False,
        'admin': False
    }
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


# TODO catalogo
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
        inquery = cursor.fetchone();
        if not inquery[2]:
            data['error'] = 'El usuario no esta aprobado.'
        elif request.POST['pwd'] == inquery[1]:
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


# TODO view
def view(request, id):
    context = presetContext(request)
    context["carro"] = {
        "marca": 'Toyota',
        "modelo": 'Nose',
        "year": 2010,
        "precio": 10000
    }
    return render(request, 'view.html', context)


# scrapped
# def perfil(request, id):
#     context = presetContext(request)
#     return render(request, 'perfil.html', context)
#
# def editarPerfil(request):
#     context = presetContext(request)
#     return render(request, 'vende.html', context)

# TODO contacto
def contacto(request):
    context = presetContext(request)
    context['title'] += ' - Contacto'
    return render(request, 'contacto.html', context)


# TODO directorio
def directorio(request):
    context = presetContext(request)
    context['title'] += ' - Directorio'
    return render(request, 'directorio.html', context)


# TODO vende
def vende(request):
    context = presetContext(request)
    context['title'] += ' - Vende'
    return render(request, 'vende.html', context)


def registerRequest(request):
    context = presetContext(request)
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
            "exec SP_NuevoUsuario @User='%s', @Pass='%s', @Cedula='%s', @Nombre='%s', @Apellido='%s', @Direccion='%s', @Email='%s', @Verificado=%s" % (
                request.POST['user'], request.POST['pwd'], request.POST['cedula'], request.POST['nombre'],
                request.POST['apellido'], request.POST['direccion'], request.POST['email'],
                '1' if context['admin'] else 'null'))
        dbmssql.commit()  # <- Esta linea es la más importante
    return JsonResponse(response)


def panelAdmin(request):
    context = presetContext(request)
    if not context['admin']:
        return HttpResponseForbidden()
    cursor.execute("SELECT * FROM Persona WHERE usuario='" + request.COOKIES['LoginID'] + "'")
    temp = cursor.fetchone()
    context['nombre'] = temp[1]
    context['apellido'] = temp[2]
    context['adminPanel'] = True
    context['title'] = 'Panel Administrativo'
    return render(request, 'admin.html', context)


def panelAdminPath(request, path, mode=None):
    context = presetContext(request)
    context['title'] = 'Panel Administrativo'
    context['adminPanel'] = True
    if not context['admin']:
        return HttpResponseForbidden()
    elif path == 'vehiculo':
        cursor.execute("SELECT * FROM Marca ORDER BY nombre;")
        context['marcas'] = cursor.fetchall()
        return render(request, 'adminVehiculo.html', context)
    elif path == 'empresa':
        cursor.execute("SELECT * FROM Empresa")
        context['empresas'] = cursor.fetchall()
        return render(request, 'adminEmpresa.html', context)
    elif path == 'usuarios':
        if mode == 'registrar':
            context['base'] = 'basePanel.html'
            return render(request, 'registrar.html', context)
        if mode == 'aprobar':
            cursor.execute("SELECT * FROM PersonaUsuario WHERE verificado is null;")
            context['clientes'] = cursor.fetchall()
            return render(request, 'adminAprobarUsuario.html', context)
        return render(request, 'adminUsuario.html', context)
    return HttpResponseNotFound()


allowed_tables = [
    "Marca", "Modelo", "ModeloConTipo", "Usuario"
]


def api(request, table, option):
    context = presetContext(request)
    response = {'success': False}
    if table not in allowed_tables:
        return HttpResponseNotFound()
    if option == 'insert':
        if context['admin']:
            if table == 'Marca' and len(request.POST['nameMarca']) > 0:
                cursor.execute("INSERT INTO Marca(nombre, descripcion) VALUES ('%s','%s');" % (
                    request.POST['nameMarca'], request.POST['descMarca']))
            elif table == 'Modelo':
                print(request.POST)
                cursor.execute(
                    "INSERT INTO Modelo(idMarca, idTipoVehiculo, nombre, ano, descripcion) VALUES (%s, %s, '%s', %s, '%s')" % (
                        request.POST['marcaID'], request.POST['tipoID'], request.POST['name'], request.POST['year'],
                        request.POST['desc']))
            dbmssql.commit()
            response['success'] = True
            return JsonResponse(response)
    elif option == 'update':
        if context['admin']:
            if table == "Marca":
                cursor.execute("UPDATE Marca SET descripcion='%s' WHERE idMarca=%s" % (
                request.POST['desc'], request.POST['marcaID']))
            elif table == "Usuario":
                cursor.execute("UPDATE Usuario SET verificado=%s WHERE usuario='%s'" % (
                    request.POST['aproved'], request.POST['username']))
            dbmssql.commit()
            response['success'] = True
            return JsonResponse(response)
    elif option == 'all':
        select = "SELECT * FROM " + table
        if 'columns' in request.POST:
            select = "SELECT " + request.POST['columns'] + " FROM " + table
        arguments = []
        for i in request.GET.keys():
            arguments.append('(' + " OR ".join(["%s='%s'" % (i, j) for j in request.GET.getlist(i)]) + ')')
        arguments = " AND ".join(arguments)
        if len(arguments) > 0:
            arguments = "WHERE " + arguments
        if 'orderby' in request.POST:
            arguments += " ORDER BY " + request.POST['orderby']
        cursor.execute(select + " " + arguments)
        response['data'] = [[j for j in i] for i in cursor.fetchall()]
        response['success'] = True
    elif table == 'Marca' and option == 'getDesc':
        cursor.execute("SELECT descripcion FROM Marca WHERE idMarca=%s;" % (request.POST['id']))
        response['desc'] = cursor.fetchone()[0]
        response['success'] = True
    elif table == 'Marca' and option == 'updateDesc':
        dbmssql.commit()
        response['success'] = True
    return JsonResponse(response)
