require 'rails_helper'

RSpec.describe RegistrationsController, :type => :controller do
  let(:user) { FactoryGirl.build(:user) }

  # set mapping for correct routes
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "Sign up" do
    describe "with invalid data" do
      before { user.email = nil }
      it "should not create a new user in db" do
        expect { user.save }.
          not_to change(User,:count)
      end
    end
    describe "with valid data" do
      it "should create a new user in db" do
        expect { user.save }.
          to change(User,:count).by(1)
      end
    end
  end
  describe "Update account" do
    let(:params) { {email: user.email, username: user.username} }
    let(:without_password_params) { [{address: "NewAddress"}] }
    let(:with_password_params) { [{username: "NewUsername".downcase}] }
    let(:confirmable_params) { [{email: "new@example.com"}] }
    before do 
      user.save! 
      sign_in user
    end
    subject { user.reload }

    describe "without current_password" do

      it "should change allowed params" do
        without_password_params.each do |param|
          params.update(param)
          expect { patch :update, user: params }.
            to change { user.reload.send(param.first[0]) }.
              to(param.first[1])
        end
      end
      it "should not change protected params" do
        with_password_params.each do |param|
          params.update(param)
          expect { patch :update, user: params }.
            not_to change { user.reload.send(param.first[0]) }
        end
      end
    end

    describe "with current_password" do
      before { params.update({ current_password: user.password }) }
      it "should change allowed params" do
        without_password_params.each do |param|
          params.update(param)
          expect { patch :update, user: params }.
            to change { user.reload.send(param.first[0]) }.
              to(param.first[1])
        end
      end
      it "should change protected params" do
        with_password_params.each do |param|
          params.update(param)
          expect { patch :update, user: params }.
            to change { user.reload.send(param.first[0]) }.
              to(param.first[1])
        end
      end
      it "should change confirmable params" do
        confirmable_params.each do |param|
          params.update(param)

          expect { patch :update, user: params }.
            to change { user.reload.send("unconfirmed_#{param.first[0]}") }.
              to(param.first[1])
          
          expect { user.confirm! }.
            to change { user.reload.send(param.first[0]) }.
              to(param.first[1])
        end
      end
    end
  end
  describe "Cancel account" do
    before { user.save! }
    describe "without sign in" do
      it "should not destroy user" do
        expect { delete :destroy }.
          not_to change(User,:count)
      end
    end
    describe "with sign in" do
      before { sign_in user }
      it "should destroy user" do
        expect { delete :destroy }.
          to change(User,:count).by(-1)
      end
    end
  end
end
