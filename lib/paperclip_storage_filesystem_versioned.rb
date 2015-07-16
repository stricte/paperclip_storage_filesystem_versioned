require "paperclip_storage_filesystem_versioned/version"
require "paperclip"

module Paperclip
  module Storage
    module FilesystemVersioned
      def self.extended base
        base.instance_eval do
          @versioning = @options[:versioning] || true

          if @versioning
            @version_proc = @options[:version_proc] || Proc.new { |attachment, style| attachment.instance.versions.count}

            unless @options[:url].to_s.match(/\/:version\//)
              @options[:url] = @options[:url].gsub(/\/:id_partition\//, '/:id_partition/:version/')
            end

            unless @options[:path].to_s.match(/\/:version\//)
              @options[:path] = @options[:path].gsub(/\/:id_partition\//, '/:id_partition/:version/')
            end
          end
        end

        Paperclip.interpolates(:version) do |attachment, style|
          attachment.version_proc.call(attachment, style) if attachment.version_proc.is_a?(Proc)
        end unless Paperclip::Interpolations.respond_to? :version
      end

      def versioning
        @versioning
      end

      def version_proc
        @version_proc
      end

      def exists?(style_name = default_style)
        if original_filename
          File.exist?(path(style_name))
        else
          false
        end
      end

      def flush_writes #:nodoc:
        @queued_for_write.each do |style_name, file|
          FileUtils.mkdir_p(File.dirname(path(style_name)))
          begin
            FileUtils.mv(file.path, path(style_name))
          rescue SystemCallError
            File.open(path(style_name), "wb") do |new_file|
              while chunk = file.read(16 * 1024)
                new_file.write(chunk)
              end
            end
          end
          unless @options[:override_file_permissions] == false
            resolved_chmod = (@options[:override_file_permissions] &~ 0111) || (0666 &~ File.umask)
            FileUtils.chmod( resolved_chmod, path(style_name) )
          end
          file.rewind
        end

        after_flush_writes # allows attachment to clean up temp files

        @queued_for_write = {}
      end

      def flush_deletes #:nodoc:
        if versioning
          log("Cleared list of queued_for_delete because of versionig turned on")
          @queued_for_delete = []
        else
          @queued_for_delete.each do |path|
            begin
              log("deleting #{path}")
              FileUtils.rm(path) if File.exist?(path)
            rescue Errno::ENOENT => e
              # ignore file-not-found, let everything else pass
            end
            begin
              while(true)
                path = File.dirname(path)
                FileUtils.rmdir(path)
                break if File.exist?(path) # Ruby 1.9.2 does not raise if the removal failed.
              end
            rescue Errno::EEXIST, Errno::ENOTEMPTY, Errno::ENOENT, Errno::EINVAL, Errno::ENOTDIR, Errno::EACCES
              # Stop trying to remove parent directories
            rescue SystemCallError => e
              log("There was an unexpected error while deleting directories: #{e.class}")
              # Ignore it
            end
          end
          @queued_for_delete = []
        end
      end

      def copy_to_local_file(style, local_dest_path)
        FileUtils.cp(path(style), local_dest_path)
      end
    end
  end
end
