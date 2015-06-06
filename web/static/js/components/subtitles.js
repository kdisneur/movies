let ErrorMessage    = require("web/static/js/components/error_message")
let Loader          = require("web/static/js/components/loader")
let FluxMixin       = Fluxxor.FluxMixin(React)
let StoreWatchMixin = Fluxxor.StoreWatchMixin
let Subtitle        = require("web/static/js/components/subtitle")

let Subtitles = React.createClass({
  mixins: [FluxMixin, StoreWatchMixin("SubtitleStore")],

  getStateFromFlux: function() {
    return this.getFlux().store("SubtitleStore").getState()
  },

  componentDidMount: function() {
    this.getFlux().actions.loadSubtitles(this.props.imdbId);
  },

  render: function() {
    return (
      <div>
        {this.state.error ? <ErrorMessage message={this.state.error} /> : null}
        {this.state.loading ? <Loader /> : null}
        <div className="list-group">
          {this.state.subtitles.map(function(subtitle) { return <Subtitle key={subtitle.id} subtitle={subtitle} />})}
        </div>
      </div>
    )
  }
})

export default Subtitles
