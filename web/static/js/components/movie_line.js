let CondensedMovie = require("web/static/js/components/condensed_movie")
let Movie          = require("web/static/js/components/movie")

class MovieLine extends React.Component {
  displayMovie(movie) {
    if (this.props.type == "condensed") {
      return <CondensedMovie key={movie.imdb_id} movie={movie} />
    } else {
      return <Movie key={movie.imdb_id} movie={movie} />
    }
  }

  render() {
    let component = this

    return (
      <div className="row">
        {this.props.movies.map(function(movie) { return component.displayMovie(movie) })}
      </div>
    )
  }
}

export default MovieLine
