import pytest
import json

# Basic test the profile API
# To be expanded when we receive data from DB -Jordan
def test_profile(client):

    # Check we get a response
    response = client.get('/profile', follow_redirects=True)
    assert response.status_code == 200
    
    
    data = json.loads(response.data)
    assert "profile" in data
    profile = data["profile"]

    assert "name" in profile
    assert "age" in profile



