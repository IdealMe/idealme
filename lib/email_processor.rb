class EmailProcessor
  def self.process(email)
    # all of your application-specific code here - creating models,
    # processing reports, etc


    Rails.logger.debug email.inspect
  end
end
