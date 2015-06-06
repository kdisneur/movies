class ErrorMessage extends React.Component {
  render() {
    return (
      <div className="alert alert-danger">
        <button type="button" className="close" data-dismiss="alert" aria-hidden="true">×</button>
        <strong>Outch!</strong> {this.props.message}
      </div>
    )
  }
}

export default ErrorMessage
