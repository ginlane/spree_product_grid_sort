require 'spec_helper'
describe "Product Decorator" do
  it "should get products by taxon and preserve their order" do
    cat_1       = FactoryGirl.create :taxonomy

    tax_hats    = FactoryGirl.create :taxon, name: "Hats"
    tax_beanies = FactoryGirl.create :taxon, name: "Beanies"
    tax_caps    = FactoryGirl.create :taxon, name: "Caps"

    tax_hats.move_to_child_of    cat_1
    tax_beanies.move_to_child_of tax_hats
    tax_caps.move_to_child_of    tax_hats

    pos_1 = FactoryGirl.create :product
    pos_2 = FactoryGirl.create :product
    pos_3 = FactoryGirl.create :product
    pos_4 = FactoryGirl.create :product

    pos_1.taxon_ids = [ tax_hats.id    ]
    pos_2.taxon_ids = [ tax_beanies.id ]
    pos_3.taxon_ids = [ tax_beanies.id ]
    pos_4.taxon_ids = [ tax_caps.id    ]

    ordered  = [ pos_1, pos_3, pos_4, pos_2 ].map(&:id).zip [ 1, 2, 3, 4 ]
    Spree::GridOrder.reorder tax_hats.id, ordered
    Spree::Product.in_taxon(tax_hats).map(&:id).should eql [ pos_1, pos_3, pos_4, pos_2 ].map(&:id)
  end
end
