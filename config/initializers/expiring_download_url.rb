module Paperclip
  module Storage
    module S3
      def expiring_download_url(time = 3600, style_name = default_style)
        if path
          base_options = { :expires => time, :secure => use_secure_protocol?(style_name), :response_content_disposition => "attachment; filename=#{original_filename};" }
          s3_object(style_name).url_for(:read, base_options.merge(s3_url_options)).to_s
        else
          url
        end
      end
    end
  end
end
