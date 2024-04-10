class SearchService
  def connection
    Faraday.new(url: "http://localhost:3000/api/v0")
  end

  def get_url(uri)
    response = connection.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def find_artists
    get_url("artists")
  end
end