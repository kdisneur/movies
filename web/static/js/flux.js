let actions    = require("web/static/js/actions")
let MovieStore = require("web/static/js/movie_store")

let stores = {
  MovieStore: new MovieStore()
}

export default new Fluxxor.Flux(stores, actions);
