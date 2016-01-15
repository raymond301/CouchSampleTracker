class Project < ActiveRecord::Base
  has_and_belongs_to_many :samples

  def aggregateStatistics
    returnableMap = Hash.new
    samples = self.samples.select{|s| !s.failure }

    returnableMap['Case_Control'] = samples.group_by(&:case_control).map{|k,v| [k,v.count]}
    returnableMap['Gender'] = samples.group_by(&:gender).map{|k,v| [k,v.count]}
    returnableMap['Ethnicity'] = samples.group_by(&:ethnicity).map{|k,v| [k,v.count]}
    returnableMap['Cancer_Type'] = samples.group_by(&:cancer_type).map{|k,v| [k,v.count]}
    returnableMap['Tissue_Source'] = samples.group_by(&:tissue_source).map{|k,v| [k,v.count]}
    returnableMap['Species'] = samples.group_by(&:species).map{|k,v| [k,v.count]}
    returnableMap['Study_Groups'] = samples.group_by(&:site_of_origin_id).map{|k,v| [SiteOfOrigin.find(k).study_group,v.count]}

    freez = samples.map{|s| s.freezer_locations}.flatten
    returnableMap['Submit_Plates'] = freez.select{|s| s.plate_type == "Submission Plate" }.group_by(&:plate_name).map{|k,v| [k,v.count]}
    returnableMap['Source_Plates'] = freez.select{|s| s.plate_type == "Source Plate" }.group_by(&:plate_name).map{|k,v| [k,v.count]}

    ngs = samples.map{|s| s.mayo_submissions}.flatten
    returnableMap['NGS_Batches'] = ngs.group_by(&:ngs_protal_batch).map{|k,v| [k,v.count]}
    returnableMap['NGS_Flowcells'] = ngs.group_by(&:flowcell).map{|k,v| [k,v.count]}


    # raise samples.group_by(&:case_control).map{|k,v| [k,v.count]}.inspect

    return returnableMap

  end

end


#t.references :site_of_origin