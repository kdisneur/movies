defmodule YIFY.MoviesTest do
  use ExUnit.Case, async: false

  import Mock

  test "find a movie when imdb id exists" do
    with_mock HTTPoison, [get!: fn("https://yts.to/api/v2/list_movies.json?query_term=tt0133093") -> ~s({"status":"ok","status_message":"Query was successful","data":{"movie_count":1,"limit":20,"page_number":1,"movies":[{"id":206,"url":"https://yts.to/movie/the-matrix-1999","imdb_code":"tt0133093","title":"The Matrix","title_long":"The Matrix (1999\)","slug":"the-matrix-1999","year":1999,"rating":8.7,"runtime":136,"genres":["Action","Sci-Fi"],"language":"English","mpa_rating":"R","small_cover_image":"https://s.ynet.io/assets/images/movies/The_Matrix_1999/small-cover.jpg","medium_cover_image":"https://s.ynet.io/assets/images/movies/The_Matrix_1999/medium-cover.jpg","state":"ok","torrents":[{"url":"https://yts.to/torrent/download/363BC6C534B1430C6758318D196CCD61DB61B647.torrent","hash":"363BC6C534B1430C6758318D196CCD61DB61B647","quality":"720p","seeds":558,"peers":65,"size":"703.69 MB","size_bytes":737872445,"date_uploaded":"2011-09-11 01:57:02","date_uploaded_unix":1315663022},{"url":"https://yts.to/torrent/download/D7A46713EAEE18C746B3254B7D1492A50FD9D6CE.torrent","hash":"D7A46713EAEE18C746B3254B7D1492A50FD9D6CE","quality":"1080p","seeds":203,"peers":77,"size":"1.86 GB","size_bytes":1997159793,"date_uploaded":"2012-06-13 11:32:20","date_uploaded_unix":1339543940}],"date_uploaded":"2011-09-11 01:57:02","date_uploaded_unix":1315663022}]},"@meta":{"server_time":1430851676,"server_timezone":"Pacific\/Auckland","api_version":2,"execution_time":"23.8 ms"}}) end] do
       [%{ "title" => "The Matrix" }] = YIFY.Movies.find_by_imdb_id("tt0133093")
    end
  end

  test "find a movie when imdb id does not exist" do
    with_mock HTTPoison, [get!: fn("https://yts.to/api/v2/list_movies.json?query_term=tt0000000") -> ~s({"status":"ok","status_message":"Query was successful","data":{"movie_count":0,"limit":20,"page_number":1,"movies":[]},"@meta":{"server_time":1430854709,"server_timezone":"Pacific/Auckland","api_version":2,"execution_time":"15.96 ms"}}) end] do
      assert YIFY.Movies.find_by_imdb_id("tt0000000") == []
    end
  end
end
