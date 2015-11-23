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

end
