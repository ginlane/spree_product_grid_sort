module Spree
  Classification.class_eval do
    belongs_to :taxonomy
    acts_as_list scope: :taxon_id, add_new_at: :bottom

    def self.reorder(positions)
      ids, positions  = positions.transpose
      classifications = find ids
      classifications.zip(positions).each do |c, p|
        c.set_list_position p
      end
    end
  end
end
