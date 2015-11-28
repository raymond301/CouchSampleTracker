class DashboardController < ApplicationController

  def index
    @currentProjects=Project.all
  end

  def find_sample
    @q=params['query']
    @samps=SampleAliase.allSamplesInQuery( params['query'] )
    @samps[0].primeName
  end

  def search_sample
  end

  def view_studygrps
    @styGrps=SiteOfOrigin.all
  end

  def edit_studygrps
    @styGrps=SiteOfOrigin.all
  end

  def updategrp
    #raise params['site_of_origin'].inspect
    grpparams = params.require(:site_of_origin).permit(:institution, :study_group, :contact, :contact_email, :contact_phone, :additional_details)
    respond_to do |format|
      if SiteOfOrigin.find(params['site_of_origin']['id']).update_attributes(grpparams) #update(params['site_of_origin'])
        format.html { redirect_to action: 'view_studygrps', notice: 'Study Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :root }
        format.json { render json: params['site_of_origin'], status: :unprocessable_entity }
      end
    end
  end

end
