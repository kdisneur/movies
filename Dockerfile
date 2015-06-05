FROM nifty/elixir

RUN mkdir /app
WORKDIR /app

ADD . /app

RUN yes | mix deps.get
RUN mix local.rebar
RUN mix deps.compile

EXPOSE 4000

CMD ["mix", "phoenix.server"]
