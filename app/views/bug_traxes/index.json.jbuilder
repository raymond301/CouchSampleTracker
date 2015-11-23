json.array!(@bug_traxes) do |bug_trax|
  json.extract! bug_trax, :id, :submitter, :url, :description, :level, :tag
  json.url bug_trax_url(bug_trax, format: :json)
end
