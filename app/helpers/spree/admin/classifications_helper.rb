module Spree::Admin::ClassificationHelper
  def taxon_dropdown_menu(taxons)
    select_tag :taxon, options_from_collection_for_select(taxons, :id, :pretty_name)
  end
end
