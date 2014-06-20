module Spree::Admin::GridOrdersHelper
  def taxon_dropdown_menu(taxons, taxon, opt={})
    options = options_from_collection_for_select taxons, :id, :short_pretty_name, taxon.try(:id)

    select_tag :taxon_menu, options,  {"data-url" => admin_grid_orders_url}
  end
  def grids_dropdown_menu(grids, grid, opt={})
    options = options_from_collection_for_select grids, :id, :pretty_name, grid.try(:id)
    select_tag :grid_id, options, opt
  end
end
