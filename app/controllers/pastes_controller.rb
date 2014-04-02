class PastesController < ApplicationController
    before_action :store_location
    
    def new
        Rails.logger.debug("SCHEME:")
        Rails.logger.debug(@scheme)
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

    def index
        @pastes = Paste.where{exposure == 1}
    end

    def paste_params
        params.require(:paste).permit(:title, :content, :language, :expiration, :exposure)
    end

    def show
        @paste = Paste.find(params[:id])
    end

end
