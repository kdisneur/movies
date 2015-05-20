let Constants = require("web/static/js/constants")

let MovieStore = Fluxxor.createStore({
  initialize: function() {
    this.loading = false
    this.movies  = []
    this.error   = null

    this.bindActions(
      Constants.LOAD_OWNED_MOVIES,         this.onLoadMovie,
      Constants.LOAD_OWNED_MOVIES_SUCCESS, this.onLoadMovieSuccess,
      Constants.LOAD_OWNED_MOVIES_FAIL,    this.onLoadMovieFail
    )
  },

  onLoadMovie: function() {
    this.loading = true
    this.emit("change")
  },

  onLoadMovieSuccess: function(payload) {
    this.loading = false
    this.error   = false
    this.movies.push.apply(this.movies, payload.movies)
    this.emit("change")
  },

  onLoadMovieFail: function(payload) {
    this.loading = false
    this.error   = payload.error
    this.emit("change")
  },

  getState: function() {
    return {
      error:   this.error,
      loading: this.loading,
      movies:  this.movies
    }
  }
})

export default MovieStore
