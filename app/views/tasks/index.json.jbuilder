json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :expected_start_date, :expected_end_date, :start_date, :end_date, :parent_id, :level, :man_hours, :progress, :description, :deleted, :project_id
  json.url task_url(task, format: :json)
end
