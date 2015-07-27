class SubjectsController < ApplicationController
  def index
  	@subjects = Subject.all
  end

  def show
  	@subject = Subject.find(params[:id])
  end

  def create
  	@subject = Subject.new(params[:name])
    if @subject.save
      render :partial => 'subject', :object => @subject
    end
  end
end
