class UsersController < ApplicationController

  def index
    @users = User.all

    # @ranking = Item.find_by(User.group(:qiita_id).order('count(qiita_id) desc').pluck(:qiita_id))
    # p @ranking
  end


end
