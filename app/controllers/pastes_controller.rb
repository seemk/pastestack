class PastesController < ApplicationController
    before_action :store_location
    
    def new
        @paste = Paste.new
    end

     def create
        if signed_in?
            @paste = current_user.pastes.build(paste_params)
        else
            @paste = Paste.new(paste_params)
        end
        
        if @paste.save
            redirect_to @paste
        else
            render 'new'
        end
    end

    def destroy
    end

    def public_pastes
        Paste.where{ exposure == 1 }
    end

    def user_pastes
        if signed_in?
            current_user.pastes
        else
            []
        end
    end

    def index
        @user_pastes = user_pastes.page(params[:priv_page])
        @pastes = public_pastes.page(params[:public_page])
    end

    def paste_params
        params.require(:paste).permit(:title, :content, :language, :expiration, :exposure)
    end

    def show
        @paste = Paste.find(params[:id])
    end

end
