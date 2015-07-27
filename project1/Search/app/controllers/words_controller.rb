class WordsController < ApplicationController
	before_action :logged_in_user
	def index
		@categories = Category.all
		@words = Word.search_word params, current_user
	end
end
