module Capistrano
  module SimpleSystemd
    module Paths
      def self.service_file_local_dir
        'config/systemd'
      end

      def self.service_file_remote_dir
        '/etc/systemd/system'
      end
    end
  end
end