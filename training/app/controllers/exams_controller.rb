class ExamsController < ApplicationController
	def index
		@exams = Exam.all
	end

	def new
		@exams = Exam.new
	end

	def edit
		@exams = Exam.find(params[:id])
	end

	def create
		@exams = Exam.new exam_params
		if @exams.save
			flash[:success] = "Created Exam successfull!"
			redirect_to exams_path
		else
			render "new"
		end
	end

	def update
		@exams = Exam.find(params[:id])
	  if @exams.update_attributes(exam_params)
	    redirect_to exams_path
	   else
      render "edit"
    end
	end

	def show
		
	end

	def destroy
		@exams = Exam.find(params[:id]).destroy
		redirect_to exams_path
	end

	private
	  def exam_params
	  	params.require(:exam).permit(:name, :time)
	  end
end
