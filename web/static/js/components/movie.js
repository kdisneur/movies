let MovieDetail = require("web/static/js/components/movie_detail")

let Movie = React.createClass({
  getInitialState: function() {
    return { opened: false }
  },

  handlePopupClosing: function(event) {
    this.setState({ opened: false })
  },

  handlePopupOpening: function(event) {
    this.setState({ opened: true })
  },

  render: function() {
    return (
      <div className="col-md-3 col-sm-6">
        <div className="m-movie" onClick={this.handlePopupOpening}>
          <img className="m-movie--poster img-rounded" src={this.props.movie.poster.medium} />
          <div className="m-movie-basic-informations">
            <div className="m-movie-basic-informations--runtime">
              {this.props.movie.runtime} min
            </div>
            <div className="m-movie-basic-informations--genres">
              {this.props.movie.genres.join(", ")}
            </div>
          </div>
          {this.state.opened ? <MovieDetail movie={this.props.movie} onClose={this.handlePopupClosing} /> : null}
        </div>
      </div>
    )
  }
})

export default Movie
