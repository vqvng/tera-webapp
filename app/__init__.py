import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379, db=0, decode_responses=True)

from . import hello