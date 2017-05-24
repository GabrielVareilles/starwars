class PagesController < ApplicationController

  BASE_URL = 'http://swapi.co/api/'
  def home
    @planets = HTTParty.get(BASE_URL + 'planets')['results'].pluck('name','url')
  end

  def planet
    request = HTTParty.get(BASE_URL + 'people' )
    people_count = request['count'].to_i
    page_count = (people_count / 10.0).ceil
    @colored_people = []
    (1..page_count).each_with_index do |page|

      @colored_people += HTTParty.get(BASE_URL + 'people' + '/?page=' + (page).to_s)['results']
    end
    @colored_people = @colored_people.select {|x| x != nil }
    .select {|x| x['homeworld'] == params['url']}
    .select {|x| (x['skin_color'].include?('brown') || x['skin_color'].include?('green')) }

  end
end
