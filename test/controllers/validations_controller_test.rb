require 'test_helper'

class ValidationsControllerTest < ActionController::TestCase
  setup do
    @validation = validations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validation" do
    assert_difference('Validation.count') do
      post :create, validation: { alt: @validation.alt, annealing_temp: @validation.annealing_temp, chr: @validation.chr, confirmation: @validation.confirmation, exon: @validation.exon, gene: @validation.gene, hgvs_c: @validation.hgvs_c, hgvs_p: @validation.hgvs_p, notes: @validation.notes, pcr_size: @validation.pcr_size, pos: @validation.pos, primer_forward: @validation.primer_forward, primer_reverse: @validation.primer_reverse, ref: @validation.ref, reference_build: @validation.reference_build, sample_id: @validation.sample_id, transcript: @validation.transcript }
    end

    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should show validation" do
    get :show, id: @validation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @validation
    assert_response :success
  end

  test "should update validation" do
    patch :update, id: @validation, validation: { alt: @validation.alt, annealing_temp: @validation.annealing_temp, chr: @validation.chr, confirmation: @validation.confirmation, exon: @validation.exon, gene: @validation.gene, hgvs_c: @validation.hgvs_c, hgvs_p: @validation.hgvs_p, notes: @validation.notes, pcr_size: @validation.pcr_size, pos: @validation.pos, primer_forward: @validation.primer_forward, primer_reverse: @validation.primer_reverse, ref: @validation.ref, reference_build: @validation.reference_build, sample_id: @validation.sample_id, transcript: @validation.transcript }
    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should destroy validation" do
    assert_difference('Validation.count', -1) do
      delete :destroy, id: @validation
    end

    assert_redirected_to validations_path
  end
end
