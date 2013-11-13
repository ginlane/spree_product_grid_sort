module Spree
  module Admin
    class GridOrdersController < BaseController
      include Spree::Admin::GridOrdersHelper

      def index
        @taxons = Spree::Taxon.all
        if params[:taxon_id]
          @taxon    = Spree::Taxon.find params[:taxon_id]
          @products = Spree::Product.grid_ordered @taxon
        end
      end

      def reorder
        reorder_params = JSON.parse params[:reorder]
        GridOrder.reorder params[:taxon_id], reorder_params
        render json: true
      end
    end
  end
end
