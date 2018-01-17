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
  place_id: "ChIJp607bnR8OIgRPt44VnN-9LQ",
  days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
  info: "Free drink with pizza purchase",
  reoccuring: true 
  })