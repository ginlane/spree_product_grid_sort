module Spree::Admin::GridOrdersHelper
  def taxon_dropdown_menu(taxons, taxon)
    options = options_from_collection_for_select taxons, :id, :pretty_name, taxon.try(:id)
    select_tag :taxon_menu, options, "data-url" => admin_grid_orders_url
  end
end
