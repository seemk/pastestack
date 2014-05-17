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
        paste = Paste.find(params[:id])
        paste.destroy
        redirect_url = request.referer.include?("#{paste.title}") ? pastes_url : :back
        redirect_to redirect_url
    end

    def public_pastes
        Paste.where{ exposure == 1 }
    end

    def user_pastes
        if signed_in?
            current_user.pastes
        else
            nil
        end
    end

    def index
        pastes_for_user = user_pastes
        if pastes_for_user
            @user_pastes = pastes_for_user.page(params[:priv_page])
        end
        @pastes = public_pastes.page(params[:public_page])
    end

    def paste_params
        params.require(:paste).permit(:title, :content, :language, :expiration, :exposure)
    end

    def show
        @paste = Paste.find(params[:id])
    end

end
