class Loader extends React.Component {
  render() {
    return (
      <div>
        <div className="sk-spinner sk-spinner-wave">
          <div className="sk-rect1"></div>
          <div className="sk-rect2"></div>
          <div className="sk-rect3"></div>
          <div className="sk-rect4"></div>
          <div className="sk-rect5"></div>
        </div>
        <div className="text-center sk-spinner-text">Loading...</div>
      </div>
    )
  }
}

export default Loader
