use Mix.Config

if Mix.env == :test do
  config :what3words, client: What3Words.TestClient
end
