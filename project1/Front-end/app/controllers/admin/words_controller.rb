class Admin::WordsController < Admin::AdminController
  def index   
    @words = Word.paginate page: params[:page], per_page: 15
  end

  def new
    @word = Word.new
    4.times{@word.answers.build}
  end

  def edit
    @word = Word.find params[:id]
  end

  def create
    @word = Word.new word_params
    if @word.save
      redirect_to admin_words_path
    else
      render "new"
    end
  end

  def update
    @word = Word.find params[:id]

    if @word.update_attributes word_params
      flash[:success] = "Update question successfull"
      redirect_to edit_admin_word_path params[:id]
    else
      render "edit"
    end
  end

  def destroy
    Word.find(params[:id]).destroy
    redirect_to admin_words_path
  end

  private
  
  def word_params
    params.require(:word).permit :body, :category_id,
      answers_attributes: [:id, :body, :status, :_destroy]
  end
end