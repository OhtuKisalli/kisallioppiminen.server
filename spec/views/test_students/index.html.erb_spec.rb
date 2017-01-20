require 'rails_helper'

RSpec.describe "test_students/index", type: :view do
  before(:each) do
    assign(:test_students, [
      TestStudent.create!(
        :name => "Name",
        :points => 2
      ),
      TestStudent.create!(
        :name => "Name",
        :points => 2
      )
    ])
  end

  it "renders a list of test_students" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
