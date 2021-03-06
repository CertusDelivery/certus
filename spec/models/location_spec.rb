require 'spec_helper'

describe Location do
  describe "#create_by_info" do
    before do
      Location.create_by_info("110-32-3")
    end

    it "should return nil when using invalid info" do
      expect(Location.create_by_info("100f-3-3")).to be_nil
      expect(Location.create_by_info("1000-e-3")).to be_nil
      expect(Location.create_by_info("1000-3-y")).to be_nil
      expect(Location.create_by_info("E-3-3")).to be_nil
    end

    it "should return nil when using same info" do
      Location.create_by_info("110-32-3").should be_nil
    end

    it "should return a location when using correct info" do
      Location.create_by_info("112-32-3").should be_kind_of Location
    end

    context "when using same info" do
      it "should no grow for location count" do
        expect{ Location.create_by_info("110-32-3") }.to change { Location.count }.by(0)
      end
    end

    context "when using diffrent info" do
      it "should grow one step for location count" do
        expect{ Location.create_by_info("111-32-3") }.to change { Location.count }.by(1)
      end
    end
  end

  describe "#build_info" do
    it "should build info before location saving in db" do
    location = Location.new(aisle: "110", direction: "E", distance: 39, shelf: 5)
    expect { location.save }.to change { location.info }.to eq("110E-39-5")
    end
  end
end
