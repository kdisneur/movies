let Constants = require("web/static/js/constants")

let SubtitleStore = Fluxxor.createStore({
  initialize: function() {
    this.loading   = false
    this.subtitles = []
    this.error     = null

    this.bindActions(
      Constants.LOAD_SUBTITLES,         this.onLoadSubtitles,
      Constants.LOAD_SUBTITLES_SUCCESS, this.onLoadSubtitlesSuccess,
      Constants.LOAD_SUBTITLES_FAIL,    this.onLoadSubtitlesFail
    )
  },

  onLoadSubtitles: function() {
    this.loading   = true
    this.subtitles = []
    this.emit("change")
  },

  onLoadSubtitlesSuccess: function(payload) {
    this.loading   = false
    this.error     = false
    this.subtitles = payload.subtitles
    this.emit("change")
  },

  onLoadSubtitlesFail: function(payload) {
    this.loading = false
    this.error   = payload.error
    this.emit("change")
  },

  getState: function() {
    return {
      error:     this.error,
      loading:   this.loading,
      subtitles: this.subtitles
    }
  }
})

export default SubtitleStore
