let flux = require("web/static/js/flux")
require("web/static/js/new-member-form")

if ($(".owned-movies-app-js").length > 0) {
  let $element = $(".owned-movies-app-js");
  let App = require("web/static/js/owned-movies-app")

  React.render(<App flux={flux} />, $element[0]);
}

if ($(".search-movies-app-js").length > 0) {
  let $element = $(".search-movies-app-js");
  let App = require("web/static/js/search-movies-app")

  React.render(<App flux={flux} />, $element[0]);
}

let App = {
}

export default App
