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
    field :category, :string
    field :subcategory, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:infohash, :name, :magnet, :leechers, :seeders, :source, :filesize, :category, :subcategory])
    |> validate_required([:infohash, :name, :magnet, :source])
    |> unique_constraint(:infohash)
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

  def save_torrent(%Torrent{magnet: "magnet:?xt=urn:btih:" <> _} = torrent) do
    Logger.info "Got new torrent!!!! #{torrent.source} #{torrent.magnet}"

    with {:ok, infohash} <- get_info_hash(torrent.magnet),
    changeset <- Torrent.changeset(%Torrent{infohash: String.downcase(infohash)}, torrent),
    do: process_save(Repo.insert(changeset))
  end

  def save_torrent(_), do: {:error, :invalid}

  def process_save({:ok, torrent}) do
    Logger.info "★★★ - Torrent saved to database: #{torrent.name}"
    :ok
  end

  def process_save({:error, changeset}) do
      Logger.error "Couldn't save: #{inspect changeset} reason:#{inspect changeset.errors}"
      :error
  end

  def get_info_hash("magnet:?xt" <> _ = magnet) do
    decoded = URI.decode_query(magnet)
    hash = Map.get(decoded, "magnet:?xt")
    "urn:btih:"<> infohash = hash["magnet:?xt"]
    {:ok, infohash}
  end

  def get_info_hash(_), do: {:error, :invalid}

end
