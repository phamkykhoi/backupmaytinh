class BulletinsController < ApplicationController
  layout "bulletin", :only => [:show]

  def show
    @bulletin = Bulletin.latest.first
  end
end