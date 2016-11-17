defmodule Magnetissimo.Parsers.EZTV do
  @behaviour Magnetissimo.Parser

  def root_urls do
    [
      "https://eztv.ag/"
    ]
  end

  def paginated_links(_) do
    1..1500
    |> Enum.map(fn i -> "https://eztv.ag/page_#{i}" end)
  end

  def torrent_links(html_body) do
    html_body
    |> Floki.find("a.epinfo")
    |> Floki.attribute("href")
    |> Enum.filter(fn(a) -> String.contains?(a, "/ep/") end)
    |> Enum.map(fn(url) -> "https://eztv.ag" <> url end)
  end

  def scrape_torrent_information(html_body) do
    name = html_body
      |> Floki.find("td.section_post_header")
      |> Enum.at(0)
      |> Floki.text
      |> String.trim
      |> HtmlEntities.decode

    magnet = html_body
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(fn(url) -> String.starts_with?(url, "magnet:") end)
      |> Enum.at(0)

    size_value = html_body
      |> Floki.find("table")
      |> Enum.at(8)
      |> Floki.text
      |> String.split(" ")
      |> Enum.at(6)

    unit = html_body
      |> Floki.find("table")
      |> Enum.at(8, "")
      |> Floki.text
      |> String.split(" ")
      |> Enum.at(7, "")
      |> String.split("\n")
      |> Enum.at(0, "")

    {seeders, _} = html_body
      |> Floki.find(".stat_red")
      |> Enum.at(0)
      |> Floki.text
      |> String.trim
      |> Integer.parse

    {leechers, _} = html_body
      |> Floki.find(".stat_green")
      |> Enum.at(0)
      |> Floki.text
      |> String.trim
      |> Integer.parse

    size = Magnetissimo.SizeConverter.size_to_bytes(size_value, unit)
    case size do
      size_value when is_integer(size_value) ->
        create_torrent(size_value, magnet, seeders, leechers, name)
      _ -> nil
    end

  end

  defp create_torrent(size, magnet, seeders, leechers, name) do
    size_value = size |> Kernel.to_string

    {:ok, %{
      name: name,
      magnet: magnet,
      source: "EZTV",
      filesize: size_value,
      seeders: seeders,
      leechers: leechers,
      category: "TV Show"
    }}
  end
end
