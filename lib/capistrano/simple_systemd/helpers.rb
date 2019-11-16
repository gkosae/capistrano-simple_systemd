module Capistrano
  module SimpleSystemd
    module Helpers
      def each_service_template(&block)
        service_file_local_dir = Capistrano::SimpleSystemd::Paths::SERVICE_FILE_LOCAL_DIR

        Dir
          .glob(File.join(service_file_local_dir, '*.service.erb'))
          .each { |template_file| block.call(template_file) }
      end

      def invoke_on_all(task)
        each_service_template do |template|
          basename = File.basename(template, '.service.erb')
          invoke! "systemd:#{basename}:#{task}"
        end
      end


      def upload_template(template, service_file_name)
        file_content = compile(File.absolute_path(template))
        tmp_path     = "#{fetch(:tmp_dir)}/#{service_file_name}"

        upload! StringIO.new(file_content), tmp_path
        sudo :mv, tmp_path, "#{fetch(:service_file_remote_dir)}/#{service_file_name}"
      end
      
      def compile(template_path)
        ERB.new(File.new(template_path).read).result(binding)
      end
    end
  end
end