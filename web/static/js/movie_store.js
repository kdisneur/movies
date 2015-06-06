let Constants = require("web/static/js/constants")

let MovieStore = Fluxxor.createStore({
  initialize: function() {
    this.error   = null
    this.loading = false
    this.movies  = []

    this.bindActions(
      Constants.LOAD_OWNED_MOVIES,         this.onLoadMovie,
      Constants.LOAD_OWNED_MOVIES_SUCCESS, this.onLoadMovieSuccess,
      Constants.LOAD_OWNED_MOVIES_FAIL,    this.onLoadMovieFail
    )
  },

  onLoadMovie: function() {
    this.error   = null
    this.loading = true
    this.movies  = []
    this.emit("change")
  },

  onLoadMovieSuccess: function(payload) {
    this.error   = null
    this.loading = false
    this.movies  = payload.movies
    this.emit("change")
  },

  onLoadMovieFail: function(payload) {
    this.error   = payload.error
    this.loading = false
    this.movies  = []
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
