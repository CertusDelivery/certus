require 'spec_helper'

describe User do
  it "has expiring user sessions in 30 minutes" do
    User.logged_in_timeout.should equal 30.minutes.to_i
    UserSession.logout_on_timeout.should be_true
  end

  describe "validations" do
    subject do
      User.new
    end

    it "requires the first name" do
      should have(1).error_on(:first_name)
    end

    it "requires the last name" do
      should have(1).error_on(:last_name)
    end

    it "requires the email" do
      subject.valid?
      should have(1).error_on(:email)
    end

    it "requires the login be present" do
      subject.valid?
      subject.errors[:login].should_not be_nil
    end

    it "allows duplicate emails" do
      create(:user, :email => "a@b.com")
      subject.email = "a@b.com"
      should have(0).errors_on(:email)
    end

    it "requires a password for an activating user" do
      should have(1).errors_on(:password)
    end

    it "requires a role" do
      subject.role = ''
      should have(1).error_on(:role)
    end

    it "does not allow a random role" do
      subject.role = "guest"
      should have(1).error_on(:role)
    end

    it 'should create an admin user' do
      user = create(:user, :role => 'admin')
      user.should be_valid
    end
  end
end
