let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin

let MarkAsOwnedButton = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("OwnStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("OwnStore").getState(this.props.imdbId)
  },

  handleAddToOwned: function(event) {
    this.getFlux().actions.ownMovie(this.props.imdbId)
  },

  render: function() {
    if (this.state.movie == "loading") {
      return <a className="btn btn-block btn-lg btn-success loading">Marking as owned...</a>
    } else if (this.state.movie == "added") {
      return <a className="btn btn-block btn-lg btn-success added">Marked as owned!</a>
    } else {
      return <a className="btn btn-block btn-lg btn-success" onClick={this.handleAddToOwned}>Mark as owned</a>
    }
  }
})

export default MarkAsOwnedButton
