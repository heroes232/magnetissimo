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

  def with_infohash(hash) do
    from t in Magnetissimo.Torrent,
    where: t.infohash == ^hash
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

  def save_torrent(%{filesize: "error"}=torrent), do: Logger.warn "Ignoring torrent:#{inspect torrent}"

  def save_torrent(%{magnet: ""}=torrent), do: Logger.warn "Ignoring torrent:#{inspect torrent}"

  def save_torrent(%{magnet: nil}=torrent), do: Logger.warn "Ignoring torrent:#{inspect torrent}"

  def save_torrent(torrent) do
    magnet_position = :binary.match torrent.magnet, "magnet:?xt=urn:btih:"
    infohash = String.slice(torrent.magnet, magnet_position |> elem(1), 40)

    Repo.transaction fn ->
      case Magnetissimo.Repo.all(Magnetissimo.Torrent.with_infohash(infohash)) do
        [] ->
          changeset = Torrent.changeset(%Torrent{infohash: infohash}, torrent)
          if changeset.valid?() do
            case Repo.insert(changeset) do
              {:ok, torrent} ->
                Logger.info "★★★ - Torrent saved to database: #{inspect torrent}"
              {:error, reason} ->
                Logger.warn "Failed to save to database: reason:#{inspect reason.errors}"
              other ->
                Logger.error "Failed to save to database: other:#{inspect other}"
            end
          else
            Logger.warn "Invalid changeset: #{inspect changeset}"
          end
        [torr] ->
          update_existing(torr, torrent.source)
        other ->
          Logger.error "Couldn't save: #{inspect other} "
      end
    end

  end

  def update_existing(torr, old_source) do
    splitted = String.split(old_source, ",")
    sources = [torr.source|splitted] |> Enum.uniq() |> Enum.sort()
    source = Enum.join(sources, ",")
    Logger.warn "update_existing #{inspect torr} #{torr.source} #{old_source} #{source}"

    changeset = Ecto.Changeset.change(torr, updated_at: Ecto.DateTime.utc, source: source)
    Logger.debug "Updated update #{inspect Magnetissimo.Repo.update(changeset)} "
  end


end
