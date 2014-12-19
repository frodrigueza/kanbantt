json.array!(@resources_reports) do |resources_report|
  json.extract! resources_report, :id, :task_id, :resources, :user_id
  json.url resources_report_url(resources_report, format: :json)
end
