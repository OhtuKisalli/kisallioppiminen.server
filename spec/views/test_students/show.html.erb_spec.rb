require 'rails_helper'

RSpec.describe "test_students/show", type: :view do
  before(:each) do
    @test_student = assign(:test_student, TestStudent.create!(
      :name => "Name",
      :points => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
  end
end
