json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :project_id, :user_id, :role
  json.url assignment_url(assignment, format: :json)
end
