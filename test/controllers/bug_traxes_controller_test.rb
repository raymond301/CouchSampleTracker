require 'test_helper'

class BugTraxesControllerTest < ActionController::TestCase
  setup do
    @bug_trax = bug_traxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bug_traxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bug_trax" do
    assert_difference('BugTrax.count') do
      post :create, bug_trax: { description: @bug_trax.description, level: @bug_trax.level, submitter: @bug_trax.submitter, tag: @bug_trax.tag, url: @bug_trax.url }
    end

    assert_redirected_to bug_trax_path(assigns(:bug_trax))
  end

  test "should show bug_trax" do
    get :show, id: @bug_trax
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bug_trax
    assert_response :success
  end

  test "should update bug_trax" do
    patch :update, id: @bug_trax, bug_trax: { description: @bug_trax.description, level: @bug_trax.level, submitter: @bug_trax.submitter, tag: @bug_trax.tag, url: @bug_trax.url }
    assert_redirected_to bug_trax_path(assigns(:bug_trax))
  end

  test "should destroy bug_trax" do
    assert_difference('BugTrax.count', -1) do
      delete :destroy, id: @bug_trax
    end

    assert_redirected_to bug_traxes_path
  end
end
