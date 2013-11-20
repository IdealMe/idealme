
FactoryGirl.define do
  factory :payload do |payload|
    payload.intended_type IM_PAYLOAD_DOCUMENT
    payload.payloadable_id nil
    payload.payloadable_type nil
    payload.dropbox_path nil
    factory :payload1 do
      intended_type IM_PAYLOAD_VIDEO
    end
    factory :payload2 do
      intended_type IM_PAYLOAD_AUDIO
    end

    factory :payload3 do
      intended_type IM_PAYLOAD_VIDEO
    end

  end
end
