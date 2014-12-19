json.project @id
json.expected @project_expected
json.real @project_real
json.tasks @array do |a|
  json.id a[0]
  json.expected a[1]
  json.real a[2]
end