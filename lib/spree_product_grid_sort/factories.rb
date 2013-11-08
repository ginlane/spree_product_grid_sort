FactoryGirl.define do
  factory :grid_order, class: Spree::GridOrder do
    product
    taxonomy
    position { |n|  n }
  end
end
