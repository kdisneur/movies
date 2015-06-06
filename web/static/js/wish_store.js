let Constants = require("web/static/js/constants")

let WishStore = Fluxxor.createStore({
  initialize: function() {
    this.movies  = {}

    this.bindActions(
      Constants.LOAD_WISHED_MOVIE,         this.onLoadWishesMovie,
      Constants.LOAD_WISHED_MOVIE_SUCCESS, this.onLoadWishesMovieSuccess,
      Constants.LOAD_WISHED_MOVIE_FAIL,    this.onLoadWishesMovieFail
    )
  },

  onLoadWishesMovie: function(movie) {
    this.movies[movie.imdbId] = "loading"
    this.emit("change")
  },

  onLoadWishesMovieSuccess: function(movie) {
    this.movies[movie.imdbId]  = "added"
    this.emit("change")
  },

  onLoadWishesMovieFail: function(movie) {
    this.movies[movie.imdbId]  = "failed"
    this.emit("change")
  },

  getState: function(imdbId) {
    return {
      movie: this.movies[imdbId]
    }
  }
})

export default WishStore
