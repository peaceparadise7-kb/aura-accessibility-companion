import pytest
from backend.app.main import app
from fastapi.testclient import TestClient


@pytest.fixture(scope="function")
def client():
    """
    TestClient fixture managing startup/shutdown lifecycles for each test function.
    """
    with TestClient(app) as test_client:
        yield test_client
