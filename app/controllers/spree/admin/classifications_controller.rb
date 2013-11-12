module Spree
  module Admin
    class ClassificationsController < BaseController
      include Spree::Admin::ClassificationHelper

      def index
        @taxons = Taxon.all
        if params[:taxonomy_id]
          taxonomy         = Spree::Taxonomy.find params[:taxonomy_id]
          @classifications = taxonomy.root.classifications
        elsif params[:taxon_id]
          taxon            = Spree::Taxon.find params[:taxon_id]
          @classifications = taxon.classifications
        end
      end

      def reorder
        Classification.reorder params[:reorder]
        render json: true
      end
    end
  end
end
