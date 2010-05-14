require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test "index sends user to the login page when not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "index sends user to their profile when logged in" do
    session = UserSession.create(users(:dude))
    get :index
    assert_redirected_to user_path(session.record)
  end
  
  test "new user" do
    get :new
    assert_response :success
  end
  
  test "new user only loads when not logged in" do
    session = UserSession.create(users(:dude))
    get :new
    assert_redirected_to user_path(session.record)
  end
  
  test "create user" do
    user = users(:dude)
    User.expects(:new).with('login' => 'foo', 'password' => 'bar').returns(user)
    user.expects(:save).returns(true)
    post :create, :user => {:login => 'foo', :password => 'bar'}
    assert_redirected_to user_path(user)
  end
  
  test "create user with error re-renders form" do
    user = users(:dude)
    User.expects(:new).returns(user)
    user.expects(:save).returns(false)
    post :create
    assert_response :success
  end
  
  test "create user requires non-logged in user" do
    session = UserSession.create(users(:dude))
    post :create
    assert_redirected_to user_path(session.record)
  end

  test "show user" do
    user = users(:dude)
    session = UserSession.create(user)
    get :show, :id => session.record
    assert_response :success
    assert_select "#user-nav li a[href=/accounts/#{ user.id }]"
  end
  
  test "show user only loads when logged in" do
    get :show, :id => 1
    assert_redirected_to new_user_session_path
  end
  
  test "show user only shows the logged in user and nobody else" do
    u1 = users(:dude)
    u2 = users(:walter)
    session = UserSession.create(u1)
    get :show, :id => u2
    assert_response :success
    assert_select "#user-nav li a[href=/accounts/#{ u1.id }]"
  end
  
  test "edit user" do
    session = UserSession.create(users(:dude))
    get :edit, :id => session.record
    assert_response :success
    assert_select 'p.login input[value=dude]'
  end
  
  test "edit user only loads when logged in" do
    get :edit, :id => 1
    assert_redirected_to new_user_session_path
  end
  
  test "edit user only edits the logged in user and nobody else" do
    u1 = users(:dude)
    u2 = users(:walter)
    session = UserSession.create(u1)
    get :edit, :id => u2
    assert_response :success
    assert_select 'p.login input[value=dude]'
  end

  test "update user" do
    session = UserSession.create(users(:dude))
    session.record.expects(:update_attributes).with('login' => 'foo', 'password' => 'bar').returns(true)
    UserSession.expects(:find).returns(session)
    post :update, :user => {:login => 'foo', :password => 'bar'}
    assert_redirected_to user_path(session.record)
  end
  
  test "update user with errors re-renders form" do
    session = UserSession.create(users(:dude))
    session.record.expects(:update_attributes).with('login' => 'foo', 'password' => 'bar').returns(false)
    UserSession.expects(:find).returns(session)
    post :update, :user => {:login => 'foo', :password => 'bar'}
    assert_response :success
  end
  
  test "update user requires logged in user" do
    post :update, :id => 1
    assert_redirected_to new_user_session_path
  end

  test "destroy user" do
    session = UserSession.create(users(:dude))
    delete :destroy, :id => session.record
    assert_redirected_to root_path
  end
  
  test "destroy user only loads when logged in" do
    delete :destroy, :id => 1
    assert_redirected_to new_user_session_path
  end
  
  test "destroy user only destroys the logged in user and nobody else" do
    u1 = users(:dude)
    u2 = users(:walter)
    session = UserSession.create(u1)
    delete :destroy, :id => u2
    assert_redirected_to root_path
  end
end
