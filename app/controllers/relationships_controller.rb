class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    if current_user == relationship.follower
      relationship.destroy
      flash[:notice] = "You are no longer following them--they didn't deserve you!"
      redirect_to people_path
    else
      flash.now[:errors] = "You cannot do that, bahaha!"
      render 'relationships/index'
    end
  end

  def create
    relationship = Relationship.new(leader_id: params[:leader_id], follower_id: current_user.id)
    @user = User.find(params[:leader_id])
    if relationship.unique? and not relationship.follow_self? and relationship.save
      flash[:notice] = "You are now following #{@user.username}"
      redirect_to people_path
    else
      flash[:errors] = "I'm sorry, that didn't work. Are you already following that person?"
      render 'users/show'
    end
  end

end