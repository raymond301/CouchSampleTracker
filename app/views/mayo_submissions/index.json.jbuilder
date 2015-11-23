json.array!(@mayo_submissions) do |mayo_submission|
  json.extract! mayo_submission, :id, :sample_id, :plate, :well, :volume, :concentration, :lane_number, :sequence_index, :flowcell, :ngs_protal_batch
  json.url mayo_submission_url(mayo_submission, format: :json)
end
