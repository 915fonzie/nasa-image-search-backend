class NasasController < ApplicationController

    def search
        @files = Nasa.search_by_term(params[:query]).paginate(page: params[:page], per_page: params[:perPage])
        #if statements are being used to filter the search parameters
        if params[:media]
            @files.select! do |file|
                file[:media_type] == params[:media]
            end
        end
        if params[:startDate] && params[:endDate]
            @files.select! do |file|
                temp = file[:date_created].split('T')[0] 
                temp >= params[:startDate] && temp <= params[:endDate]
            end
        end
        render json: {
            file: @files.as_json(only: [:title, :thumb_url]),
            page: @files.current_page,
            pages: @files.total_pages
        }
    end

    def show
        @file = Nasa.find_by(id: params[:id])

        render json: {
            file: @file.as_json(include: {
                keywords: {only: [:phrase]},
                hrefs: {only: [:image_size_url]}
            })
        }
    end

end
