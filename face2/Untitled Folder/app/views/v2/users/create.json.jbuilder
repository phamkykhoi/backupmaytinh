json.user do
  if @user.errors.present?
    json.errors @user.errors.full_messages
  else
    json.id @user.id
    json.login_id @user.login_id
    json.request_token @user.request_token.content
    json.ticket_id @user.ticket.id
  end
end
