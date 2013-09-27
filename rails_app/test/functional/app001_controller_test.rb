require 'test_helper'

class App001ControllerTest < ActionController::TestCase
  test "should get test" do
    get :test
    assert_response :success
  end

end
