class Rating extends React.Component {
  handleRate(event) {
    let rating = $(event.target).data("number")
    if ($(event.target).offset().left + ($(event.target).width() / 2) > event.pageX) {
      rating -= 1
    }

    this.props.onRate({ rating: rating, username: this.props.rating.username })
  }

  generateStarClassName(number) {
    if (number <= this.props.rating.rating) {
      return "fa fa-star"
    } else if (number - 1 == this.props.rating.rating) {
      return "fa fa-star-half-empty"
    } else {
      return "fa fa-star-o"
    }
  }

  render() {
    let component = this
    let stars     = [2, 4, 6, 8, 10].map(function(value) { return <i data-number={value} className={component.generateStarClassName(value)} onClick={component.handleRate.bind(component)} /> })
    return (
      <div className="col-sm-12 col-md-6">
        <div className="row">
          <div className="col-xs-6">
            {this.props.rating.name || this.props.rating.username}
          </div>
          <div className="col-xs-6">
            {stars}
          </div>
        </div>
      </div>
    )
  }
}

export default Rating
