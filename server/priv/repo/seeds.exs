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



{:ok, user1} = Lsnm.Repo.insert(%Lsnm.Users.User{
  username: "somebody",
  email: "once@toldme.theworldisgona",
  password_hash: Comeonin.Bcrypt.hashpwsalt("rollme"),
  temp_id: nil,
  stats: %{specials_added: 1}
  })

{:ok, user2} = Lsnm.Repo.insert(%Lsnm.Users.User{
  username: "dummy",
  email: "dummy@user",
  password_hash: Comeonin.Bcrypt.hashpwsalt("test"),
  temp_id: nil,
  stats: %{specials_added: 5}
  })

Lsnm.Repo.insert(%Lsnm.Users.User{
  username: "mizou",
  email: "nickstalter@gmail.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("test"),
  temp_id: nil,
  stats: %{specials_added: 0}
  })

Lsnm.Repo.insert!(%Lsnm.Specials.Special{
  place_id: "ChIJp607bnR8OIgRPt44VnN-9LQ",
  day_of_week: "Monday",
  info: "Free drink with pizza purchase",
  name: "The Olive Branch Coffee & Pizzeria",
  user_id: user1.id
  })

Lsnm.Repo.insert!(%Lsnm.Specials.Special{
  place_id: "ChIJp607bnR8OIgRPt44VnN-9LQ",
  day_of_week: "Tuesday",
  info: "Free drink with pizza purchase",
  name: "The Olive Branch Coffee & Pizzeria",
  user_id: user2.id
  })