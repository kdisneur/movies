let ErrorMessage    = require("web/static/js/owned-movies/components/error_message")
let Loader          = require("web/static/js/owned-movies/components/loader")
let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin
let Torrent         = require("web/static/js/owned-movies/components/torrent")

let Torrents = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("TorrentStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("TorrentStore").getState()
  },

  componentDidMount: function() {
    this.getFlux().actions.loadTorrents(this.props.imdbId);
  },

  render: function() {
    return (
      <div>
        {this.state.error ? <ErrorMessage message={this.state.error} /> : null}
        {this.state.loading ? <Loader /> : null}
        {this.state.torrents.map(function(movie) { return <Torrent movie={movie} />})}
      </div>
    )
  }
})

export default Torrents
