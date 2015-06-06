class Server {
  loadOwnedMovies(apiKey, success, failure) {
    this.doGet("/api/movies/owned", success, failure)
  }

  loadRatings(imdbId, success, failure) {
    this.doGet(`/api/movies/ratings/${imdbId}`, success, failure)
  }

  loadSubtitles(imdbId, success, failure) {
    this.doGet(`/api/movies/subtitle/${imdbId}`, success, failure)
  }

  loadTorrents(imdbId, success, failure) {
    this.doGet(`/api/movies/torrent/${imdbId}`, success, failure)
  }

  submitRating(imdbId, rating, success, failure) {
    this.doPost(`/api/movies/ratings/${imdbId}`, rating, success, failure)
  }

  findAPIKey() {
    return $(".owned-movies-app-js").data("api-key")
  }

  doGet(url, success, failure) {
    this.do("GET", url, {}, success, failure)
  }

  doPost(url, data, success, failure) {
    this.do("POST", url, data, success, failure)
  }

  do(type, url, data, success, failure) {
    $.ajax(url, {
      dataType: "json",
      headers:  { "api-key": this.findAPIKey() },
      method:   type,
      data:     data,
      error:    function(_jqXHR, _textStatus, errorThrown) { failure(errorThrown); },
      success:  function(data, _textStatus, _jqXHR) { success(data) }
    })
  }
}

export default Server
