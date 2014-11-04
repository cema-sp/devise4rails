require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
	let(:user) { FactoryGirl.create(:user) }

	describe "get index page" do
	    describe "with no session" do
	      before { get :index }
	      it "should redirect to sign_in page" do
	        expect(response).to redirect_to new_user_session_path
	      end
	    end
	    describe "with valid session" do
	    	before { sign_in user }
	      before { get :index }

	      it "should redirect to home page" do
	        expect(response).to be_success
	      end
	    end
	end
end
