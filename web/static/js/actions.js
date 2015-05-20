let Constants = require("web/static/js/constants")
let Server    = require("web/static/js/owned-movies/server")

let actions = {
  loadOwnedMovies: function(apiKey) {
    this.dispatch(Constants.LOAD_OWNED_MOVIES)
    new Server().loadOwnedMovies(apiKey,
      (movies) => { this.dispatch(Constants.LOAD_OWNED_MOVIES_SUCCESS, {movies: movies}) }.bind(this),
      (error)  => { this.dispatch(Constants.LOAD_OWNED_MOVIES_FAIL, {error: error}) }.bind(this)
    )
  }
}

export default actions
