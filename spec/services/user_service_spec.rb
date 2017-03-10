require 'rails_helper'

RSpec.describe UserService, type: :service do

  describe "deadlineservice" do
    it "returns all users" do
      @u1 = FactoryGirl.create(:user, email:"o1@o.o")
      @u2 = FactoryGirl.create(:user, email:"o2@o.o")
      users = UserService.all_users
      expect(users.count).to eq(2)
      expect(users.first.id).to eq(@u1.id)
      expect(users.last.id).to eq(@u2.id)
    end
  
  end

end
