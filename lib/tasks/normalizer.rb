require 'pp'

## Modify all samples, attributes specific
Sample.all.each do |s|
  if s.case_control =~ /case/i
    s.case_control = "Case"
  elsif s.case_control =~ /control/i
    s.case_control = "Control"
  end


  if ! s.gender.blank? then s.gender.downcase.capitalize! end
  if ! s.species.blank? then s.species.downcase.capitalize! end
  if ! s.tissue_source.blank? then s.tissue_source.downcase.capitalize! end

  br
  if s.cancer_type == "BR"
    s.cancer_type = "Breast"
  elsif s.cancer_type == "br"
      s.cancer_type = "Breast"
  elsif s.cancer_type == "breast_cancer"
    s.cancer_type = "Breast"
  elsif s.cancer_type == "OV"
    s.cancer_type = "Ovarian"
  elsif s.cancer_type == "BR/OV"
    s.cancer_type = "Breast/Ovarian"
  elsif s.cancer_type == "TNBC"
    s.cancer_type = "Triple Negative Breast"
  else
    s.cancer_type.capitalize!
  end

  s.save!
end



#### need to renormalize the project designation
### gepar contains BCFRs, need to remove