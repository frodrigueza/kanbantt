json.array! @projects do |project|
  json.id project.id
  json.text project.name
  json.start_date project.f_start_date
  json.end_date project.f_end_date
  json.progress project.progress_f/100
  json.open false
  json.color "limegreen"
end