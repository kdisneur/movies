let CondensedMovie = React.createClass({
  render: function() {
    return (
      <div className="col-md-3 col-sm-6">
        <div className="m-movie is-condensed">
          <img className="m-movie--poster img-rounded" src={this.props.movie.poster.medium} />
          <div className="m-movie-basic-informations">
            <a className="btn btn-default btn-block" href={"http://www.imdb.com/title/" + this.props.movie.imdb_id} target="_blank">
              See on IMDB
            </a>
            <a className="btn btn-success btn-block" target="_blank">
              Add to Watch list
            </a>
          </div>
        </div>
      </div>
    )
  }
})

export default CondensedMovie
