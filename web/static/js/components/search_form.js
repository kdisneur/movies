class SearchForm extends React.Component {
  handleSearch(event) {
    this.props.onSearch(React.findDOMNode(this.refs.query).value);
  }

  render() {
    return (
      <div className="row m-search-form">
        <div className="col-sm-12 col-md-6 col-md-offset-3">
          <div className="input-group form-search">
            <input type="text" ref="query" className="form-control search-query" placeholder={this.props.placeholder} />
            <span className="input-group-btn">
              <button type="submit" className="btn btn-primary" data-type="last" onClick={this.handleSearch.bind(this)}>
                Search
              </button>
            </span>
          </div>
        </div>
      </div>
    )
  }
}

export default SearchForm
