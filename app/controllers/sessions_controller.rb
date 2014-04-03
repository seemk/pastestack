class SessionsController < ApplicationController
    
    def new

    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            sign_in user
        end
        redirect_back_or(root_url)
    end

    def create_oauth
        user = User.from_omniauth(env["omniauth.auth"])
        sign_in user
        redirect_back_or(root_url)
    end

    def destroy
        sign_out
        redirect_back_or(root_url)
    end

end
