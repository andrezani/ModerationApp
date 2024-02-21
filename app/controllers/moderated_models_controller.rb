class ModeratedModelsController < ApplicationController
  # This method is for the new action. It initializes a new instance of ModeratedModel.
  def new
    @moderated_model = ModeratedModel.new
  end

  # This method is for the create action. It creates a new instance of ModeratedModel with the given parameters.
  # If the model is saved successfully, it performs moderation and redirects to the show page of the model.
  # If the model is not saved, it renders the new page again.
  def create
    @moderated_model = ModeratedModel.new(moderated_model_params)

    if @moderated_model.save
      # Perform moderation and set is_accepted based on the result
      @moderated_model.moderate_attributes

      redirect_to @moderated_model, notice: 'Moderated model was successfully created.'
    else
      render :new
    end
  end

  # This method is for the show action. It finds the ModeratedModel with the given id and assigns it to @moderated_model.
  def show
    @moderated_model = ModeratedModel.find(params[:id])
  end

  private

  # This private method is for strong parameters. It requires the parameters to have a :moderated_model key,
  # and permits the :content key within that hash.
  def moderated_model_params
    params.require(:moderated_model).permit(:content)
  end
end