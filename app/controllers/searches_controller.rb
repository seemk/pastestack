class SearchesController < ApplicationController
    before_action :store_location, only: [:search]

    def autocomplete_search
        query = params[:name]
        pastes = Paste.where{(exposure == 1) & 
                             (has_randomized_title == false) &
                             (content =~ "%#{query}%")}.limit(8)
        titles = pastes.map{ |p| p.title }
        render json: titles
    end

    def search
       query = params[:search_field]
       @pastes = Paste.where{(exposure == 1) & (content =~ "%#{query}%")}.paginate(
           :page => params[:page], :per_page => 25)
    end
end
