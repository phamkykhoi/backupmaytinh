json.ticket do
  json.current_count @supportership.supporter.ticket.current_count
  json.next_recover @supportership.supporter.ticket.next_recover
  json.recover_time @supportership.supporter.ticket.recover_time
end
