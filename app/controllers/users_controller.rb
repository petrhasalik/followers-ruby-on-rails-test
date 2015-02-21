class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User created'
      redirect_to users_path
    else
      flash[:danger] = 'User creation failed'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @followings = @user.followings
    @nonfollowings = @user.nonfollowings
  end

  def follow
    @user = User.find(params[:id])
    following = User.find(params[:follow])
    if @user.follow(following)
      flash[:success] = 'User followed'
    else
      flash[:danger] = 'Following failed'
    end
    redirect_to user_path(@user)
  end

  def unfollow
    @user = User.find(params[:id])
    unfollowing = User.find(params[:unfollow])
    if @user.unfollow(unfollowing)
      flash[:success] = 'User unfollowed'
    else
      flash[:danger] = 'Unfollowing failed'
    end
    redirect_to user_path(@user)
  end

  private

    def user_params
      params.require(:user).permit(:name)
    end

end