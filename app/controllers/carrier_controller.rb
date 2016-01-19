class CarrierController < ApplicationController

  def notifications
    @notices = Carrier.getCurrentNotices
    #raise @notices.inspect
  end

  def new

  end

  def create_source
    #raise params.inspect
    Carrier.create_from_source_manifest(params)

  end

  def create_submission

  end

  def ggps_config_new
    @project = Project.all.map{|p| [p.name,p.id]}
  end

  def ggps_config_create

  end


end
