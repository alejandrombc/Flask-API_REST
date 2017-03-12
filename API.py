from flask import Flask, request, json
from flask_restful import Resource, Api, reqparse, abort
from datetime import datetime, date, time, timedelta
import jwt, calendar, hashlib, time
from flaskext.mysql import MySQL


errors = {
    'UsuarioExistente': {
        'message': "Este usuario ya existe",
        'register_value' : False,
        'status': 409,
    },
    'RecursoNoExistente': {
        'message': "El recurso con ese ID no existe",
        'status': 410,
        'resource_value': False,
    },
   	'ErrorLogin': {
        'message': "Las credenciales ingresadas no son validas",
        'status': 410,
        'login_value': False,
    },
    'ProductoNotFound': {
        'message': "El producto seleccionado no existe",
        'status': 404,
        'product_value': False,
    },
    'ProductoYaCreado': {
        'message': "El producto que sea ingresar ya esta creado",
        'status': 410,
        'product_value': False,
    }
}


success = {
    'RegistroCompletado': {
        'message': "Usuario registrado con exito!",
        'register_value' : True,
        'status': 201,
    },
    'LoginCompletado':{
    	'message': "Login realizado exitosamente",
    	'access_token' : True,
    	'status' : 200,
    	'login_value' : True
    },
    'ProductoAgregado':{
    	'message': "Producto agregado exitosamente",
    	'status' : 200,
    	'product_value' : True
    },
    'ProductoEditado':{
    	'message': "Producto editado exitosamente",
    	'status' : 200,
    	'product_value' : True
    }
}


app = Flask(__name__)
api = Api(app, errors=errors)
mysql = MySQL()
mysql.init_app(app)

app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '123'
# app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'jgastore'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.secret_key = "Estodeberiaserandom"


class Productos(Resource):
	def get(self, idP):

		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT * FROM producto WHERE idProducto=%s", (idP))
		producto = cursor.fetchone()

		if(producto != None): return dict(id=producto[0], nombre=producto[1], descripcion=producto[2], foto=producto[3], precio=producto[4], cantVendida=producto[5], idCategoria=producto[6])

		return errors['ProductoNotFound'], 404


class ProductosList(Resource):
	def get(self):
		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT * FROM producto")
		data = cursor.fetchall()

		return ([dict(id=producto[0], nombre=producto[1], descripcion=producto[2], foto=producto[3], precio=producto[4], cantVendida=producto[5], idCategoria=producto[6]) for producto in data])

	def post(self):
		producto = request.get_json()

		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT idProducto from producto WHERE idProducto=%s", (producto['idProducto']))
		hay_producto = cursor.fetchone()

		if(hay_producto != None): return errors['ProductoYaCreado'], 410

		cursor.execute("INSERT INTO producto VALUES (%s,%s,%s,%s,%s,%s,%s)", (producto['idProducto'], producto['nombre'], producto['descripcion'], producto['foto'], producto['precio'], producto['cantVendida'], producto['idCategoria']))
		con.commit()

		return success['ProductoAgregado'], 200

	def put(self):
		producto = request.get_json()

		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT * from producto WHERE idProducto=%s", (producto['idProducto']))
		hay_producto = cursor.fetchone()

		if(hay_producto == None): return errors['ProductoNotFound'], 410


		if(producto['idProducto'] == None): producto['idProducto'] = hay_producto[0]
		if(producto['nombre'] == None): producto['nombre'] = hay_producto[1]
		if(producto['descripcion'] == None): producto['descripcion'] = hay_producto[2]
		if(producto['foto'] == None): producto['foto'] = hay_producto[3]
		if(producto['precio'] == None): producto['precio'] = hay_producto[4]	
		if(producto['cantVendida'] == None): producto['cantVendida'] = hay_producto[5]	
		if(producto['idCategoria'] == None): producto['idCategoria'] = hay_producto[6]	


		cursor.execute("UPDATE producto SET idProducto=%s, nombre=%s, descripcion=%s, foto=%s, precio=%s, cantVendida=%s, idCategoria=%s WHERE idProducto=%s", (producto['idProducto'], producto['nombre'], producto['descripcion'], producto['foto'], producto['precio'], producto['cantVendida'], producto['idCategoria'], producto['idProducto']))
		con.commit()

		return success['ProductoEditado'], 200


class Register(Resource):
	def post(self):
		data = request.get_json()

		con = mysql.connect()
		cursor = con.cursor()

		hashinput_email = hashlib.sha256(str(data['email']).encode('utf-8')).hexdigest() #Le hice cifrado sha256
		cursor.execute("SELECT email from cliente WHERE email=%s", (hashinput_email))
		email_actual = cursor.fetchone()

		if(email_actual != None): return errors['UsuarioExistente'], 409

		hashinput_password = hashlib.sha256(str(data['password']).encode('utf-8')).hexdigest() #Le hice cifrado sha256

		hashinput_user = hashlib.sha256(str(data['username']).encode('utf-8')).hexdigest() #Le hice cifrado sha256

		cursor.execute("INSERT INTO cliente VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", (hashinput_email, data['nombre'], data['apellido'], hashinput_user, hashinput_password, data['fotoPerfil'],data['fechaNacimiento'],data['genero'],data['telefono'],data['ciudad']))
		con.commit()
		return success['RegistroCompletado'], 201


class Login(Resource):
	def post(self):

		data = request.get_json()
		hashinput_email = hashlib.sha256(str(data['email']).encode('utf-8')).hexdigest() #Le hice cifrado sha256
		hashinput_password = hashlib.sha256(str(data['password']).encode('utf-8')).hexdigest() #Le hice cifrado sha256

		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT email FROM cliente WHERE email=%s AND password=%s", (hashinput_email,hashinput_password))
		check_log = cursor.fetchone()

		if(check_log != None): 
			#Obtengo la fecha y hora actual
			ahora = time.time()
			#Sumo 30 minutos a la fecha actual
			mas_30_min = 30*60
			hoy_mas_30_minutos = ahora + mas_30_min


			payload = {
			    'sub' : hashinput_email,
			    'iat' : ahora,
			    'exp' : hoy_mas_30_minutos
			}

			cod = jwt.encode( payload , 'secret', algorithm='HS256')
			cod = str(cod).split("'")
			# decod = jwt.decode('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0ODg3MzI0MTcuODE3NjAyNiwic3ViIjoiZ3JlZ2Nhc3RybyIsImlhdCI6MTQ4ODczMDYxNy44MTc2MDI2fQ.nP_agpytvkn1l2QsNrrSJtZ-PB69pxUvQ8SVp1SbRY4', 'secret')

			success['LoginCompletado']['access_token'] = cod[1]
			return success['LoginCompletado'], 200

		return errors['ErrorLogin'], 410

class InfoUser(Resource):
	def get(self):

		usuario = request.headers.get('access_token')
		con = mysql.connect()
		cursor = con.cursor()

		if(usuario != None): 
			decod = jwt.decode(usuario, 'secret')

			cursor.execute("SELECT * FROM cliente WHERE email=%s", (decod['sub']))
			data = cursor.fetchone()
			return dict(nombre=data[1], apellido=data[2], fotoPerfil=data[5], fechaNacimiento=data[6], genero=data[7], telefono=data[8], ciudad=data[9])

		return errors['RecursoNoExistente'], 404



api.add_resource(Register, '/register')
api.add_resource(Login, '/login')
api.add_resource(Productos, '/productos/<string:idP>', endpoint='prod_ep')
api.add_resource(ProductosList, '/productos')
api.add_resource(InfoUser, '/usuario')


if __name__ == '__main__':
	app.run(debug=True)