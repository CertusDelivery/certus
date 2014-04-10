require 'spec_helper'

describe 'Delivery History' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'Delivery History' do
    click_link('Delivery History')
    pending('wait for process')
  end
end