class AnswersController < ApplicationController
	def update_status
		Answer.where(:question_id => params[:question_id]).update_all(status: '')
		if(params[:answer_id] != 0) 
			Answer.where(:id => params[:answer_id]).where(:question_id => params[:question_id]).update_all(status: true)
		end
	end

	def destroy
		flash[:success] = 'Delete complete answer' # Not quite right!
	  Answer.find(params[:id]).destroy
    redirect_to :back
  end
end
