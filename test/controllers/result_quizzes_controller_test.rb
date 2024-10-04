require "test_helper"

class ResultQuizzesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get result_quizzes_create_url
    assert_response :success
  end
end
