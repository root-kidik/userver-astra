"""Tests greeter service"""


async def test_say_hello_1(greeter_protos, grpc_service):
    """Test say hello 1"""
    request = greeter_protos.GreetingRequest(name="userver")
    response = await grpc_service.SayHello(request)
    assert response.greeting == "Hello, userver!"


async def test_say_hello_2(greeter_protos, grpc_service):
    """Test say hello 2"""
    request = greeter_protos.GreetingRequest(name="grpc")
    response = await grpc_service.SayHello(request)
    assert response.greeting == "Hello, grpc!"


async def test_say_hello_3(greeter_protos, grpc_service):
    """Test say hello 2"""
    request = greeter_protos.GreetingRequest(name="lemz-t")
    response = await grpc_service.SayHello(request)
    assert response.greeting == "Hello, lemz-t!"
