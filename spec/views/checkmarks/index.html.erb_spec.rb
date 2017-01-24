require 'rails_helper'

RSpec.describe "checkmarks/index", type: :view do
  before(:each) do
    assign(:checkmarks, [
      Checkmark.create!(
        :user_id => 2,
        :exercise_id => 3,
        :status => "Status"
      ),
      Checkmark.create!(
        :user_id => 2,
        :exercise_id => 3,
        :status => "Status"
      )
    ])
  end

  it "renders a list of checkmarks" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
