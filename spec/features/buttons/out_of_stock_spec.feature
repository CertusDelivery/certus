require 'spec_helper'

describe 'Out of Stock' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'TODO' do
    click_button('Out of Stock')
    pending('wait for process')
  end


end