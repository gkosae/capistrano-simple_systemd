include Capistrano::SimpleSystemd::Helpers

namespace :load do
  task :defaults do
    set :service_file_remote_dir,      '/etc/systemd/system'
    set :service_file_prefix,          -> { fetch(:application) }
    set :enable_services_after_upload, true
  end
end

task :setup do
  invoke 'systemd:upload'
  invoke 'systemd:reload-daemons'
end

namespace :systemd do
  task :upload do
    on release_roles :all do
      each_service_template do |template|
        template_basename = File.basename(template, '.service.erb')
        service_basename = [ fetch(:service_file_prefix), template_basename ].join('-')
        service_filename = "#{service_basename}.service"
        upload_template(template, service_filename)
      end

      invoke_on_all(:enable) if fetch(:enable_services_after_upload)
    end
  end

  task :enable do
    on release_roles :all do
      invoke_on_all(:enable)
    end
  end

  task :disable do
    on release_roles :all do
      invoke_on_all(:disable)
    end
  end

  task :remove do
    on release_roles :all do
      invoke_on_all(:remove)
    end
  end

  task :'reload-daemons' do
    on release_roles :all do
      sudo :systemctl, :'daemon-reload'
    end
  end

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
        upload:               "Upload service file for %{service} service",
        remove:               "Remove service file for %{service} service"
      }.each do |task_name, desc_template|
        desc(desc_template % { service: template_basename, task_name: task_name})
        task task_name do
          service_basename = [ fetch(:service_file_prefix), template_basename ].join('-')
          service_filename = "#{service_basename}.service"

          on release_roles :all do
            case task_name
            when :upload  
              on release_roles :all do
                upload_template(template, service_filename)

                if fetch(:enable_services_after_upload)
                  invoke! "systemd:#{template_basename}:enable"
                end
              end
            when :remove
              invoke "systemd:#{template_basename}:disable"
              service_file_path = "#{fetch(:service_file_remote_dir)}/#{service_filename}"
              sudo :rm, service_file_path
              invoke! "systemd:reload-daemons"
            else
              sudo :systemctl, task_name, "#{service_basename}.service"
            end
          end
        end
      end
    end
  end
end