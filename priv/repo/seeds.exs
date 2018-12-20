# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KerbalMaps.Repo.insert!(%KerbalMaps.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias KerbalMaps.Repo
alias KerbalMaps.StaticData.CelestialBody
alias KerbalMaps.Symbols.Marker
alias KerbalMaps.Users.User

## StaticData

##   CelestialBody

Repo.insert!(%CelestialBody{name: "Moho"})
eve = Repo.insert!(%CelestialBody{name: "Eve"})
  Repo.insert!(%CelestialBody{name: "Gilly", parent_id: eve.id})
kerbin = Repo.insert!(%CelestialBody{name: "Kerbin"})
  Repo.insert!(%CelestialBody{name: "Mun", parent_id: kerbin.id})
  Repo.insert!(%CelestialBody{name: "Minmus", parent_id: kerbin.id})
duna = Repo.insert!(%CelestialBody{name: "Duna"})
  Repo.insert!(%CelestialBody{name: "Ike", parent_id: duna.id})
Repo.insert!(%CelestialBody{name: "Dres"})
jool = Repo.insert!(%CelestialBody{name: "Jool"})
  Repo.insert!(%CelestialBody{name: "Laythe", parent_id: jool.id})
  Repo.insert!(%CelestialBody{name: "Vall", parent_id: jool.id})
  Repo.insert!(%CelestialBody{name: "Tylo", parent_id: jool.id})
  Repo.insert!(%CelestialBody{name: "Bop", parent_id: jool.id})
  Repo.insert!(%CelestialBody{name: "Pol", parent_id: jool.id})
Repo.insert!(%CelestialBody{name: "Eeloo"})

## Users

##   User

me = Repo.insert!(%User{
  email: "craig@cottingham.net",
  password_hash: "$pbkdf2-sha512$100000$23m4rdSBgJ9GxRzyf/lX6g==$AcaQXaLgcubwmcbvHR0UfQIlv4SHDcVC6N/X9arZgftPACjBPqSbTFGMCrLYi8W1QZ7UHlQc7UlBk+xJrAIDQQ==",
  email_confirmation_token: "fdf5593d-b5f2-4c7a-93f7-4efd9ce3f233",
  email_confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
  unconfirmed_email: nil,
})

## Symbols

##   Marker

Repo.insert!(%Marker{
  name: "Hom",
  description: "The largest and oldest city on Kerbin.",
  latitude: 35.332031,
  longitude: -175.297852,
  altitude: nil,
  navigation_uuid: nil,
  icon_name: ~S({"prefix":"fa","name":"fa-city"}),
  user_id: me.id,
  celestial_body_id: kerbin.id,
})
Repo.insert!(%Marker{
  name: "KSC Monolith",
  description: "A monolith on the grounds of the Kerbal Space Center",
  latitude: 0.102329,
  longitude: -74.568421,
  altitude: nil,
  navigation_uuid: nil,
  icon_name: ~S({"prefix":"fa","name":"fa-question"}),
  user_id: me.id,
  celestial_body_id: kerbin.id,
})
Repo.insert!(%Marker{
  name: "The Great Desert",
  description: "Bring plenty of water.",
  latitude: 2.490249,
  longitude: -141.395865,
  altitude: nil,
  navigation_uuid: nil,
  icon_name: ~S({"prefix":"fa","name":"fa-info"}),
  user_id: me.id,
  celestial_body_id: kerbin.id,
})
