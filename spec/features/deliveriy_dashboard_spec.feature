require 'spec_helper'

describe 'Delivery Load Process' do
  before do
    create_delivery
    visit root_path
    sleep 1
  end

  it 'should have some content marks loading successfully' do
    page.should have_content("Products To Be Picked")
  end

  it 'should have download New Order button' do
    page.should have_button("Download New Order")
  end

  it 'should have Remove Picked Orders button'  do
    page.should have_button("Remove Picked Orders")
  end

  it 'should have Sort By Location button'  do
    page.should have_button("Sort By Location")
  end

  it 'should have Out of Stock button'  do
    page.should have_button("Out of Stock")
  end

  it 'should have Product Detail button'  do
    page.should have_button("Product Detail")
  end

  it 'should have Print Invoice button'  do
    page.should have_button("Print Invoice")
  end

  it 'should have Print Packing List button'  do
    page.should have_button("Print Packing List")
  end

  it 'should have Print Packing List(out of picking list) button'  do
    page.should have_button("Print Packing List(out of picking list)")
  end

  it 'should have Delivery History button'  do
    page.should have_link("Delivery History")
  end

  it 'should have Scanner Input button'  do
    page.should have_selector("input#barcode")
    page.should have_button("Submit Scanner Input")
  end

  it 'should have picklist content' do
    page.should have_selector("div#picklist")
  end
end