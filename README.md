# Magnetissimo

Web application that indexes all popular torrent sites, and saves it to the local database.

![alt tag](http://i.imgur.com/meqeZrc.png)

Goals:

* Crawl multiple index sites for torrents and magnet links.
* Run without ceremony. No pointless configuration needed.
* High performance, leveraging Elixir's GenServer and Erlang's BEAM VM.
* Unit tested for correctness.

## Community

Want to talk about Magnetissimo or suggest features? We have an official subreddit!

[http://reddit.com/r/magnetissimo](http://reddit.com/r/magnetissimo)

## Parser List

Magnetissimo currently fetches torrents from the following sites:

- [x] EZTV (thanks to @agustif)
- [x] Demonoid
- [x] Isohunt
- [x] LimeTorrents
- [x] ThePirateBay
- [x] TorrentDownloads
- [x] 1337x
- [ ] https://torrentproject.se
- [ ] https://rarbg.to/torrents.php
- [ ] https://www.torlock.com/
- [ ] http://www.seedpeer.eu/
- [ ] http://sectorrent.com/
- [ ] http://www.torrenthound.com/
- [ ] http://piratepublic.com
- [ ] bitsnoop.com
- [ ] extratorrent.cc
- [ ] linuxtracker.org
- [ ] monova.org
- [ ] newtorrents.info
- [ ] torrentbit.net
- [ ] torrentfunk.com
- [ ] torrentreactor.com
- [ ] torrents.net
- [ ] yourbittorrent.com

## Usage Guide

Please check the Wiki pages for instructions on how to run Magnetissimo.

* [Running it locally](https://github.com/sergiotapia/magnetissimo/wiki/Usage:-Local)
* [Running it on Heroku](https://github.com/sergiotapia/magnetissimo/wiki/Usage:-Heroku)
* Running it on a VPS (to-do)

## Available endpoints

### GET / Search page

This endpoint serves an HTML page that supports searching through available torrents that have been fetched from torrent websites.

### GET /summary

This endpoint shows a summary of the data in the database, essentially, a tally of how many torrents exist in the DB per torrent website.

### GET /exqui

This endpoint is served by the ExqUI library (similar to Sidekiq's Web UI), shows currently running Exq workers, enqueued and canceled.
Requires that ```mix exq.ui``` is running.



[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
