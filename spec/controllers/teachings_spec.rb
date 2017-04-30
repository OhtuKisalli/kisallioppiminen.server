require 'rails_helper'

RSpec.describe TeachingsController, type: :controller do

  describe "teacher toggling archived of courses" do
  
    context "when not logged in" do
      it "gives error message" do
        post 'toggle_archived', :format => :json, params: {"sid":1,"cid":1,"archived": "true"}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course)
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "can only toggle archived of own courses" do
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id + 3,"cid":@course1.id + 3,"archived": "true"}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}
        expect(body).to eq(expected)
      end
      it "cannot toggle archived if not on course" do
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(response.status).to eq(403)
      end
      it "cannot toggle archived without parameter archived" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"aaa": "true"}
        expect(response.status).to eq(422)
      end
      it "cannot toggle archived with improper value" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "joo"}
        expect(response.status).to eq(422)
      end
      it "can toggle archived from false to true" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id, archived: false)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Kurssi arkistoitu."}
        expect(body).to eq(expected)
        expect(Teaching.first.archived).to eq(true)
      end
      it "can toggle archived from true to false" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id, archived: true)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "false"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Kurssi palautettu arkistosta."}
        expect(body).to eq(expected)
        expect(Teaching.first.archived).to eq(false)
      end
      it "trying to archive archived course makes no changes" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id, archived: true)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(Teaching.first.archived).to eq(true)
      end
      it "trying to recover course that is recovered makes on changes" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id, archived: false)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "false"}
        expect(Teaching.first.archived).to eq(false)
      end
      
    end
  end

end

