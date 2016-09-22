defmodule Magnetissimo.Repo.Migrations.AddCrawledAtToTorrents do
  use Ecto.Migration

  def change do
    alter table(:torrents) do
      add :crawled_at, :datetime
    end
  end
end
