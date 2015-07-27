class Answer < ActiveRecord::Base
  validates :body, presence: true
<<<<<<< HEAD
=======
  scope :word, -> word_id{where(word_id: word_id)}
  scope :answer, -> answer_id{where(id: answer_id)}
  scope :answer_correct, ->word_id{(where(word_id: word_id, status: true))}
>>>>>>> Admin manager: word and answer
end
