let Constants = require("web/static/js/constants")

let RatingStore = Fluxxor.createStore({
  initialize: function() {
    this.loading   = false
    this.ratings   = []
    this.error     = null

    this.bindActions(
      Constants.LOAD_RATINGS,         this.onLoadRatings,
      Constants.LOAD_RATINGS_SUCCESS, this.onLoadRatingsSuccess,
      Constants.LOAD_RATINGS_FAIL,    this.onLoadRatingsFail
    )
  },

  onLoadRatings: function() {
    this.loading   = true
    this.error     = null
    this.ratings   = []
    this.emit("change")
  },

  onLoadRatingsSuccess: function(payload) {
    this.loading   = false
    this.error     = null
    this.ratings   = payload.ratings
    this.emit("change")
  },

  onLoadRatingsFail: function(payload) {
    this.loading = false
    this.error   = payload.error
    this.emit("change")
  },

  getState: function() {
    return {
      error:     this.error,
      loading:   this.loading,
      ratings:   this.ratings
    }
  }
})

export default RatingStore
