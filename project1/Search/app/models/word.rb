class Word < ActiveRecord::Base
  belongs_to :categories
  has_many   :answers, dependent: :destroy
<<<<<<< HEAD

=======
  
>>>>>>> Admin manager: word and answer
  validates  :body, presence: true, uniqueness: true
  validates  :category_id, presence: true
  validate   :check_status

  accepts_nested_attributes_for :answers, allow_destroy: true
<<<<<<< HEAD
<<<<<<< HEAD

  private
=======
  scope :search_word, ->params,user {
    leanned  = "words.id IN (SELECT word_id FROM results WHERE lesson_id IN 
          (SELECT id FROM lessons WHERE user_id = #{user.id}))"
    notlean  = "words.id NOT IN (SELECT word_id FROM results WHERE lesson_id IN 
          (SELECT id FROM lessons WHERE user_id = #{user.id}))"
    category = "words.category_id = #{params[:category_id]}"
=======
>>>>>>> search word

  scope :search_word, -> params, user {
    where_type = params[:status] == "notlean" ? "NOT IN" : "IN"

    query_status = "words.id #{where_type}(SELECT word_id FROM results WHERE lesson_id IN 
      (SELECT id FROM lessons WHERE user_id = #{user.id}))" if params[:status]

    if params[:category_id] && params[:category_id] != ''
      if params[:status] != ''
        joins(:answers).select("words.body as word_name, answers.body as answer_name")
          .where("words.category_id = #{params[:category_id]}")
          .where(query_status)
          .where("answers.status = 't'")
      else
        joins(:answers).select("words.body as word_name, answers.body as answer_name")
          .where("words.category_id = #{params[:category_id]}")
          .where("answers.status = 't'")
      end
    else
      if params[:status] != ''
        joins(:answers).select("words.body as word_name, answers.body as answer_name")
          .where(query_status)
          .where("answers.status = 't'")
      else
        joins(:answers).select("words.body as word_name, answers.body as answer_name")
          .where("answers.status = 't'")
      end
    end 
  }

  private

>>>>>>> Admin manager: word and answer
  def check_status
    if answers.length < 2
      errors.add(:base, "Minimum 2 characters")
    elsif answers.select{|answer| answer.status}.count == 0  
      errors.add(:base, "Please select one correct answer")
    elsif answers.select{|answer| answer.status}.count > 1 
      errors.add(:base, "Only one correct answer is selected")
    end
  end
end
