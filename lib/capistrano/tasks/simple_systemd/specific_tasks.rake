include Capistrano::SimpleSystemd::Helpers
load "#{File.dirname(__FILE__)}/task_defaults.rake"

namespace :systemd do
  each_service_template do |template|
    template_basename = File.basename(template, '.service.erb')

    namespace template_basename do
      {
        start:                "Run systemctl %{task_name} for %{service} service",
        stop:                 "Run systemctl %{task_name} for %{service} service",
        reload:               "Run systemctl %{task_name} for %{service} service",
        restart:              "Run systemctl %{task_name} for %{service} service",
        "reload-or-restart":  "Run systemctl %{task_name} for %{service} service",
        enable:               "Run systemctl %{task_name} for %{service} service",
        disable:              "Run systemctl %{task_name} for %{service} service",
      }.each do |task_name, desc_template|
        desc(desc_template % { service: template_basename, task_name: task_name})
        task task_name do
          on release_roles :all do
            service_basename = [
              fetch(:service_file_prefix),
              template_basename
            ].join('-')

            sudo :systemctl, task_name, "#{service_basename}.service"
          end
        end
      end
    end
  end
end