module Spree
  module Admin
    class GridOrdersController < BaseController
      include Spree::Admin::GridOrdersHelper
      helper 'spree/products'
      
      def index
        @taxons = Spree::Taxon.order(:parent_id)
        
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
        @taxon.grids.create grid_params
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
