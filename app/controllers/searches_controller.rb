class SearchesController < ApplicationController
    before_action :store_location

    def autocomplete_search
        query = params[:name]
        pastes = Paste.where{(has_randomized_title == false) & (content =~ "%#{query}%")}
        titles = pastes.map{|p| p.title}
        render json: titles
    end

    def search
       query = params[:search_field]
       @pastes = Paste.where{content =~ "%#{query}%"}
    end
end
