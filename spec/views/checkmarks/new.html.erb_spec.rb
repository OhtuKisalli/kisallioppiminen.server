require 'rails_helper'

RSpec.describe "checkmarks/new", type: :view do
  before(:each) do
    assign(:checkmark, Checkmark.new(
      :user_id => 1,
      :exercise_id => 1,
      :status => "MyString"
    ))
  end

  it "renders new checkmark form" do
    render

    assert_select "form[action=?][method=?]", checkmarks_path, "post" do

      assert_select "input#checkmark_user_id[name=?]", "checkmark[user_id]"

      assert_select "input#checkmark_exercise_id[name=?]", "checkmark[exercise_id]"

      assert_select "input#checkmark_status[name=?]", "checkmark[status]"
    end
  end
end
