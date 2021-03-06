class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @votes = Vote.where(user_id: @user.id)

    if @user.nil?
      head :not_found
    end
  end

  def new
  end

  def create
    name = params[:name]
    user = User.find_by(name: name)

    if user
      flash[:success] = "Ur logged tf in, #{name}! (also ur my bro)"
      session[:user_id] = user.id
      redirect_to root_path
    else
      user = User.new(name: name)

      if user.save
        flash[:success] = "New account created. Welcome tf to our site, #{name} (also ur my bro now, js)"
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash.now[:error] = "uh oh bro, looks like something went wrong..."
        render :new
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Ur logged tf out, bro!! high five!"
    redirect_to root_path
  end

  def upvote
    preexisting = Vote.find_by(user_id: session[:user_id], medium_id: params[:id])

    if preexisting
      flash[:error] = "bro lol you can't vote for the same thing twice! smh dude u r a TRIP!"
      show_redirect
    else
      vote = Vote.new(user_id: session[:user_id], medium_id: params[:id])

      if vote.save
        flash[:success] = "bro nice upvote! i saw that!! high five for the positivity bro.."
        show_redirect
      else
        flash[:error] = "uh bro something did not work sorry :/ (ps i'm bailing) [maybe try tagging in first bro?]"
        show_redirect
      end
    end
  end

  private

  def show_redirect
    return redirect_to medium_path(params[:id])
  end

end
