json.array!(@reports) do |report|
  json.extract! report, :id, :id_task, :progress, :date
  json.url report_url(report, format: :json)
end
