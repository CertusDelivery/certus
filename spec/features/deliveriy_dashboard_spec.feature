require 'spec_helper'

describe 'Delivery Load Process' do
  it 'should have some content marks loading successfully' do
    visit root_path
    page.should have_content("Products To Be Picked")
    sleep 5
  end
end