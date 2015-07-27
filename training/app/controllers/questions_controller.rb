class QuestionsController < ApplicationController
	# before_action :check_status, only: [:update, :create]
	def index
		@questions = Question.all
	end

	def new
		@questions = Question.new
		# 3.times{@questions.answers.build}
	end

	def edit
		@questions = Question.find(params[:id])
	end

	def create
		# render text: question_params
		@questions = Question.new question_params
		if @questions.save
			flash[:success] = "Created question successfull!"
			redirect_to questions_path
		else
			render "new"
		end
	end

	def update
		# render text: question_params
		@questions = Question.find(params[:id])
		if @questions.update_attributes question_params
	    redirect_to :back
	  else
      render "edit"
    end
	end

	def show
		
	end

	def destroy
		Question.find(params[:id]).destroy
		redirect_to questions_path
	end

	private
  def question_params
  	params.require(:question).permit(:content, :exam_id, answers_attributes: [:id, :body, :status])
  end

  def check_status
  	render text: params
  end
end