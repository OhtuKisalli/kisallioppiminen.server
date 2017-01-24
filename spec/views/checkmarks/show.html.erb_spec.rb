require 'rails_helper'

RSpec.describe "checkmarks/show", type: :view do
  before(:each) do
    @checkmark = assign(:checkmark, Checkmark.create!(
      :user_id => 2,
      :exercise_id => 3,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Status/)
  end
end
