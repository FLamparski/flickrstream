class Flickr
  constructor: (@_, @apiKey) ->

  _makeUrl: (method, options) ->
    "https://api.flickr.com/services/rest/?\
    method=#{method}" + @_.keys(options).reduce (str, key) ->
      str + "&#{key}=" + encodeURI options[key]
    , ''
    
  call: (method, options) ->
    url = @_makeUrl(method, @_.extend options,
      api_key: @apiKey
      format: 'json'
      nojsoncallback: 1
    )
    console.log 'flickr call', url
    fetch url
    .then (response) ->
      response.json()

  getPhotoUrl: (photo) ->
    "https://farm#{photo.farm}.staticflickr.com/#{photo.server}/\
    #{photo.id}_#{photo.secret}_c.jpg"

  getPhotoPage: (photo) ->
    "https://www.flickr.com/#{photo.owner}/#{photo.id}/"
