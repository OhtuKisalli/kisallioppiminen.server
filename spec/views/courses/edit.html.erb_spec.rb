require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :html_id => "MyString",
      :coursekey => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_html_id[name=?]", "course[html_id]"

      assert_select "input#course_coursekey[name=?]", "course[coursekey]"

      assert_select "input#course_name[name=?]", "course[name]"
    end
  end
end
