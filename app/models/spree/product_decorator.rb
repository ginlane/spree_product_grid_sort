module Spree
  Product.class_eval do
    def classification(taxon)
      classifications.where(taxon: taxon).first
    end
  end
end
