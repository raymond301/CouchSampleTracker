json.array!(@samples) do |sample|
  json.extract! sample, :id, :gender, :ethnicity, :cancer_type, :tissue_source, :case_control, :species, :aliquot_from
  json.url sample_url(sample, format: :json)
end
