class NasasController < ApplicationController
    def search
        @files = Nasa.search_by_term(params[:query]).paginate(page: params[:page], per_page: params[:perPage])
        if params[:media] #if statements are being used to filter the search parameters
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
            file: @files.as_json(only: [:id, :title, :thumb_url]), #using :only to optimize the amount of information that needs to be sent
            page: @files.current_page,
            pages: @files.total_pages
        }
    end

    def show
        @file = Nasa.find_by(id: params[:id])
        render json: {
            file: @file.as_json(include: { #using :include to get data from nested models
                keywords: {only: [:phrase]},
                hrefs: {only: [:image_size_url]}
            })
        }
    end
end
