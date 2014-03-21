require 'spec_helper'

describe DeliveriesController do

  describe "#create" do
    it 'should response 400 when post error params' do
      param = create_delivery_params
      param[:delivery][:no_filed] = 'no filed in db'
      post :create, param
      response.body.should == {:status => :nok, reason: 'Invalid Order'}.to_json
      response.status.should == 400
    end

    it 'should response validate errors when post wrong params' do
      post_params = create_delivery_params
      post_params[:delivery][:customer_name] = nil
      post :create, post_params
      response.body.should == {:status => :nok, reason: controller.instance_variable_get(:@delivery).errors.full_messages}.to_json
      response.status.should == 422
    end

    it 'should response when post correct params' do
      post_params = create_delivery_params
      post :create, post_params
      response.body.should =={:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window:controller.instance_variable_get(:@delivery).desired_delivery_window }}.to_json
      response.status.should == 200
    end

  end
end
