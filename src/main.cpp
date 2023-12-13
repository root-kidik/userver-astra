#include <userver/components/minimal_server_component_list.hpp>
#include <userver/testsuite/testsuite_support.hpp>
#include <userver/ugrpc/client/client_factory_component.hpp>
#include <userver/ugrpc/server/server_component.hpp>
#include <userver/utils/daemon_run.hpp>

#include "greeter_service.hpp"

int main(int argc, char* argv[])
{
    const auto component_list = userver::components::MinimalServerComponentList()
                                    .Append<userver::components::TestsuiteSupport>()
                                    .Append<userver::ugrpc::client::ClientFactoryComponent>()
                                    .Append<userver::ugrpc::server::ServerComponent>()
                                    .Append<greeter_service::GreeterServiceComponent>();

    return userver::utils::DaemonMain(argc, argv, component_list);
}
