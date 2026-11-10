from unittest.mock import Mock

import pytest
from fastapi.testclient import TestClient

from app.api.routes import automatic_thought, situation
from app.application.errors import (
    ConfigurationError,
    InvalidModelResponseError,
    UpstreamServiceError,
)
from app.main import app
from app.schemas.situation import SituationRefineResult


ROUTES = [
    (
        situation,
        "get_refine_situation_use_case",
        "/api/situation/refine",
        {"raw_situation": "synthetic"},
    ),
    (
        automatic_thought,
        "get_generate_automatic_thoughts_use_case",
        "/api/automatic-thoughts/generate",
        {"situation": "synthetic"},
    ),
]


@pytest.mark.parametrize("module,factory,url,payload", ROUTES)
@pytest.mark.parametrize(
    "error,status",
    [
        (ValueError, 400),
        (InvalidModelResponseError, 502),
        (UpstreamServiceError, 502),
        (ConfigurationError, 500),
        (RuntimeError, 500),
    ],
)
@pytest.mark.parametrize("during_construction", [False, True])
def test_failures_use_safe_status_and_do_not_log_private_content(
    module,
    factory,
    url,
    payload,
    error,
    status,
    during_construction,
    monkeypatch,
    caplog,
):
    private = "PRIVATE_SYNTHETIC_INPUT_AND_PROVIDER_BODY"
    use_case = Mock()
    getter = Mock(return_value=use_case)
    (getter if during_construction else use_case.execute).side_effect = error(private)
    monkeypatch.setattr(module, factory, getter)
    response = TestClient(app, raise_server_exceptions=False).post(url, json=payload)
    assert response.status_code == status
    getter.assert_called_once()
    assert private not in response.text
    assert private not in caplog.text


@pytest.mark.parametrize("module,factory,url,payload", ROUTES)
def test_valid_request_and_blank_input(module, factory, url, payload, monkeypatch):
    use_case = Mock()
    use_case.execute.return_value = (
        SituationRefineResult(
            original="original", feedback="feedback", reframed="reframed"
        )
        if module is situation
        else ["thought"]
    )
    monkeypatch.setattr(module, factory, lambda: use_case)
    client = TestClient(app)
    assert client.post(url, json=payload).status_code == 200
    assert client.post(url, json={}).status_code == 422


def test_health_requires_no_provider_call():
    assert TestClient(app).get("/health").json() == {"status": "ok"}


def test_cors_only_allows_configured_local_web_origin():
    client = TestClient(app)
    for origin, allowed in [
        ("http://localhost:7357", True),
        ("https://example.invalid", False),
    ]:
        response = client.options(
            "/api/situation/refine",
            headers={"Origin": origin, "Access-Control-Request-Method": "POST"},
        )
        assert (
            response.headers.get("access-control-allow-origin") == origin
        ) is allowed
        assert "access-control-allow-credentials" not in response.headers
