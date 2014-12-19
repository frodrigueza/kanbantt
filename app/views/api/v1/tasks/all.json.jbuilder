json.array! @tasks do |task|
  json.id task.id
  json.text task.name
  json.start_date task.expected_start_date_s
  json.end_date task.expected_end_date_s
  json.task_duration task.duration
  json.parent task.parent_id
  json.progress task.progress_f
  json.users task.user.try(:name)
  json.open true
end