class Torrent extends React.Component {
  render() {
    return (
      <div>
        <div className="row">
          <div className="col-xs-6">
            {this.props.movie.language}
          </div>
          <div className="col-xs-6 text-right">
            rating {this.props.movie.rating}
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12">
            <div className="list-group">
              {this.props.movie.torrents.map(function(torrent) {
                return (
                  <a href={torrent.url} className="list-group-item">
                    <span className="badge badge-danger" title="Peers">
                      {torrent.peers}
                    </span>
                    <span className="badge badge-success" title="Seeds">
                      {torrent.seeds}
                    </span>
                    {torrent.quality} - {torrent.size}
                  </a>
                )
              })}
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default Torrent
