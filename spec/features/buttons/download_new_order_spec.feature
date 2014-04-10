require 'spec_helper'

describe 'Download New Order' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'should have new orders' do
    click_button('Download New Order')
    pending('wait for process')
  end
end