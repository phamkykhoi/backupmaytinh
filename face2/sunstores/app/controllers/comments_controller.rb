class CommentsController < ApplicationController
  def index 
  	@comments = Comment.where('id > ?', params[:after_id].to_i).order('created_at DESC')
  end
end