require 'test_helper'

class ModeratedModelsControllerTest < ActionDispatch::IntegrationTest
  # This test checks that a new ModeratedModel can be successfully created.
  # It asserts that the count of ModeratedModel increases by 1 after a POST request to create a new ModeratedModel.
  # It also asserts that the user is redirected to the show page of the newly created ModeratedModel and that a success flash message is displayed.
  test "should create moderated model" do
    assert_difference('ModeratedModel.count') do
      post moderated_models_url, params: { moderated_model: { content: 'Test Content' } }
    end

    assert_redirected_to moderated_model_url(ModeratedModel.last)
    assert_equal 'Moderated model was successfully created.', flash[:notice]
  end

  # This test checks that the attributes of a new ModeratedModel are moderated upon successful creation.
  # It asserts that the count of ModeratedModel increases by 1 after a POST request to create a new ModeratedModel.
  # It also asserts that the is_accepted attribute of the newly created ModeratedModel is not nil, indicating that moderation has been performed.
  test "should moderate attributes on successful create" do
    assert_difference('ModeratedModel.count') do
      post moderated_models_url, params: { moderated_model: { content: 'Test Content' } }
    end

    moderated_model = ModeratedModel.last
    assert moderated_model.is_accepted.present?, "Moderation should set is_accepted"
  end

  # This test checks that a ModeratedModel can be successfully displayed.
  # It sends a GET request to the show page of a ModeratedModel and asserts that the response is successful.
  test "should show moderated model" do
    moderated_model = moderated_models(:one)
    get moderated_model_url(moderated_model)
    assert_response :success
  end
end