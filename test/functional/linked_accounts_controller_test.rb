require 'test_helper'

class LinkedAccountsControllerTest < ActionController::TestCase
  test "test index" do
    get :index
    assert_response :sucess
  end

  test "test index with atom" do
    get :index, :format => :atom
    assert_response :sucess
  end
end
