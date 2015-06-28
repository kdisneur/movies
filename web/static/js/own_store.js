let Constants = require("web/static/js/constants")

let OwnStore = Fluxxor.createStore({
  initialize: function() {
    this.movies  = {}

    this.bindActions(
      Constants.LOAD_MARK_AS_OWNED_MOVIE,         this.onLoadMovie,
      Constants.LOAD_MARK_AS_OWNED_MOVIE_SUCCESS, this.onLoadMovieSuccess,
      Constants.LOAD_MARK_AS_OWNED_MOVIE_FAIL,    this.onLoadMovieFail
    )
  },

  onLoadMovie: function(movie) {
    this.movies[movie.imdbId] = "loading"
    this.emit("change")
  },

  onLoadMovieSuccess: function(movie) {
    this.movies[movie.imdbId]  = "added"
    this.emit("change")
  },

  onLoadMovieFail: function(movie) {
    this.movies[movie.imdbId]  = "failed"
    this.emit("change")
  },

  getState: function(imdbId) {
    return {
      movie: this.movies[imdbId]
    }
  }
})

export default OwnStore
