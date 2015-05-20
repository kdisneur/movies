let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin
let MovieLine       = require("web/static/js/owned-movies/components/movie_line")

let Application = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("MovieStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("MovieStore").getState();
  },

  componentDidMount: function() {
    this.getFlux().actions.loadOwnedMovies(this.props.apiKey)
  },

  render: function() {
    let movies = _.flatten(_.chunk(this.state.movies, 4).map(function(chunk) { return <MovieLine movies={chunk} /> }))
    let loader = function() {
      return (
        <div>
          <div className="sk-spinner sk-spinner-wave">
            <div className="sk-rect1"></div>
            <div className="sk-rect2"></div>
            <div className="sk-rect3"></div>
            <div className="sk-rect4"></div>
            <div className="sk-rect5"></div>
          </div>
          <div className="text-center sk-spinner-text">Loading...</div>
        </div>
      )
    }

   let error = function(error) {
     return (
       <div className="alert alert-danger">
         <button type="button" className="close" data-dismiss="alert" aria-hidden="true">×</button>
         <strong>Outch!</strong> {error}
       </div>
     )
   }

    return (
      <div>
        {this.state.error ? error(this.state.error) : null}
        {this.state.loading ? loader() : null}
        {movies}
      </div>
    )
  }
})

export default Application
