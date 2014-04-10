require 'spec_helper'

describe 'Print Out of Picking List' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'TODO' do
    click_button('Print Packing List(out of picking list)')
    pending('wait for process')
  end


end