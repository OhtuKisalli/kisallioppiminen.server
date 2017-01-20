require 'rails_helper'

RSpec.describe "test_students/new", type: :view do
  before(:each) do
    assign(:test_student, TestStudent.new(
      :name => "MyString",
      :points => 1
    ))
  end

  it "renders new test_student form" do
    render

    assert_select "form[action=?][method=?]", test_students_path, "post" do

      assert_select "input#test_student_name[name=?]", "test_student[name]"

      assert_select "input#test_student_points[name=?]", "test_student[points]"
    end
  end
end
