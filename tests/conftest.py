# conftest.py
#
# pytest fixture for tera-webapp
import pytest

from app import app

@pytest.fixture
def hello_app():
    return app