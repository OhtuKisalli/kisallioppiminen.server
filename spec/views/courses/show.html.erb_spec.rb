require 'rails_helper'

RSpec.describe "courses/show", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :html_id => "Html",
      :coursekey => "Coursekey",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Html/)
    expect(rendered).to match(/Coursekey/)
    expect(rendered).to match(/Name/)
  end
end
