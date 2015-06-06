let Ratings   = require("web/static/js/owned-movies/components/ratings")
let Subtitles = require("web/static/js/owned-movies/components/subtitles")
let Torrents  = require("web/static/js/owned-movies/components/torrents")

class MovieDetail extends React.Component {
  handlePopupClosing(event) {
    event.stopPropagation()
    this.props.onClose(event)
  }

  render() {
    return (
      <div className="m-movie-details is-displayed">
        <div className="container">
          <div className="row">
            <div className="col-xs-11">
              <h2 className="m-movie-details--title">
                {this.props.movie.title}
              </h2>
            </div>
            <div className="col-xs-1">
              <button href="#" className="close m-movie-details--close" onClick={this.handlePopupClosing.bind(this)}>
                ×
              </button>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-12 col-md-4">
              <div>
                <img className="m-movie-details--poster" src={this.props.movie.poster.medium} />
              </div>
            </div>
            <div className="col-sm-12 col-md-8">
              <div className="row m-movie-details--chracteristics">
                <div className="col-xs-12 col-md-6">
                  {this.props.movie.genres.join(", ")}
                </div>
                <div className="col-xs-6 col-md-3">
                  {this.props.movie.year}
                </div>
                <div className="col-xs-6 col-md-3">
                  {this.props.movie.runtime} min
                </div>
              </div>
              <div className="row">
                <div className="col-xs-12">
                  <p className="m-movie-details--overview">
                    {this.props.movie.overview}
                  </p>
                </div>
              </div>
              <div className="row m-movie-details--ratings">
                <Ratings imdbId={this.props.movie.imdb_id} />
              </div>
              <div className="row">
                <div className="col-xs-12 col-sm-6 col-sm-offset-3">
                  <a href={this.props.movie.trailer} className="btn btn-block btn-lg btn-success m-movie-details--trailer">
                    Watch the trailer
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-6">
              <h4>Torrents</h4>
              <Torrents imdbId={this.props.movie.imdb_id} />
            </div>
            <div className="col-sm-6">
              <h4>Subtitles</h4>
              <Subtitles imdbId={this.props.movie.imdb_id} />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default MovieDetail
