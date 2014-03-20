require 'spec_helper'

describe DeliveriesController do

  describe "#create" do
    it 'should response 400 when post error params' do
      post :create, {:delivery => {:picker_id => '1000',:no_filed =>'no filed in db'}}
      response.body.should == {:status => :nok, reason: 'Invalid Order'}.to_json
      response.status.should == 400
    end

    it 'should response validate errors when post wrong params' do
      post_params = {'delivery'=> {'picker_id'=>'99999',
                                   'shipping_address'=>'',
                                   'order_sku_count'=> 2,
                                   'delivery_items_attributes' => [
                                       {'price'=>100, 'client_sku' =>'10000', 'store_sku' =>'10000'}
                                   ]
      }
      }
      post :create, post_params
      response.body.should == {:status => :nok, reason: controller.instance_variable_get(:@delivery).errors.full_messages}.to_json
      response.status.should == 422
    end

    it 'should response when post correct params' do
      post_params = {'delivery'=> {'picker_id'=>'99999',
                                     'shipping_address'=>'test ship address',
                                     'order_sku_count'=>1,
                                     'delivery_items_attributes' => [
                                     {'price'=>100, 'client_sku' =>'10000', 'store_sku' =>'10000'}
                                     ]
                                    }
                    }
      post :create, post_params
      response.body.should =={:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window:controller.instance_variable_get(:@delivery).desired_delivery_window }}.to_json
      response.status.should == 200
    end

  end
end
