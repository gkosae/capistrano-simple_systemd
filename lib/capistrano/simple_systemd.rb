require 'capistrano/simple_systemd/paths'
require 'capistrano/simple_systemd/helpers'
load File.expand_path('../tasks/simple_systemd/global_tasks.rake', __FILE__)
load File.expand_path('../tasks/simple_systemd/specific_tasks.rake', __FILE__)