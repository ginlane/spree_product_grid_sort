require 'spec_helper'

describe Spree::TaxonGrid do
  it "should make a copy of first grid once second grid is created" do
    t = FactoryGirl.create :taxon
    p1 = FactoryGirl.create :product
    p2 = FactoryGirl.create :product
    
    t.products << p1    
    t.products << p2

    expect(t.products).to eq [p1,p2]

    tg = t.taxon_grids.create available_on: 1.day.from_now
    expect(t.reload.taxon_grids.last.products).to eq [p1,p2]
  end
end