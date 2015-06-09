let NewOneValueForm = React.createClass({
  getInitialState: function() {
    return { opened: this.props.opened }
  },

  handleSubmit: function(event) {
    event.preventDefault()
    if (this.state.opened) {
      event.target.submit()
    }

    let component = this
    this.setState({ opened: true }, () => React.findDOMNode(component.refs.element).focus())
  },

  render: function() {
    let classes = classNames({
      "form-control": true,
      "hide":         !this.state.opened
    })

    return <form action={this.props.action} method="post" onSubmit={this.handleSubmit}>
      <input type="hidden" name="_csrf_token" value={this.props.csrf_token} />
      <div className="input-group">
        <input ref="element" name={this.props.elementName} type="text" placeholder={this.props.elementPlaceholder} className={classes} defaultValue={this.props.elementValue} />
        <div className="input-group-btn">
          <button className="btn btn-success">
            {this.props.actionButtonValue}
          </button>
        </div>
      </div>
    </form>
  }
})

export default NewOneValueForm
