let actions       = require("web/static/js/actions")
let MovieStore    = require("web/static/js/movie_store")
let OwnStore      = require("web/static/js/own_store")
let RatingStore   = require("web/static/js/rating_store")
let SubtitleStore = require("web/static/js/subtitle_store")
let TorrentStore  = require("web/static/js/torrent_store")
let WishStore     = require("web/static/js/wish_store")

let stores = {
  MovieStore:    new MovieStore(),
  OwnStore:      new OwnStore(),
  RatingStore:   new RatingStore(),
  SubtitleStore: new SubtitleStore(),
  TorrentStore:  new TorrentStore(),
  WishStore:     new WishStore()
}

export default new Fluxxor.Flux(stores, actions);
