require 'spec_helper'

describe 'Print Packing List' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'TODO' do
    click_button('Print Packing List')
    pending('wait for process')
  end


end