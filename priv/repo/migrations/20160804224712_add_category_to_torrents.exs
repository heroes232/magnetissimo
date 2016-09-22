defmodule Magnetissimo.Repo.Migrations.AddCategorytToTorrents do
  use Ecto.Migration

  def change do
    alter table(:torrents) do
      add :category, :text
      add :subcategory, :text
    end
  end
end
