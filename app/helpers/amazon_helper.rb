# Helpers for Amazon signing of resources
module AmazonHelper
  # Signs S3 resource for streaming/downloading with CF
  #
  # @param [String] path The relative path of the S3 resource
  # @return [String] The signed url of the requested S3 resource
  def cloudfront_sign_paperclip_resource(path)
    path.slice!(0) if path[0]=='/'
    AWS::CF::Signer.sign_path(path).gsub('&', '%26').gsub('=', '%3D')
  end
end