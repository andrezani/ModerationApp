module Moderable
  extend ActiveSupport::Concern

  # This block of code is executed when the module is included in a model.
  # It sets a before_validation callback to moderate the attributes of the model.
  included do
    before_validation :moderate_attributes
  end

  # This method moderates the attributes of the model.
  # It iterates over each moderated column, sends a request to the moderation API,
  # and sets the is_accepted attribute based on the response.
  def moderate_attributes
    moderated_columns.each do |column|
      content = send(column)
      next if content.blank?

      response = moderation_api_predict(content)

      self.is_accepted = response && response.dig("prediction", "0").to_f > 0.9 ? false : true
    end
  end

  private

  # This method returns the columns that should be moderated.
  # You can override this method in your models to specify different columns.
  def moderated_columns
    [:content]
  end

  # This method sends a GET request to the moderation API and returns the response.
  # If the request fails, it logs the error and returns nil.
  def moderation_api_predict(text)
    url = "https://moderation.logora.fr/predict?text=#{URI.encode_www_form_component(text)}"
    response = RestClient.get(url)
    JSON.parse(response.body) if response.code == 200
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Moderation API error: #{e.response}")
    nil
  end
end