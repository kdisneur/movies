let ErrorMessage    = require("web/static/js/components/error_message")
let Loader          = require("web/static/js/components/loader")
let FluxMixin       = Fluxxor.FluxMixin(React)
let Rating          = require("web/static/js/components/rating")
let StoreWatchMixin = Fluxxor.StoreWatchMixin

let Ratings = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("RatingStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("RatingStore").getState()
  },

  componentDidMount: function() {
    this.getFlux().actions.loadRatings(this.props.imdbId);
  },

  handleRate(rating) {
    this.getFlux().actions.submitRating(this.props.imdbId, rating)
  },

  render: function() {
    let component = this

    return (
      <div>
        {this.state.error ? <ErrorMessage message={this.state.error} /> : null}
        {this.state.loading ? <Loader /> : null}
        {this.state.ratings.map(function(rating) { return <Rating key={rating.id} rating={rating} onRate={component.handleRate} />})}
      </div>
    )
  }
})

export default Ratings
