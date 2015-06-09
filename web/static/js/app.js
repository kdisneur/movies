let flux = require("web/static/js/flux")

if ($('.new-member-form-js').length > 0) {
  let $member = $('.new-member-form-js');
  let NewMemberForm = require("web/static/js/new-member-form")
  React.render(<NewMemberForm csrf_token={$("meta[name=csrf-token]").attr("value")} opened={$member.data('opened')} username={$member.data('username')} />, $member[0]);
}

if ($('.new-language-form-js').length > 0) {
  let $member = $('.new-language-form-js');
  let NewLanguageForm = require("web/static/js/new-language-form")
  React.render(<NewLanguageForm csrf_token={$("meta[name=csrf-token]").attr("value")} opened={$member.data('opened')} language={$member.data('language')} />, $member[0]);
}

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

if ($(".wished-movies-app-js").length > 0) {
  let $element = $(".wished-movies-app-js");
  let App = require("web/static/js/wished-movies-app")

  React.render(<App flux={flux} />, $element[0]);
}

let App = {
}

export default App
