require 'rails_helper'

RSpec.describe Devise::SessionsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  # set mapping for correct routes
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "Sign in" do
    describe "with invalid credentials" do
      let(:wrong_user) { FactoryGirl.build(:user, email: "wrong@example.com") }
      before { sign_in wrong_user }
      its(:current_user) { should be_nil }
    end
    describe "with valid credentials" do
      before { sign_in user }
      its(:current_user) { should eq(user) }
    end
  end
  describe "Sign out" do
    before do
      sign_in user
      sign_out user
    end
    its(:current_user) { should be_nil }
  end
end
