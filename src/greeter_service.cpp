#include "greeter_service.hpp"

#include <userver/components/component_config.hpp>
#include <userver/components/component_context.hpp>
#include <userver/ugrpc/client/client_factory_component.hpp>
#include <userver/yaml_config/merge_schemas.hpp>
#include <userver/yaml_config/schema.hpp>

namespace greeter_service
{

GreeterServiceComponent::GreeterServiceComponent(const userver::components::ComponentConfig&  config,
                                                 const userver::components::ComponentContext& context) :
api::greeter_service::GreeterServiceBase::Component(config, context),
prefix_(config["greeting-prefix"].As<std::string>())
{
}


void GreeterServiceComponent::SayHello(api::greeter_service::GreeterServiceBase::SayHelloCall& call,
                                       api::greeter_service::GreetingRequest&&                 request)
{
    api::greeter_service::GreetingResponse response;
    response.set_greeting(fmt::format("{}, {}!", prefix_, request.name()));

    call.Finish(response);
}

userver::yaml_config::Schema GreeterServiceComponent::GetStaticConfigSchema()
{
    return userver::yaml_config::MergeSchemas<userver::ugrpc::server::ServiceComponentBase>(R"(
type: object
description: gRPC sample greater service component
additionalProperties: false
properties:
    greeting-prefix:
        type: string
        description: greeting prefix
)");
}

} // namespace greeter_service
