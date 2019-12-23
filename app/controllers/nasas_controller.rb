class NasasController < ApplicationController

    def search
        @files = Nasa.search_by_term(params[:query])
        render json: @files 
    end

end
