require 'rails_helper'

RSpec.describe "exercises/edit", type: :view do
  before(:each) do
    @exercise = assign(:exercise, Exercise.create!(
      :html_id => "MyString",
      :name => "MyString",
      :course_id => ""
    ))
  end

  it "renders the edit exercise form" do
    render

    assert_select "form[action=?][method=?]", exercise_path(@exercise), "post" do

      assert_select "input#exercise_html_id[name=?]", "exercise[html_id]"

      assert_select "input#exercise_name[name=?]", "exercise[name]"

      assert_select "input#exercise_course_id[name=?]", "exercise[course_id]"
    end
  end
end
