class StaticPagesController < ApplicationController
  def home
    @user = User.find current_user
    @lesson_categories = Category.category_lesson_user current_user
  end
end
