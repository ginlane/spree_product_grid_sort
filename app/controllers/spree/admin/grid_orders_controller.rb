module Spree
  module Admin
    class GridOrdersController < BaseController
      include Spree::Admin::GridOrdersHelper
      helper 'spree/products'
      def index
        @taxons = Spree::Taxon.all
        if params[:taxon_id]
          @taxon    = Spree::Taxon.find params[:taxon_id]
          searcher  = build_searcher taxon: @taxon.id
          @products = searcher.retrieve_products
        end
      end

      def reorder
        reorder_params = JSON.parse params[:reorder]
        GridOrder.reorder params[:taxon_id], reorder_params
        render json: true
      end

      protected
      # TODO: fixme and figure out if this is the best aproach (it's not)
      def current_currency
        'USD'
      end
    end
  end
end
