let Constants = require("web/static/js/constants")
let Server    = require("web/static/js/server")

let actions = {
  loadOwnedMovies: function() {
    this.dispatch(Constants.LOAD_OWNED_MOVIES)
    new Server().loadOwnedMovies(
      (movies) => { this.dispatch(Constants.LOAD_OWNED_MOVIES_SUCCESS, {movies: movies}) }.bind(this),
      (error)  => { this.dispatch(Constants.LOAD_OWNED_MOVIES_FAIL, {error: error}) }.bind(this)
    )
  },

  loadRatings: function(imdbId) {
    this.dispatch(Constants.LOAD_RATINGS)
    new Server().loadRatings(imdbId,
      (ratings) => { this.dispatch(Constants.LOAD_RATINGS_SUCCESS, {ratings: ratings}) }.bind(this),
      (error)   => { this.dispatch(Constants.LOAD_RATINGS_FAIL, {error: error}) }.bind(this)
    )
  },

  loadSubtitles: function(imdbId) {
    this.dispatch(Constants.LOAD_SUBTITLES)
    new Server().loadSubtitles(imdbId,
      (subtitles) => { this.dispatch(Constants.LOAD_SUBTITLES_SUCCESS, {subtitles: subtitles}) }.bind(this),
      (error)     => { this.dispatch(Constants.LOAD_SUBTITLES_FAIL, {error: error}) }.bind(this)
    )
  },

  loadTorrents: function(imdbId) {
    this.dispatch(Constants.LOAD_TORRENTS)
    new Server().loadTorrents(imdbId,
      (torrents) => { this.dispatch(Constants.LOAD_TORRENTS_SUCCESS, {torrents: torrents}) }.bind(this),
      (error)    => { this.dispatch(Constants.LOAD_TORRENTS_FAIL, {error: error}) }.bind(this)
    )
  },

  loadWishedMovies: function() {
    this.dispatch(Constants.LOAD_OWNED_MOVIES)
    new Server().loadWishedMovies(
      (movies) => { this.dispatch(Constants.LOAD_OWNED_MOVIES_SUCCESS, {movies: movies}) }.bind(this),
      (error)  => { this.dispatch(Constants.LOAD_OWNED_MOVIES_FAIL, {error: error}) }.bind(this)
    )
  },

  searchMovies: function(query) {
    this.dispatch(Constants.LOAD_OWNED_MOVIES)
    new Server().searchMovies(query,
      (movies) => { this.dispatch(Constants.LOAD_OWNED_MOVIES_SUCCESS, {movies: movies}) }.bind(this),
      (error)  => { this.dispatch(Constants.LOAD_OWNED_MOVIES_FAIL, {error: error}) }.bind(this)
    )
  },

  submitRating: function(imdbId, rating) {
    this.dispatch(Constants.LOAD_RATINGS)
    new Server().submitRating(imdbId, rating,
      (ratings) => { this.dispatch(Constants.LOAD_RATINGS_SUCCESS, {ratings: ratings}) }.bind(this),
      (error)   => { this.dispatch(Constants.LOAD_RATINGS_FAIL, {error: error}) }.bind(this)
    )
  },

  wishMovie: function(imdbId) {
    this.dispatch(Constants.LOAD_WISHED_MOVIE, { imdbId: imdbId })
    new Server().wishMovie(imdbId,
      (_)     => { this.dispatch(Constants.LOAD_WISHED_MOVIE_SUCCESS, { imdbId: imdbId }) }.bind(this),
      (error) => { this.dispatch(Constants.LOAD_WISHED_MOVIE_FAIL, {error: error}) }.bind(this)
    )
  }
}

export default actions
