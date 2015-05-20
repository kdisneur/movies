class Movie extends React.Component {
  constructor(props) {
    super(props)
    this.state = { opened: false }
  }

  handlePopupClosing(event) {
    event.stopPropagation();
    this.setState({ opened: false })
  }

  handlePopupOpening(event) {
    this.setState({ opened: true })
  }

  render() {
    let movieDetailsClass = classNames({
      "m-movie-details": true,
      "is-displayed":    this.state.opened
    })

    return (
      <div className="col-md-3 col-sm-6">
        <div className="m-movie" onClick={this.handlePopupOpening.bind(this)}>
          <img className="m-movie--poster img-rounded" src={this.props.movie.poster.medium} />
          <div className="m-movie-basic-informations">
            <div className="m-movie-basic-informations--runtime">
              {this.props.movie.runtime} min
            </div>
            <div className="m-movie-basic-informations--genres">
              {this.props.movie.genres.join(", ")}
            </div>
          </div>
          <div className={movieDetailsClass}>
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
                  <div className="row">
                    <div className="col-xs-12 col-sm-6 col-sm-offset-3">
                      <a href="{this.props.movie.trailer}" className="btn btn-block btn-lg btn-success m-movie-details--trailer">
                        Watch the trailer
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default Movie
