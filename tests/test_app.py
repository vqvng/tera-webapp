

class TestApp:

	def test_hello_world(self, hello_app):
		with hello_app.test_client() as client:
			response = client.get('/')
			assert response.status_code == 200
			assert b'<!doctype html>\n<title>Hello</title>\n<h1>Hello World!</h1>' == response.data

	def test_get_hello_world(self, hello_app):
		with hello_app.test_client() as client:
			response = client.get('/hello')
			assert response.status_code == 200
			assert b'World' == response.data

	def test_set_hello_hello(self, hello_app):
		with hello_app.test_client() as client:
			response = client.post('/hello', data='hello')
			assert response.status_code == 200
			assert b'hello' == response.data

	def test_set_hello_empty(self, hello_app):
		with hello_app.test_client() as client:
			response = client.post('/hello')
			assert response.status_code == 400
			assert b'data must contain a string' == response.data

	def test_set_hello_not_string(self, hello_app):
		with hello_app.test_client() as client:
			response = client.post('/hello', data={'hello': 'no string'})
			assert response.status_code == 400
			assert b'data must contain a string' == response.data

	def test_set_get_hello(self, hello_app):
		with hello_app.test_client() as client:
			response = client.post('/hello', data='app')
			assert response.status_code == 200
			assert b'app' == response.data
			response = client.get('/hello')
			assert response.status_code == 200
			assert b'app' == response.data