class Admin::QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @categories = Category.all
    @question = Question.new
    2.times{@question.answers.build}
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = I18n.t "message.create"
      redirect_to admin_questions_path
    else
      render "new"
    end
  end

  def edit
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find params[:id]
    if @question.update_attributes question_params
      flash[:success] = I18n.t "message.update"
      redirect_to admin_questions_path
    else
      render "edit"
    end
  end

  def show
    @question = Question.find params[:id]
  end

  def destroy
    Question.find(params[:id]).destroy
    flash[:success] = I18n.t "message.delete"
    redirect_to admin_questions_path
  end

  private
  def question_params
    params.require(:question).permit :content, category_ids: [],
      answers_attributes: [:id, :body, :status, :_destroy]
  end
end