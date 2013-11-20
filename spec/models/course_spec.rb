require 'spec_helper'

describe Course do
  it 'has a valid factory' do
    build(:course).should be_valid
  end

  it 'is invalid without a proper name' do
    build(:course, {name: nil}).should_not be_valid
    build(:course, {name: ''}).should_not be_valid
  end

  it 'is invalid without a proper cost' do
    build(:course, {cost: nil}).should_not be_valid
    build(:course, {cost: -1}).should_not be_valid
    build(:course, {cost: 1_000_000}).should_not be_valid
  end

  describe "#video_count" do
    let(:course)   { create(:course) }
    let!(:section) { create(:section, course_id: course.id) }
    let!(:lecture)  { create(:lecture, section_id: section.id) }
    let!(:payload1) { create(:payload1, payloadable_type: "Lecture", payloadable_id: lecture.id) }
    let!(:payload2) { create(:payload2, payloadable_type: "Lecture", payloadable_id: lecture.id) }
    let!(:payload3) { create(:payload3, payloadable_type: "Lecture", payloadable_id: lecture.id) }

    it "counts video payloads" do
      course.video_count.should eq 2
    end
  end
end
