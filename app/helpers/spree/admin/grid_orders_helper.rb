module Spree::Admin::GridOrdersHelper
  def taxon_dropdown_menu(taxons, taxon, opt = {})
    options = options_from_collection_for_select taxons, :id, :short_pretty_name, taxon.try(:id)

    select_tag :taxon_menu, options, "data-url" => admin_grid_orders_url
  end

  def grids_dropdown_menu(grids, grid, opt = {})
    options = options_from_collection_for_select grids, :id, :pretty_name, grid.try(:id)
    select_tag :grid_id, options, opt
  end

  def retail_store_dropdown_menu(stores, taxon)
    options = options_from_collection_for_select stores, :id, :pretty_name, params['store_id']
    opt_with_default = '<option value="">All</option>'.html_safe + options

    select_tag :store_menu, opt_with_default, 'data-url' => admin_retail_grid_orders_url
  end
end
