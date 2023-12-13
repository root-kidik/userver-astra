#pragma once

#include <userver/components/component_config.hpp>
#include <userver/components/component_context.hpp>
#include <userver/ugrpc/client/client_factory.hpp>
#include <userver/yaml_config/schema.hpp>

#include <api/greeter_service_service.usrv.pb.hpp>

namespace greeter_service
{

class GreeterServiceComponent final : public api::greeter_service::GreeterServiceBase::Component
{
public:
    static constexpr std::string_view kName = "greeter-service";

    GreeterServiceComponent(const userver::components::ComponentConfig&  config,
                            const userver::components::ComponentContext& context);

    void SayHello(api::greeter_service::GreeterServiceBase::SayHelloCall& call,
                  api::greeter_service::GreetingRequest&&                 request) override;

    static userver::yaml_config::Schema GetStaticConfigSchema();

private:
    const std::string prefix_;
};

} // namespace greeter_service
