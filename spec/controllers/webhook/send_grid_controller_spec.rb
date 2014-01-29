require 'spec_helper'

describe Webhook::SendGridController do
  let!(:user) {create(:user, email: "john.doe@sendgrid.com")}
  it "receives notifications from sendgrid and tags users if imtags are found in query params" do
    post :notify, _json: <<-HEREDOC
[
    {
        "email": "john.doe@sendgrid.com",
        "timestamp": 1337197600,
        "smtp-id": "<4FB4041F.6080505@sendgrid.com>",
        "event": "processed"
    },
    {
        "email": "john.doe@sendgrid.com",
        "timestamp": 1337966815,
        "smtp-id": "<4FBFC0DD.5040601@sendgrid.com>",
        "category": "newuser",
        "url": "http://ruby-doc.org/core-2.1.0/String.html?iminterest=weight-loss,finance#method-i-strip",
        "event": "clicked"
    },
    {
        "email": "john.doe@sendgrid.com",
        "timestamp": 1337966815,
        "smtp-id": "<4FBFC0DD.5040601@sendgrid.com>",
        "category": "newuser",
        "url": "http://ruby-doc.org/core-2.1.0/String.html?imxtags=weight-loss,finance#method-i-strip",
        "event": "clicked"
    },
    {
        "email": "john.doe@sendgrid.com",
        "timestamp": 1337969592,
        "smtp-id": "<20120525181309.C1A9B40405B3@Example-Mac.local>",
        "event": "processed"
    }
]
HEREDOC

    user.interest_list.should include "weight-loss"
    user.interest_list.should include "finance"
  end
end
