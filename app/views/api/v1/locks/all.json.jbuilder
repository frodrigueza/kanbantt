json.array! @locks do |lock|
	json.id lock.id
  json.source lock.locker_id
  json.target lock.locked_id
  json.type "0"
end