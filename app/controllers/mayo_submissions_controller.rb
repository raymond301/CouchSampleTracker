class MayoSubmissionsController < ApplicationController
  before_action :set_mayo_submission, only: [:show, :edit, :update, :destroy]

  # GET /mayo_submissions
  # GET /mayo_submissions.json
  def index
    @mayo_submissions = MayoSubmission.all
  end

  # GET /mayo_submissions/1
  # GET /mayo_submissions/1.json
  def show
  end

  # GET /mayo_submissions/new
  def new
    @mayo_submission = MayoSubmission.new
  end

  # GET /mayo_submissions/1/edit
  def edit
  end

  # POST /mayo_submissions
  # POST /mayo_submissions.json
  def create
    @mayo_submission = MayoSubmission.new(mayo_submission_params)

    respond_to do |format|
      if @mayo_submission.save
        format.html { redirect_to @mayo_submission, notice: 'Mayo submission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mayo_submission }
      else
        format.html { render action: 'new' }
        format.json { render json: @mayo_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mayo_submissions/1
  # PATCH/PUT /mayo_submissions/1.json
  def update
    respond_to do |format|
      if @mayo_submission.update(mayo_submission_params)
        format.html { redirect_to @mayo_submission, notice: 'Mayo submission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mayo_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mayo_submissions/1
  # DELETE /mayo_submissions/1.json
  def destroy
    @mayo_submission.destroy
    respond_to do |format|
      format.html { redirect_to mayo_submissions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mayo_submission
      @mayo_submission = MayoSubmission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mayo_submission_params
      params.require(:mayo_submission).permit(:sample_id, :plate, :well, :volume, :concentration, :lane_number, :sequence_index, :flowcell, :ngs_protal_batch)
    end
end
