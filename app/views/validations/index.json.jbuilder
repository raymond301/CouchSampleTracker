json.array!(@validations) do |validation|
  json.extract! validation, :id, :sample_id, :confirmation, :reference_build, :chr, :pos, :ref, :alt, :hgvs_c, :hgvs_p, :gene, :transcript, :exon, :primer_forward, :primer_reverse, :pcr_size, :annealing_temp, :notes
  json.url validation_url(validation, format: :json)
end
