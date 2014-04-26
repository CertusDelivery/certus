require 'spec_helper'

describe Category do
  
  describe "create_by_string" do
    context "should return nil" do
      it "when using a blank string" do
        Category.create_by_string("").should be_nil
      end
      it "when using nil" do
        Category.create_by_string(nil).should be_nil
      end
      it "when using a string with no level" do
        Category.create_by_string(">>").should be_nil
      end
    end
    
    context "when using a string without high level" do
      it "should return a low level" do
        expect(Category.create_by_string(">mid level>low level").name).to eq('low level')
      end
    end

    context "when using a string without mid level" do
      it "should return a low level" do
        expect(Category.create_by_string("high level>>low level").name).to eq('low level')
      end
    end

    context "when using a string without low level" do
      it "should return a mid level" do
        expect(Category.create_by_string("high level>mid level>").name).to eq('mid level')
      end
    end

    context "when using many diffrent level string" do
      before do
        Category.create_by_string("high level>>")
        Category.create_by_string(">mid level>")
        Category.create_by_string(">>low level")
        Category.create_by_string("high level>mid level>")
        Category.create_by_string("high level>>low level")
        Category.create_by_string(">mid level>low level")
        Category.create_by_string("high level>mid level>low level")
      end
      it "should have correct relationship among levels" do
        expect(Category.where(:parent_id => 0).size).to eq(3) 

        CS = {'high level' => 2, 'mid level' => 1, 'low level' => 0}
        Category.where(:parent_id => 0).each do |high|
          expect(Category.where(:parent_id => high.id).size).to eq(CS[high.name]) 
        end
      end
    end
  end

end
