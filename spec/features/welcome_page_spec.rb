require 'rails_helper'

describe "Welcome page" do
  it "should have text 'Hello World'" do
    visit root_path
    expect(page).to have_content 'Hello World'
  end
end