defmodule KerbalMaps.Repo.Migrations.AddPlanetPackJNSQ do
  use Ecto.Migration

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData.{CelestialBody,PlanetPack}

  def up do
    pp_jnsq =
      Repo.insert!(
        %PlanetPack{name: "JNSQ"}
        |> PlanetPack.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Moho", planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    eve_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Eve", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Gilly", parent_id: eve_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    kerbin_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Kerbin", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Mun", parent_id: kerbin_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Minmus", parent_id: kerbin_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    duna_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Duna", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Ike", parent_id: duna_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    edna_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Edna", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Dak", parent_id: edna_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Dres", planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    jool_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Jool", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Laythe", parent_id: jool_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Vall", parent_id: jool_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Tylo", parent_id: jool_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Bop", parent_id: jool_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Pol", parent_id: jool_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    lindor_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Lindor", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Krel", parent_id: lindor_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Aden", parent_id: lindor_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Riga", parent_id: lindor_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Talos", parent_id: lindor_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    eeloo_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Eeloo", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Celes", parent_id: eeloo_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Tam", parent_id: eeloo_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Hamek", planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    nara_jnsq =
      Repo.insert!(
        %CelestialBody{name: "Nara", planet_pack_id: pp_jnsq.id}
        |> CelestialBody.changeset(%{})
        |> Changeset.apply_changes()
      )

    Repo.insert!(
      %CelestialBody{name: "Amos", parent_id: nara_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Enon", parent_id: nara_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

    Repo.insert!(
      %CelestialBody{name: "Prax", parent_id: nara_jnsq.id, planet_pack_id: pp_jnsq.id}
      |> CelestialBody.changeset(%{})
      |> Changeset.apply_changes()
    )

  end

  def down do
    pp_jnsq =
      PlanetPack
      |> where(fragment("name = 'JNSQ'"))
      |> Repo.one!()

    CelestialBody
    |> where(fragment("planet_pack_id = ?", ^pp_jnsq.id))
    |> Repo.delete_all()

    PlanetPack
    |> where(fragment("name = 'JNSQ'"))
    |> Repo.delete_all()
  end
end
