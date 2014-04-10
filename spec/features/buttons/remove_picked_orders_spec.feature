require 'spec_helper'

describe 'Remove Picked Orders' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'should remove picked orders' do
    click_button('Remove Picked Orders')
    pending('wait for process')
  end
end