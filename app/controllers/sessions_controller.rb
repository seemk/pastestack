class SessionsController < ApplicationController
    
    def new

    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            sign_in user
            redirect_back_or(root_url)
        else
            render 'new'
        end
    end

    def destroy
        sign_out
        redirect_back_or(root_url)
    end

end
