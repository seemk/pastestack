class SearchesController < ApplicationController
    before_action :store_location, only: [:search]

    def autocomplete_search
        query = params[:name]
        pastes = Paste.where{(exposure == 1) & 
                             (title != nil) &
                             (content =~ "%#{query}%")}.limit(8)
        results = pastes.map{ |p| p.slice(:token, :title, :language) }
        Rails.logger.debug results
        render json: results
    end

    def search
       query = params[:search_field]
       @pastes = Paste.where{(exposure == 1) & (content =~ "%#{query}%")}.paginate(
           :page => params[:page])
    end
end
