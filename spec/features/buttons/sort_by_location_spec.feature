require 'spec_helper'

describe 'Sort By Location' do
  before do
   create_delivery
    visit root_path
    sleep 1
  end

  it 'should sort by location asc' do
    click_button('Sort By Location')
    pending('wait for process')
  end

  it 'should sort by location desc' do
    click_button('Sort By Location')
    pending('wait for process')
  end

end