defmodule Magnetissimo.Repo.Migrations.AddIndexToTorrentCrawledAt do
  use Ecto.Migration

  def change do
    create index(:torrents, [:crawled_at])
  end
end
