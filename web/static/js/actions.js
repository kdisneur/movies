let Constants = require("web/static/js/constants")
let Server    = require("web/static/js/owned-movies/server")

let actions = {
  loadOwnedMovies: function(apiKey) {
    this.dispatch(Constants.LOAD_OWNED_MOVIES)
    new Server().loadOwnedMovies(apiKey,
      (movies) => { this.dispatch(Constants.LOAD_OWNED_MOVIES_SUCCESS, {movies: movies}) }.bind(this),
      (error)  => { this.dispatch(Constants.LOAD_OWNED_MOVIES_FAIL, {error: error}) }.bind(this)
    )
  },

  loadTorrents: function(imdbId) {
    this.dispatch(Constants.LOAD_TORRENTS)
    new Server().loadTorrents(imdbId,
      (torrents) => { this.dispatch(Constants.LOAD_TORRENTS_SUCCESS,  {torrents: torrents}) }.bind(this),
      (error)    => { this.dispatch(Constants.LOAD_TORRENTS_FAIL, {error: error}) }.bind(this)
    )
  },

  loadSubtitles: function(imdbId) {
    this.dispatch(Constants.LOAD_SUBTITLES)
    new Server().loadSubtitles(imdbId,
      (subtitles) => { this.dispatch(Constants.LOAD_SUBTITLES_SUCCESS, {subtitles: subtitles}) }.bind(this),
      (error)     => { this.dispatch(Constants.LOAD_SUBTITLES_FAIL, {error: error}) }.bind(this)
    )
  }
}

export default actions
