class Server {
  loadOwnedMovies(apiKey, success, failure) {
    $.ajax("/api/movies/owned", {
      dataType: "json",
      error: function(_jqXHR, _textStatus, errorThrown) { failure(errorThrown); },
      headers: { "api-key": apiKey },
      method: "GET",
      success: function(data, _textStatus, _jqXHR) { success(data) }
    })
  }

  loadTorrents(imdbId, success, failure) {
    let $element = $(".owned-movies-app-js");
    $.ajax(`/api/movies/torrent/${imdbId}`, {
      dataType: "json",
      error: function(_jqXHR, _textStatus, errorThrown) { failure(errorThrown); },
      headers: { "api-key": $element.data("api-key") },
      method: "GET",
      success: function(data, _textStatus, _jqXHR) { success(data) }
    })
  }

  loadSubtitles(imdbId, success, failure) {
    let $element = $(".owned-movies-app-js");
    $.ajax(`/api/movies/subtitle/${imdbId}`, {
      dataType: "json",
      error: function(_jqXHR, _textStatus, errorThrown) { failure(errorThrown); },
      headers: { "api-key": $element.data("api-key") },
      method: "GET",
      success: function(data, _textStatus, _jqXHR) { success(data) }
    })
  }
}

export default Server
