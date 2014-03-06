require 'spec_helper'

describe Spree::Taxon do
  it "should make a taxon_grid once created" do
    t = FactoryGirl.create :taxon
    t.should have(:no).error_on(:taxon_grids)
  end
  it "should scope taxon_grid (singluar) to current available grid" do
    t = FactoryGirl.create :taxon
    t.taxon_grid.should_not eq nil
  end  
  it "should return nil if available set to future" do
    t = FactoryGirl.create :taxon
    t.taxon_grid.update available_on: 1.day.from_now
    expect(t.reload.taxon_grid).to eq(nil)
  end   
  it "should reflect new products in last (future) taxon if exists" do
    t = FactoryGirl.create :taxon
    t.taxon_grids.create available_on: 1.day.from_now

    p = FactoryGirl.create :product
    t.taxon_grids.last.products << p
    expect(t.products).to have(0).records
  end     
  it "should reflect current grid order in taxon.products" do
    t = FactoryGirl.create :taxon
    p1 = FactoryGirl.create :product
    p2 = FactoryGirl.create :product
    
    t.products << p1    
    t.products << p2

    # matching order
    expect(t.products).to eq t.grid.products

    # one moar
    p3 = FactoryGirl.create :product
    t.products << p3
    
    # create a new future grid
    tg = t.taxon_grids.create available_on: 1.day.from_now
    # reorder future grid

    tg.classifications.last.move_to_top
    
    ap tg.reload.classifications
    # reflects order?
    expect(tg.reload.products.to_a).to eq [p3,p1,p2]
    # old/current grid shouldnt change!
    expect(t.reload.products.to_a).to eq [p1,p2,p3]
  end  

end