namespace :load do
  task :defaults do
    set :service_file_local_dir,       Capistrano::SimpleSystemd::Paths.service_file_local_dir
    set :service_file_remote_dir,      Capistrano::SimpleSystemd::Paths.service_file_remote_dir
    set :service_file_prefix,          -> { fetch(:application) }
    set :enable_services_after_upload, true
  end
end