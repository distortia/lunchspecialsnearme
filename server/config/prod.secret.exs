use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :lsnm, LsnmWeb.Endpoint,
  secret_key_base: "64gYMLZSY6LPfSqYbmLOMWxS1rIeYtt3v7H44qABN9mpjMh2Kyo5kBVz/oRBgGMh"

# Configure your database
config :lsnm, Lsnm.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  database: "lsnm_prod",
  pool_size: 15
