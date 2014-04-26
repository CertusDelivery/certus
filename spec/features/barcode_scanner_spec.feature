require 'spec_helper'

describe 'Barcode Scanner Process' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'get wrong tip enter no-exist barcode' do
    fill_in('barcode', :with => 'ABC102928383')
    pending('wait for process')
  end

end