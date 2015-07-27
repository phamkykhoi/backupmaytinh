class LessonsController < ApplicationController
  def new
    @category = Category.find params[:category_id]
    @lesson = @category.lessons.build
    @questions = @category.questions.category_questions params[:category_id]
  end
end