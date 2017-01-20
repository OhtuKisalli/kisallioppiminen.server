require 'rails_helper'

RSpec.describe TestStudent, type: :model do

  it "TestStudents name it set correctly" do
    user = TestStudent.new name:"Maija"

    expect(user.name).to match("Maija")
  end



end
