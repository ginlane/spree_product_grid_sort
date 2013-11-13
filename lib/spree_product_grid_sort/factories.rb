FactoryGirl.define do
  factory :grid_order, class: Spree::GridOrder do
    ordered_product factory: :product
    taxon
  end
end
