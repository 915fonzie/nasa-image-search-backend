require 'net/http'
require 'json'

counter = 1 #used just to see the progress of the data being seeded

def valid_json?(json)
    !!JSON.parse(json)
rescue JSON::ParserError
    false
end

(1..68).each do |index| #The api where I'm getting the data only gives 100 items at a time, so I need to go through each page to get everything
    puts index
    url = "https://images-api.nasa.gov/search?page=#{index}&q=all" #sets the current page for the url
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    result['collection']['items'].each do |item| #going through each collection of an item
        puts counter
        data = item['data'][0] #used to make writing code a little easier
        if item["links"] # needed to check if this path existed before trying to get the thumb_url
            thumb_url = item["links"][0]['href']
        end
        image = Nasa.create(title: data['title'], #creating a new Object of item
                            photographer: data['photographer'], 
                            description: data['description'],
                            location: data['location'], 
                            media_type: data['media_type'],
                            date_created: data['date_created'], 
                            thumb_url: thumb_url)
        images_url = item['href'] #within the item Object, there's another url that needs to be parsed
        corrected_image_url = URI::escape(images_url)
        images_uri = URI(corrected_image_url)
        images_response = Net::HTTP.get(images_uri)

        if valid_json?(images_response) #there were certain urls that gave me a Access Denied, so need to check if the json was vaild
            images_result = JSON.parse(images_response)
            images_result.each do |image_href|
                corrected_image_href = URI::escape(image_href)
                Href.create(image_size_url: corrected_image_href, nasa_id: image.id) #This creates the urls for downloading the files at different sizes
            end
        end

        if item['data'][0]['keywords']
            item['data'][0]['keywords'].each do |keyword|
                Keyword.create(phrase: keyword, nasa_id: image.id) #This creates the keywords for each item
            end
        end
        counter = counter + 1
    end
end