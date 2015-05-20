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
}

export default Server
