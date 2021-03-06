class UsersController < ApplicationController
    before_action :store_location
    before_action :signed_in_user, only: [:edit, :update, :index]
    before_action :correct_user, only: [:edit, :update]
    before_action :admin_user, only: [:destroy, :index]

    def new
        @user = User.new
    end

    def edit
        @user = User.find(params[:id])
    end

    def index
        @users = User.all
    end

    def update
        if @user.update_attributes(user_params)
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        User.find(params[:id]).destroy
        redirect_to users_url
    end

    def show
        @user = User.find(params[:id])
        if signed_in? && (current_user.admin? || !current_user?(@user))
            @pastes = @user.pastes
        else
            @pastes = @user.pastes.where{exposure == 1}
        end
        
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in @user
            redirect_to root_path
        else
            render 'new'
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user(@user)
    end

    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end
end
