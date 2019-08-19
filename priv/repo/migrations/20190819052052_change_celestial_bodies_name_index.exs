defmodule KerbalMaps.Repo.Migrations.ChangeCelestialBodiesNameIndex do
  use Ecto.Migration

  def up do
    drop_if_exists index("celestial_bodies", [:name])
    create index("celestial_bodies", [:name, :planet_pack_id], unique: true)
  end

  def down do
    drop_if_exists index("celestial_bodies", [:name, :planet_pack_id])
    create index("celestial_bodies", [:name], unique: true)
  end
end
