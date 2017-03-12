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

		return dict(id=producto[0], nombre=producto[1], descripcion=producto[2], foto=producto[3], precio=producto[4], cantVendida=producto[5], idCategoria=producto[6])

	def put(self, idP):
		productos[idP] = request.form['data']
		productos['cantidad'] = request.form['cant']
		productos['prod_ep'] = request.form['prod_ep']
		return {idP: productos[idP], "cantidad" : productos['cantidad'], "prod_ep" : productos['prod_ep']}

class ProductosList(Resource):
	def get(self):
		con = mysql.connect()
		cursor = con.cursor()

		cursor.execute("SELECT * FROM producto")
		data = cursor.fetchall()

		return ([dict(id=producto[0], nombre=producto[1], descripcion=producto[2], foto=producto[3], precio=producto[4], cantVendida=producto[5], idCategoria=producto[6]) for producto in data])



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



api.add_resource(Register, '/register')
api.add_resource(Login, '/login')
api.add_resource(Productos, '/productos/<string:idP>', endpoint='prod_ep')
api.add_resource(ProductosList, '/productos')


if __name__ == '__main__':
	app.run(debug=True)