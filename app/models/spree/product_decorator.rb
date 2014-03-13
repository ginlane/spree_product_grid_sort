Spree::Product.class_eval do
  has_many :taxon_grids, through: :classifications
  has_many :taxons, through: :classifications, uniq: true


  def grids(t=nil)
    if t
      taxon_grids.where(taxon:t)
    else
      taxon_grids
    end
  end
end