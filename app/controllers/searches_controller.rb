class SearchesController < ApplicationController
    before_action :store_location

    def search
        query = params[:search_field]
        @pastes = Paste.where{content =~ "%#{query}%"}
    end
end
