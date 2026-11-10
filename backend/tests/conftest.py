"""Tests use in-process HTTP and fake LLMs, never external services."""

import os
import socket

import pytest

os.environ["GROQ_API_KEY"] = "test-placeholder-not-a-real-key"


@pytest.fixture(autouse=True)
def block_network(monkeypatch):
    original_connect = socket.socket.connect
    original_connect_ex = socket.socket.connect_ex

    def local_only(original):
        def guarded(sock, address):
            # Windows asyncio uses loopback sockets to wake its event loop.
            if isinstance(address, tuple) and address[0] in ("127.0.0.1", "::1"):
                return original(sock, address)
            raise AssertionError("External network access is forbidden in tests.")

        return guarded

    monkeypatch.setattr(socket.socket, "connect", local_only(original_connect))
    monkeypatch.setattr(socket.socket, "connect_ex", local_only(original_connect_ex))
