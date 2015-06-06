let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin
let Loader          = require("web/static/js/components/loader")
let ErrorMessage    = require("web/static/js/components/error_message")
let MovieLine       = require("web/static/js/components/movie_line")
let SearchForm      = require("web/static/js/components/search_form")

let Application = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("MovieStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("MovieStore").getState();
  },

  handleSearch: function(query) {
    this.getFlux().actions.searchMovies(query)
  },

  render: function() {
    let movies = _.flatten(_.chunk(this.state.movies, 4).map(function(chunk) { return <MovieLine movies={chunk} type="condensed" /> }))

    return (
      <div>
        {this.state.error ? <ErrorMessage message={this.state.error} /> : null}
        <SearchForm onSearch={this.handleSearch.bind(this)} placeholder="Matrix, Batman,..." />
        {this.state.loading ? <Loader /> : null}
        {movies}
      </div>
    )
  }
})

export default Application
