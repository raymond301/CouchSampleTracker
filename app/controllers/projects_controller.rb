class ProjectsController < ApplicationController
  before_action :set_project, :only=> [:show, :edit, :update, :destroy, :count]

    def show
      @allSamples = @project.samples
      h = @allSamples.group(:site_of_origin_id).count
      @grpCnts = Hash[h.map { |k, v| [ SiteOfOrigin.find(k).study_group, v] }]

      #raise @grpCnts.inspect
    end

    def count
      raise @project.inspect
      @allSamples = @project.samples
       ### create model method to return hash to caclulate all the sample field counts

    end

    # GET /projects/new
    def new
      @project = Project.new
    end

    # GET /projects/1/edit
    def edit
    end

    # POST /projects
    # POST /projects.json
    def create
      #raise params.inspect
      @project = Project.new(project_params)
      respond_to do |format|
        if @project.save
          format.html { redirect_to :root, notice: 'Project was successfully created.' }
        else
          format.html { redirect_to :root, notice: 'Failure!!.' }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /projects/1
    # PATCH/PUT /projects/1.json
    def update
      #raise project_params.inspect
      respond_to do |format|
        if @project.update(project_params)
          @project.save!
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.json { head :no_content }
        else
          raise 'NOT SAVED'.inspect
          format.html { render action: 'edit' }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /projects/1
    # DELETE /projects/1.json
    def destroy
      @project.destroy
      respond_to do |format|
        format.html { redirect_to :root }
        format.json { head :no_content }
      end
    end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name,:total,:cases,:cntls,:purpose)
  end

end
