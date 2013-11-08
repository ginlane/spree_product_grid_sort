require 'spec_helper'
describe "Product Decorator" do
  it "should get products by taxon and preserve their order" do
    pos_1_cat_1 = FactoryGirl.create :grid_order
    cat_1       = pos_1_cat_1.taxonomy
    pos_2_cat_1 = FactoryGirl.create :grid_order, taxonomy: cat_1
    pos_3_cat_1 = FactoryGirl.create :grid_order, taxonomy: cat_1
    pos_4_cat_1 = FactoryGirl.create :grid_order, taxonomy: cat_1

    pos_1_cat_2 = FactoryGirl.create :grid_order, product: pos_1_cat_1.product
    cat_2       = pos_1_cat_2.taxonomy
    pos_2_cat_1 = FactoryGirl.create :grid_order, product: pos_2_cat_1.product, taxonomy: cat_2
    pos_3_cat_1 = FactoryGirl.create :grid_order, product: pos_3_cat_1.product, taxonomy: cat_2
    pos_4_cat_1 = FactoryGirl.create :grid_order, product: pos_4_cat_1.product, taxonomy: cat_2

    tax_hats    = FactoryGirl.create :taxon, name: "Hats"
    tax_beanies = FactoryGirl.create :taxon, name: "Beanies"
    tax_caps    = FactoryGirl.create :taxon, name: "Caps"

    tax_hats.move_to_child_of    cat_1
    tax_beanies.move_to_child_of tax_hats
    tax_caps.move_to_child_of    tax_hats

    pos_1_cat_1.product.taxon_ids = [ tax_hats.id    ]
    pos_2_cat_1.product.taxon_ids = [ tax_beanies.id ]
    pos_3_cat_1.product.taxon_ids = [ tax_beanies.id ]
    pos_4_cat_1.product.taxon_ids = [ tax_caps.id    ]

    pos_1_cat_1.save!
    pos_2_cat_1.save!
    pos_3_cat_1.save!
    pos_4_cat_1.save!

    products = Spree::Core::Search::Base.new(taxon: tax_beanies).retrieve_products
    products.joins(:grid_orders).where grid_orders: [ taxonomy: tax_beanies.root.taxonomy ]
    products.first.id.should eql pos_2_cat_1.id
    # tax_beanies.products.first.id.should eql pos_2_cat_1.id

    pos_3_cat_1.product.grid_order_in(tax)

    tax_beanies.products.first.id.should eql pos_3_cat_1.id

  end
end
