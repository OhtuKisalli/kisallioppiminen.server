require 'rails_helper'

RSpec.describe "exercises/new", type: :view do
  before(:each) do
    assign(:exercise, Exercise.new(
      :html_id => "MyString",
      :name => "MyString",
      :course_id => ""
    ))
  end

  it "renders new exercise form" do
    render

    assert_select "form[action=?][method=?]", exercises_path, "post" do

      assert_select "input#exercise_html_id[name=?]", "exercise[html_id]"

      assert_select "input#exercise_name[name=?]", "exercise[name]"

      assert_select "input#exercise_course_id[name=?]", "exercise[course_id]"
    end
  end
end
