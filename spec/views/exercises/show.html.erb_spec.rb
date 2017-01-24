require 'rails_helper'

RSpec.describe "exercises/show", type: :view do
  before(:each) do
    @exercise = assign(:exercise, Exercise.create!(
      :html_id => "Html",
      :name => "Name",
      :course_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Html/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
