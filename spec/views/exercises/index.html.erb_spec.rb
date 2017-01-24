require 'rails_helper'

RSpec.describe "exercises/index", type: :view do
  before(:each) do
    assign(:exercises, [
      Exercise.create!(
        :html_id => "Html",
        :name => "Name",
        :course_id => ""
      ),
      Exercise.create!(
        :html_id => "Html",
        :name => "Name",
        :course_id => ""
      )
    ])
  end

  it "renders a list of exercises" do
    render
    assert_select "tr>td", :text => "Html".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
