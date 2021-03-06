require 'spec_helper'

describe Spree::Classification do
  it "should add new products to top of list and allow reorder" do
    t = FactoryGirl.create :taxon
    p1 = FactoryGirl.create :product
    p2 = FactoryGirl.create :product
    t.products << p1
    t.products << p2

    expect(t.reload.products).to eq [p2, p1]
    t.taxon_grid.classifications.find_by(product:p2).move_to_bottom
    expect(t.reload.products).to eq [p1, p2]
  end
end