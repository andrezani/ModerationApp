# app/models/moderated_model.rb
class ModeratedModel < ApplicationRecord
  include Moderable

  def self.moderated_columns
    # Define the columns you want to moderate for this model
    # For example: [:content]
    [:content]
  end
end
