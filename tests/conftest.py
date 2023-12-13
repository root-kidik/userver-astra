import pathlib
import sys

import pytest
import grpc

USERVER_CONFIG_HOOKS = ["_prepare_service_config"]
pytest_plugins = [
    "pytest_userver.plugins.grpc",
]


@pytest.fixture(scope="session")
def greeter_protos():
    return grpc.protos("greeter_service.proto")


@pytest.fixture(scope="session")
def greeter_services():
    return grpc.services("greeter_service.proto")


@pytest.fixture
def grpc_service(greeter_services, grpc_channel, service_client):
    return greeter_services.GreeterServiceStub(grpc_channel)


@pytest.fixture(scope="session")
def _prepare_service_config(grpc_mockserver_endpoint):
    def patch_config(config, config_vars):
        components = config["components_manager"]["components"]

    return patch_config


def pytest_configure(config):
    sys.path.append(str(pathlib.Path(__file__).parent.parent / "proto/api/"))


@pytest.fixture(scope="session")
def service_source_dir():
    """Path to root directory service."""
    return pathlib.Path(__file__).parent.parent
