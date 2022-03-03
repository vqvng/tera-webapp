from flask import render_template
from flask import request
from app import app
from app import cache

cache.set('hello', 'World')

@app.route('/')
def index():
	"""

	"""
	hello = cache.get('hello')
	return render_template('hello.html', name=hello)

@app.route('/hello', methods=['GET', 'POST'])
def handle_hello():
	"""
	"""
	if request.method == "POST":
		if request.data:
			hello = request.data.decode('utf-8')
			cache.set('hello', hello)
		else:
			return "data must contain a string", 400

	hello = cache.get('hello')
	return hello