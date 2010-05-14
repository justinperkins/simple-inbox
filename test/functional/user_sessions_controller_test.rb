require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  test "new session" do
    get :new
    assert_response :success
  end

  test "create session succeeds" do
    post :create, :user_session => { :login => "dude", :password => "abides" }
    assert user_session = UserSession.find
    assert_equal users(:dude), user_session.user
    assert_redirected_to user_path(user_session.user)
  end

  test "delete session" do
    UserSession.create(users(:dude))
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
  
  test "new session requires no user" do
    session = UserSession.create(users(:dude))
    get :new
    assert_redirected_to user_path(session.record)
  end

  test "create session requires no user" do
    session = UserSession.create(users(:dude))
    post :create
    assert_redirected_to user_path(session.record)
  end
  
  test "delete session requires logged in user" do
    delete :destroy
    assert_redirected_to new_user_session_path
  end
end
