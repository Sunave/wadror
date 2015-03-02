json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beercount brewery.beers.count
end
