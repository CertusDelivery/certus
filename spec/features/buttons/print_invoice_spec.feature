require 'spec_helper'

describe 'Print Invoice' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'TODO' do
    click_button('Print Invoice')
    pending('wait for process')
  end


end