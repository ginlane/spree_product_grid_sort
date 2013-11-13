module Spree::Admin::GridOrdersHelper
  def taxon_dropdown_menu(taxons)
    select_tag :taxon_menu, options_from_collection_for_select(taxons, :id, :pretty_name),
               "data-url" => admin_grid_orders_url
  end
end
