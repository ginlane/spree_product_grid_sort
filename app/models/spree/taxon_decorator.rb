module Spree
  Taxon.class_eval do
    has_many :classifications, ->{
      order("#{Classification.table_name}.position ASC")
    }, dependent: :destroy
    has_many :products, ->{
      order("#{Classification.table_name}.position ASC")
    }, through: :classifications
  end
end
