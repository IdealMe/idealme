# Ideal Me Exceptions
module IdealmeException
  # IdealMe RecordNotFound Exception
  class RecordNotFound < StandardError
  end
  module Ajax
    # IdealMe AjaxEarlyBailout Exception
    class EarlyBailout < StandardError
    end
  end
end