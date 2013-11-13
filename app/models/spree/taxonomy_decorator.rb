module Spree
  Taxonomy.class_eval do
    def classifications
      Spree::Classification.joins(:taxon).
        where(taxon_id: root.descendants.map(&:id)).order("position ASC")
    end
  end
end
