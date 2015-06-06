class Subtitle extends React.Component {
  render() {
    return (
      <a href={this.props.subtitle.url} className="list-group-item">
        <span className="badge badge-default" title="rating">
          {this.props.subtitle.rating}
        </span>
        {this.props.subtitle.name}
      </a>
    )
  }
}

export default Subtitle
