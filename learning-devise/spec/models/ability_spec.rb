require 'rails_helper'

RSpec.describe Ability, :type => :model do
  let(:user) { nil }
  subject(:ability) { Ability.new(user) }

  describe "as not-signed-in user" do
    it { should be_able_to(:index, Post.new) }
    it { should_not be_able_to(:show, Post.new) }
  end
  
  describe "as signed-in user" do
    let(:user) { User.create!(username:'Name', password: 'password',
      password_confirmation: 'password', email: 'user@email.com', 
      address: 'Address', confirmed_at: Time.now) }

    it { should be_able_to(:index, Post.new) }
    it { should be_able_to(:show, Post.new(user: user)) }
  end
end
