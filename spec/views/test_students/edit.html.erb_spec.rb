require 'rails_helper'

RSpec.describe "test_students/edit", type: :view do
  before(:each) do
    @test_student = assign(:test_student, TestStudent.create!(
      :name => "MyString",
      :points => 1
    ))
  end

  it "renders the edit test_student form" do
    render

    assert_select "form[action=?][method=?]", test_student_path(@test_student), "post" do

      assert_select "input#test_student_name[name=?]", "test_student[name]"

      assert_select "input#test_student_points[name=?]", "test_student[points]"
    end
  end
end
