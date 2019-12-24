require 'net/http'
require 'json'

counter = 1

def valid_json?(json)
    !!JSON.parse(json)
rescue JSON::ParserError
    false
end

(1..68).each do |index|
    puts index
    url = "https://images-api.nasa.gov/search?page=#{index}&q=all"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    result['collection']['items'].each do |item|
        puts counter
        data = item['data'][0]
        if item["links"]
            thumb_url = item["links"][0]['href']
        end
        image = Nasa.create(title: data['title'],
                            photographer: data['photographer'], 
                            description: data['description'],
                            location: data['location'], 
                            media_type: data['media_type'],
                            date_created: data['date_created'], 
                            thumb_url: thumb_url)
        images_url = item['href']
        corrected_image_url = URI::escape(images_url)
        images_uri = URI(corrected_image_url)
        images_response = Net::HTTP.get(images_uri)
        if valid_json?(images_response)
            images_result = JSON.parse(images_response)
            images_result.each do |image_href|
                corrected_image_href = URI::escape(image_href)
                Href.create(image_size_url: corrected_image_href, nasa_id: image.id)
            end
        end

        if item['data'][0]['keywords']
            item['data'][0]['keywords'].each do |href|
                Keyword.create(phrase: href, nasa_id: image.id)
            end
        end
        counter = counter + 1
    end
end