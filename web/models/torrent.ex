defmodule Magnetissimo.Torrent do
  use Magnetissimo.Web, :model
  alias Magnetissimo.Repo
  alias Magnetissimo.Torrent

  require Logger

  schema "torrents" do
    field :infohash, :string
    field :name, :string
    field :magnet, :string
    field :leechers, :integer
    field :seeders, :integer
    field :source, :string
    field :filesize, :string
    field :crawled_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:infohash, :name, :magnet, :leechers, :seeders, :source, :filesize])
    |> validate_required([:infohash, :name, :magnet, :source])
#    |> unique_constraint(:infohash)
  end

  def order_by_name(query) do
    from p in query,
    order_by: [asc: p.name]
  end

  def order_by_inserted_at(query) do
    from p in query,
    order_by: [desc: p.inserted_at]
  end

  def order_by_leechers(query) do
    from p in query,
    order_by: [desc: p.leechers]
  end

  def order_by_seeders(query) do
    from p in query,
    order_by: [desc: p.seeders]
  end

  def save_torrent(torrent) do
    Logger.info "Got new torrent!!!! #{torrent.magnet}"
    magnet_decoded = Magnet.decode(torrent.magnet) |> Enum.into(%Magnet{})
    infohash = magnet_decoded.info_hash
    Logger.info "MAGNET DECODE #{infohash}"

    changeset = Torrent.changeset(%Torrent{}, torrent)
    case Repo.insert(changeset) do
      {:ok, _torrent} ->
        Logger.info "★★★ - Torrent saved to database: #{torrent.name}"

      {:error, changeset} ->
        Logger.error "Couldn't save: #{torrent.name}"
        IO.inspect changeset.errors
    end
  end
end
