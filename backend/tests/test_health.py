def test_health_check_returns_200(client):
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "version" in data
    assert "timestamp" in data


def test_root_returns_links(client):
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "health" in data
    assert "docs" in data
