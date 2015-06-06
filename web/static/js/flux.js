let actions       = require("web/static/js/actions")
let MovieStore    = require("web/static/js/movie_store")
let RatingStore   = require("web/static/js/rating_store")
let SubtitleStore = require("web/static/js/subtitle_store")
let TorrentStore  = require("web/static/js/torrent_store")

let stores = {
  MovieStore:    new MovieStore(),
  RatingStore:   new RatingStore(),
  SubtitleStore: new SubtitleStore(),
  TorrentStore:  new TorrentStore()
}

export default new Fluxxor.Flux(stores, actions);
