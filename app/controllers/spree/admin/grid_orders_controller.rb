module Spree
  module Admin
    class GridOrdersController < BaseController
      include Spree::Admin::GridOrdersHelper
      helper 'spree/products'
      
      def index
        @taxons = Spree::Taxon.where.not(parent_id:nil).order(:parent_id)
        
        @taxon = if params[:taxon_id]
          Spree::Taxon.find params[:taxon_id]
        else
          @taxons.first
        end

        @grid = if params[:grid_id]
          @taxon.grids.find(params[:grid_id])
        else
          @taxon.grid
        end
        @products = @grid.products
      end

      def reorder
        reorder_params = JSON.parse params[:reorder]
        Classification.reorder params[:grid_id], reorder_params
        render json: true
      end

      def create
        @taxon    = Spree::Taxon.find params[:taxon_id]
        if @taxon.grids.where(available_on: grid_params[:available_on]).present?
          flash[:notice] = "Grid already exists for date, please delete bofore replaceing"
          redirect_to :back
        else
          tg = @taxon.grids.create grid_params
          redirect_to admin_grid_orders_path(taxon_id:@taxon.id, grid_id:tg.id)
        end
        
      end

      def update
        @grid = Spree::TaxonGrid.find params[:id]
        binding.pry
        @grid.update(grid_params)
        redirect_to admin_grid_orders_path(grid_id: @grid.id, taxon_id: @grid.taxon.id)
      end

      def destroy
        @grid = Spree::TaxonGrid.find params[:id]
        @grid.destroy unless @grid.current?
        redirect_to admin_grid_orders_path(taxon_id:@grid.taxon_id)
      end

      protected

      def grid_params
        params.require(:taxon_grid).permit(:available_on, :taxon_id)
      end
      # TODO: fixme and figure out if this is the best aproach (it's not)
      def current_currency
        'USD'
      end
    end
  end
end
