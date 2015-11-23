class BugTraxesController < ApplicationController
  before_action :set_bug_trax, only: [:show, :edit, :update, :destroy]
  $LVL = [['Urgent!', 'urgent'], ['Moderate Importance', 'moderate'], ['Low Priority','low']]

  # GET /bug_traxes
  # GET /bug_traxes.json
  def index
    @bug_traxes = BugTrax.all
  end

  # GET /bug_traxes/1
  # GET /bug_traxes/1.json
  def show
  end

  # GET /bug_traxes/new
  def new
    @bug_trax = BugTrax.new
    @bug_trax.url = request.referrer
  end

  # GET /bug_traxes/1/edit
  def edit
  end

  # POST /bug_traxes
  # POST /bug_traxes.json
  def create
    @bug_trax = BugTrax.new(bug_trax_params)

    respond_to do |format|
      if @bug_trax.save
        format.html { redirect_to @bug_trax, notice: 'Bug trax was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bug_trax }
      else
        format.html { render action: 'new' }
        format.json { render json: @bug_trax.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bug_traxes/1
  # PATCH/PUT /bug_traxes/1.json
  def update
    respond_to do |format|
      if @bug_trax.update(bug_trax_params)
        format.html { redirect_to @bug_trax, notice: 'Bug trax was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bug_trax.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bug_traxes/1
  # DELETE /bug_traxes/1.json
  def destroy
    @bug_trax.destroy
    respond_to do |format|
      format.html { redirect_to bug_traxes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug_trax
      @bug_trax = BugTrax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_trax_params
      params.require(:bug_trax).permit(:submitter, :url, :description, :level, :tag)
    end
end
