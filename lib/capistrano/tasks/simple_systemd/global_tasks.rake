include Capistrano::SimpleSystemd::Helpers
load "#{File.dirname(__FILE__)}/task_defaults.rake"

namespace :systemd do
  task :upload do
    original_pty_value = fetch(:pty)
    set :pty, true

    each_service_template do |template|
      template_basename = File.basename(template, '.service.erb')
      
      service_basename = [
        fetch(:service_file_prefix),
        template_basename
      ].join('-')

      service_filename = "#{service_basename}.service"
      enable_services_after_upload = fetch(:enable_services_after_upload)

      on release_roles :all do
        upload_service_file(
          compile(File.absolute_path(template)),
          service_filename,
          fetch(:service_file_remote_dir)
        )

        invoke "systemd:#{template_basename}:enable" if enable_services_after_upload
      end
    end

    set :pty, original_pty_value
  end

  task :'reload-daemons' do
    on release_roles :all do
      sudo :systemctl, :'daemon-reload'
      # puts fetch(:service_file_local_dir)
    end
  end
end

task :setup do
  invoke 'systemd:upload'
  invoke 'systemd:reload-daemons'
end