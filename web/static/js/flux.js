let actions       = require("web/static/js/actions")
let MovieStore    = require("web/static/js/movie_store")
let TorrentStore  = require("web/static/js/torrent_store")
let SubtitleStore = require("web/static/js/subtitle_store")

let stores = {
  MovieStore:    new MovieStore(),
  TorrentStore:  new TorrentStore(),
  SubtitleStore: new SubtitleStore()
}

export default new Fluxxor.Flux(stores, actions);
