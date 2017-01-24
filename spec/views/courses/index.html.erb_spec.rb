require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        :html_id => "Html",
        :coursekey => "Coursekey",
        :name => "Name"
      ),
      Course.create!(
        :html_id => "Html",
        :coursekey => "Coursekey",
        :name => "Name"
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => "Html".to_s, :count => 2
    assert_select "tr>td", :text => "Coursekey".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
