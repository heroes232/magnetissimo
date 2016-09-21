defmodule Magnetissimo.DownloadWorker do
  alias Magnetissimo.Torrent

  def download(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Error: #{url} is 404."
        nil
      {:error, %HTTPoison.Error{reason: _}} ->
        IO.puts "Error: #{url} just ain't workin."
        nil
    end
  end

  # EZTV workers.
  def perform(url, "eztv", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.EZTV.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "eztv", "Magnetissimo.DownloadWorker", [url, "eztv", "paginated_links"])
    end)
  end

  def perform(url, "eztv", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.EZTV.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "eztv", "Magnetissimo.DownloadWorker", [url, "eztv", "torrent_links"])
    end)
  end

  def perform(url, "eztv", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.EZTV.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # Leetx workers.
  def perform(url, "leetx", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.Leetx.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "leetx", "Magnetissimo.DownloadWorker", [url, "leetx", "paginated_links"])
    end)
  end

  def perform(url, "leetx", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.Leetx.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "leetx", "Magnetissimo.DownloadWorker", [url, "leetx", "torrent_links"])
    end)
  end

  def perform(url, "leetx", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.Leetx.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # ThePirateBay workers.
  def perform(url, "thepiratebay", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.ThePirateBay.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "thepiratebay", "Magnetissimo.DownloadWorker", [url, "thepiratebay", "paginated_links"])
    end)
  end

  def perform(url, "thepiratebay", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.ThePirateBay.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "thepiratebay", "Magnetissimo.DownloadWorker", [url, "thepiratebay", "torrent_links"])
    end)
  end

  def perform(url, "thepiratebay", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.ThePirateBay.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # Demonoid workers.
  def perform(url, "demonoid", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.Demonoid.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "demonoid", "Magnetissimo.DownloadWorker", [url, "demonoid", "paginated_links"])
    end)
  end

  def perform(url, "demonoid", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.Demonoid.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "demonoid", "Magnetissimo.DownloadWorker", [url, "demonoid", "torrent_links"])
    end)
  end

  def perform(url, "demonoid", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.Demonoid.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # Isohunt workers.
  def perform(url, "isohunt", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.Isohunt.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "isohunt", "Magnetissimo.DownloadWorker", [url, "isohunt", "paginated_links"])
    end)
  end

  def perform(url, "isohunt", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.Isohunt.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "isohunt", "Magnetissimo.DownloadWorker", [url, "isohunt", "torrent_links"])
    end)
  end

  def perform(url, "isohunt", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.Isohunt.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # Limetorrents workers.
  def perform(url, "limetorrents", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.Limetorrents.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "limetorrents", "Magnetissimo.DownloadWorker", [url, "limetorrents", "paginated_links"])
    end)
  end

  def perform(url, "limetorrents", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.Limetorrents.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "limetorrents", "Magnetissimo.DownloadWorker", [url, "limetorrents", "torrent_links"])
    end)
  end

  def perform(url, "limetorrents", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.Limetorrents.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end

  # Torrentdownload workers.
  def perform(url, "torrentdownloads", "root_url") do
    IO.puts "Crawling: #{url}"
    pages = Magnetissimo.Parsers.TorrentDownloads.paginated_links(download(url))
    pages 
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "torrentdownloads", "Magnetissimo.DownloadWorker", [url, "torrentdownloads", "paginated_links"])
    end)
  end

  def perform(url, "torrentdownloads", "paginated_links") do
    IO.puts "Crawling: #{url}"
    torrent_links = Magnetissimo.Parsers.TorrentDownloads.torrent_links(download(url))
    torrent_links
    |> Enum.each(fn url ->
      Exq.enqueue(Exq, "torrentdownloads", "Magnetissimo.DownloadWorker", [url, "torrentdownloads", "torrent_links"])
    end)
  end

  def perform(url, "torrentdownloads", "torrent_links") do
    IO.puts "Crawling: #{url}"
    torrent = Magnetissimo.Parsers.TorrentDownloads.scrape_torrent_information(download(url))
    Torrent.save_torrent(torrent)
  end
end