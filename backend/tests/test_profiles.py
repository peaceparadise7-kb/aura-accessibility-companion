def test_list_profiles(client):
    response = client.get("/api/v1/profiles")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 1
    assert data[0]["category"] == "microwave"


def test_get_profile_by_id_found(client):
    response = client.get("/api/v1/profiles/panasonic_nn_sd372s_microwave")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "panasonic_nn_sd372s_microwave"
    assert "controls" in data
    assert len(data["controls"]) >= 2


def test_get_profile_by_id_not_found(client):
    response = client.get("/api/v1/profiles/unknown_model")
    assert response.status_code == 404
    assert response.json()["detail"] == "Profile 'unknown_model' not found"
