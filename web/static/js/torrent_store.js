let Constants = require("web/static/js/constants")

let TorrentStore = Fluxxor.createStore({
  initialize: function() {
    this.loading = false
    this.torrents  = []
    this.error   = null

    this.bindActions(
      Constants.LOAD_TORRENTS,         this.onLoadTorrents,
      Constants.LOAD_TORRENTS_SUCCESS, this.onLoadTorrentsSuccess,
      Constants.LOAD_TORRENTS_FAIL,    this.onLoadTorrentsFail
    )
  },

  onLoadTorrents: function() {
    this.loading = true
    this.emit("change")
  },

  onLoadTorrentsSuccess: function(payload) {
    this.loading = false
    this.error   = false
    this.torrents.push.apply(this.torrents, payload.torrents)
    this.emit("change")
  },

  onLoadTorrentsFail: function(payload) {
    this.loading = false
    this.error   = payload.error
    this.emit("change")
  },

  getState: function() {
    return {
      error:    this.error,
      loading:  this.loading,
      torrents: this.torrents
    }
  }
})

export default TorrentStore
