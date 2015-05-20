let Movie = require("web/static/js/owned-movies/components/movie")

class MovieLine extends React.Component {
  render() {
    return (
      <div className="row">
        {this.props.movies.map(function(movie) { return <Movie movie={movie} /> })}
      </div>
    )
  }
}

export default MovieLine
