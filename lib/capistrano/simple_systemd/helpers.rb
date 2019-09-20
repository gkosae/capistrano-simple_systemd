module Capistrano
  module SimpleSystemd
    module Helpers
      def each_service_template(&block)
        service_file_local_dir = Capistrano::SimpleSystemd::Paths.service_file_local_dir

        Dir
          .glob(File.join(service_file_local_dir, '*.service.erb'))
          .each do |template_file|
            block.call(template_file)
          end
      end
      
      def compile(template_file_path)
        ERB.new(File.new(template_file_path).read).result(binding)
      end
      
      def upload_service_file(file_content, file_name, destination_dir)
        tmp_path = "#{fetch(:tmp_dir)}/#{file_name}"
        upload! StringIO.new(file_content), tmp_path
        sudo :mv, tmp_path, "#{destination_dir}/#{file_name}"
      end
    end
  end
end