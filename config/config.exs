import Config

config :nostrum,
  token: System.get_env("SCREECHBOT_TOKEN"),
  num_shards: :auto
