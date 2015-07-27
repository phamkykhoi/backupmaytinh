json.ticket do
  json.current_count @ticket.current_count
  json.next_recover @ticket.next_recover
  json.recover_time @ticket.recover_time
  json.limited @ticket.limited.present?
end
