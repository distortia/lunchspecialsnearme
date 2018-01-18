# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lsnm.Repo.insert!(%Lsnm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Lsnm.Repo.insert!(%Lsnm.Specials.Special{
  place_id: "ChIJFbswm717OIgRsFuHAFsC9r8",
  days_of_week: ["monday"],
  info: "Buy one get one nachos",
  reoccuring: true
  })

Lsnm.Repo.insert(%Lsnm.Users.User{
  username: "somebody",
  email: "once@toldme.theworldisgona",
  password_hash: Comeonin.Bcrypt.hashpwsalt("rollme")
  })
