require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new(
      :html_id => "MyString",
      :coursekey => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input#course_html_id[name=?]", "course[html_id]"

      assert_select "input#course_coursekey[name=?]", "course[coursekey]"

      assert_select "input#course_name[name=?]", "course[name]"
    end
  end
end
