photoTemplate = (photo) ->
  """
  <article>
    <a href="#{photo.flickrUrl}" target="_blank">
      <h2>
        <span class="photo">
          <img src="#{photo.imageUrl}" alt="#{photo.title}" />
        </span>
        #{photo.title}
      </h2>
    </a>
    <p>#{photo.description}</p>
  </article>
  """

apiKey = '1d7456d453c150ad5bf6cf8737b235ea'

define [ '/bower_components/moment/moment.js',
'/bower_components/lodash/dist/lodash.js',
'/bower_components/fetch/fetch.js' ], (moment, _) ->
  flickr = new Flickr _, apiKey
  flickr.call 'flickr.photos.getRecent',
    per_page: 10
    extras: 'description,date_upload'
  .then (resp) ->
    newContent = resp.photos.photo.map (photo) ->
      photoObj = _.extend photo,
        flickrUrl: flickr.getPhotoPage photo
        imageUrl: flickr.getPhotoUrl photo
      console.log photoObj
      photoObj
    .reduce (html, photoObj) ->
      html + photoTemplate(photoObj)
    , ''
    document.querySelector('.photos > .container').innerHTML = newContent
