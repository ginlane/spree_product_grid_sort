require 'spec_helper'

describe Spree::Admin::GridOrdersController do
  before :each do
    @user = FactoryGirl.create :admin_user
    controller.stubs(:spree_current_user).returns @user
  end

  it "should fetch the correct Classifications by taxon or taxonomy" do
    cat_1       = FactoryGirl.create :taxonomy

    tax_hats    = FactoryGirl.create :taxon, name: "Hats"
    tax_beanies = FactoryGirl.create :taxon, name: "Beanies"
    tax_caps    = FactoryGirl.create :taxon, name: "Caps"

    tax_hats.move_to_child_of    cat_1
    tax_beanies.move_to_child_of tax_hats
    tax_caps.move_to_child_of    tax_hats

    pos_1_cat_1 = FactoryGirl.create :product
    pos_2_cat_1 = FactoryGirl.create :product
    pos_3_cat_1 = FactoryGirl.create :product
    pos_4_cat_1 = FactoryGirl.create :product

    pos_1_cat_1.taxon_ids = [ tax_hats.id    ]
    pos_2_cat_1.taxon_ids = [ tax_beanies.id ]
    pos_3_cat_1.taxon_ids = [ tax_beanies.id ]
    pos_4_cat_1.taxon_ids = [ tax_caps.id    ]

    spree_get :index, taxon_id: tax_beanies.id
    assigns(:products).map(&:id).should eql [ pos_2_cat_1, pos_3_cat_1 ].map(&:id)

    assigns(:products).first.classifications.find_by(taxon:tax_beanies).move_lower

    spree_get :index, taxon_id: tax_beanies.id
    assigns(:products).map(&:id).should eql [ pos_3_cat_1, pos_2_cat_1 ].map(&:id)
  end

  it "should correctly reorder a listttttttt" do
    tax_hats        = FactoryGirl.create :taxon, name: "Hats"
    pos_1           = FactoryGirl.create :product
    pos_2           = FactoryGirl.create :product
    pos_3           = FactoryGirl.create :product
    pos_4           = FactoryGirl.create :product

    pos_1.taxon_ids = [ tax_hats.id ]
    pos_2.taxon_ids = [ tax_hats.id ]
    pos_3.taxon_ids = [ tax_hats.id ]
    pos_4.taxon_ids = [ tax_hats.id ]

    products        =  [ pos_1, pos_2, pos_3, pos_4 ]
    class_orders    = products.map(&:id).zip [ 2, 1, 3, 4 ]

    spree_put :reorder, reorder: class_orders.to_json, taxon_id: tax_hats.id

    tax_hats.products.reload.map(&:id).should eql [ pos_2, pos_1, pos_3, pos_4 ].map(&:id)
  end
end
