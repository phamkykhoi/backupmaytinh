class MicropostsController < ApplicationController
	def index
		@posts = Micropost.all
	end

	def new
		@posts = Micropost.new
	end

	def create
		@posts = current_user.microposts.build micropost_params
		if @posts.save
			flash[:success] = "Micropost created!"
			redirect_to @posts
		else
			render "new"
		end
	end

	def show
		@posts = Micropost.find(params[:id])
	end

	def edit
		@posts = Micropost.find(params[:id])
	end


	def update
		@posts = Micropost.find(params[:id])
    if @posts.update_attributes(micropost_params)
      @posts.update_attributes(user_id: current_user.id)
      redirect_to @posts
    else
      render 'edit'
    end
	end

	def destroy
		Micropost.find(params[:id]).destroy
		redirect_to microposts_path
	end

	private	
	def micropost_params
		params.require(:micropost).permit(:content)
	end

end
