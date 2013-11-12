require 'spec_helper'

describe User do
  it 'has a valid factory' do
    build(:user).should be_valid
    build(:user_admin).should be_valid
  end

  describe 'Class methods' do
    it 'Should be able to generate unique username' do
      user1 = create(:user)
      user2 = build(:user)
      user2.username = User.generate_unique_username(user2.firstname, user2.lastname)
      user1.username.should_not == user2.username
    end
  end

  describe 'Instance methods' do
    it 'should display the correct fullname' do
      user = create(:user)
      user.fullname.should == "#{user.firstname} #{user.lastname}"
    end

    it "has affiliate urls for each course" do
      course = create(:course)
      user = create(:user)
      expect(user.affiliate_urls).to eq "beasn"
    end
  end

  describe 'Course authorization' do
    it 'is not authorized without a CourseUser object' do
      user   = create(:user)
      course = create(:course)
      expect(user.subscribed_course?(course)).to eq false
    end

    it 'is authorized when CourseUser object exists' do
      user               = create(:user)
      course             = create(:course)
      course_user        = CourseUser.new
      course_user.user   = user
      course_user.course = course
      course_user.save!
      expect(user.subscribed_course?(course)).to eq true
    end
  end

  describe 'User creation' do
    context 'within the admin tool' do
      it 'skips confirmation' do
        user = build(:user)
        user.skip_confirmation!
        user.save!
        expect(last_email).to be_nil
      end
    end
  end
end
