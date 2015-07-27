json.request_token do
  json.user_id @user.id
  json.request_token @user.request_token.content
  json.ticket_id @user.ticket.id
end