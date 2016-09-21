defmodule Magnetissimo.Repo.Migrations.CreateTorrent do
  use Ecto.Migration

  def change do
    create table(:torrents) do
      add :infohash, :text
      add :name, :text
      add :magnet, :text
      add :leechers, :integer
      add :seeders, :integer
      add :source, :text
      add :crawled_at, :datetime

      timestamps()
    end

  end
end
