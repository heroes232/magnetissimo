defmodule Magnetissimo.Parsers.Demonoid do
  @behaviour Magnetissimo.Parser

  def root_urls do
    [
      "https://www.dnoid.me/files"
    ]
  end

  def paginated_links(_) do
    1..200
    |> Enum.map(fn i -> "http://www.demonoid.pw/files/?to=0&uid=0&category=0&subcategory=0&language=0&seeded=2&quality=0&external=2&query=&sort=&page=#{i}" end)
  end

  def torrent_links(html_body) do
    html_body
    |> Floki.find("td.tone_1_pad a")
    |> Floki.attribute("href")
    |> Enum.filter(fn(a) -> String.contains?(a, "/files/details/") end)
    |> Enum.map(fn(url) -> "http://www.demonoid.pw" <> url end)
  end

  def scrape_torrent_information(html_body) do
    name = html_body
      |> Floki.find("td.ctable_header")
      |> Floki.text
      |> String.replace("Details for ", "")
      |> String.replace("Download this torrentExtra informationCommentsDMCA", "")
      |> String.trim
      |> HtmlEntities.decode

    description = html_body
      |> Floki.find("span.adbriteinline")
      |> Floki.text

    magnet = html_body
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(fn(a) -> String.starts_with?(a, "magnet:") end)
      |> Enum.at(0)

    size = html_body
      |> Floki.find("td")
      |> Enum.filter(fn(a) ->
        size_container = Floki.attribute(a, "width") |> Enum.at(0)
        size_container == "50%"
      end)
      |> Enum.at(0)
      |> Floki.text
      |> String.replace("Size: ", "")
      |> String.trim
      |> String.split

    size_value = Enum.at(size, 0)
    unit = Enum.at(size, 1)
    size = Magnetissimo.SizeConverter.size_to_bytes(size_value, unit) |> Kernel.to_string

    categories = html_body
      |> Floki.find(".ctable_content_no_pad > table > tr")
      |> Enum.at(1)
      |> Floki.find("td > b")
      # |> Enum.at(0)
      # |> Floki.find("#fslispc > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > table > tbody > tr:nth-child(2) > td > b:nth-child(1)")
      # |> IO.inspect

    category = categories |> Enum.at(0, "") |> Floki.text
    subcategory = categories |> Enum.at(1, "") |> Floki.text

    %{
      name: name,
      description: description,
      magnet: magnet,
      filesize: size,
      source: "Demonoid",
      seeders: 0,
      leechers: 0,
      category: category,
      subcategory: subcategory
    }
  end
end
