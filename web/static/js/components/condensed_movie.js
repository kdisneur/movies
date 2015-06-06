let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin

let CondensedMovie = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("WishStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("WishStore").getState(this.props.movie.imdb_id)
  },

  handleAddToWishList: function(event) {
    this.getFlux().actions.wishMovie(this.props.movie.imdb_id)
  },

  renderWishButton: function() {
    if (this.state.movie == "loading") {
      return <a className="btn btn-success btn-block loading">Adding to Wish list...</a>
    } else if (this.state.movie == "added") {
      return <a className="btn btn-success btn-block added">Added to Wish list!</a>
    } else {
      return <a className="btn btn-success btn-block" onClick={this.handleAddToWishList}>Add to Wish list</a>
    }
  },

  render: function() {
    return (
      <div className="col-md-3 col-sm-6">
        <div className="m-movie is-condensed">
          <img className="m-movie--poster img-rounded" src={this.props.movie.poster.medium} />
          <div className="m-movie-basic-informations">
            <a className="btn btn-default btn-block" href={"http://www.imdb.com/title/" + this.props.movie.imdb_id} target="_blank">
              See on IMDB
            </a>
            {this.renderWishButton()}
          </div>
        </div>
      </div>
    )
  }
})

export default CondensedMovie
