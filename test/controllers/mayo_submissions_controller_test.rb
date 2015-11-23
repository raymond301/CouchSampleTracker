require 'test_helper'

class MayoSubmissionsControllerTest < ActionController::TestCase
  setup do
    @mayo_submission = mayo_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mayo_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mayo_submission" do
    assert_difference('MayoSubmission.count') do
      post :create, mayo_submission: { concentration: @mayo_submission.concentration, flowcell: @mayo_submission.flowcell, lane_number: @mayo_submission.lane_number, ngs_protal_batch: @mayo_submission.ngs_protal_batch, plate: @mayo_submission.plate, sample_id: @mayo_submission.sample_id, sequence_index: @mayo_submission.sequence_index, volume: @mayo_submission.volume, well: @mayo_submission.well }
    end

    assert_redirected_to mayo_submission_path(assigns(:mayo_submission))
  end

  test "should show mayo_submission" do
    get :show, id: @mayo_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mayo_submission
    assert_response :success
  end

  test "should update mayo_submission" do
    patch :update, id: @mayo_submission, mayo_submission: { concentration: @mayo_submission.concentration, flowcell: @mayo_submission.flowcell, lane_number: @mayo_submission.lane_number, ngs_protal_batch: @mayo_submission.ngs_protal_batch, plate: @mayo_submission.plate, sample_id: @mayo_submission.sample_id, sequence_index: @mayo_submission.sequence_index, volume: @mayo_submission.volume, well: @mayo_submission.well }
    assert_redirected_to mayo_submission_path(assigns(:mayo_submission))
  end

  test "should destroy mayo_submission" do
    assert_difference('MayoSubmission.count', -1) do
      delete :destroy, id: @mayo_submission
    end

    assert_redirected_to mayo_submissions_path
  end
end
