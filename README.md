# synergy2k-community / gamedata

Community-maintained **game data** for [Synergy2K](https://github.com/odie-software),
served as plain, forkable JSON. Synergy2K (the app) ships no game data itself — the
client fetches a manifest from a configured **source** (this repo is the default) and
loads each version's schema + rosters on demand, caching them client-side.

## Layout

```
manifest.json              index of versions → file paths + sha256 content hashes
<version>/schema.json      the version's mechanics + display labels (one document)
<version>/rosters/*.json   roster players (names, attributes, badges)
```

Currently published versions:

| Key    | Name     | Attributes | Badges | Roster (players) |
|--------|----------|-----------:|-------:|-----------------:|
| `2k22` | NBA 2K22 | 35         | 75     | Launch Roster (556) |
| `2k26` | NBA 2K26 | 35         | 40     | Current Roster (534) — **WIP** |

## How the app consumes it

The client resolves every `path` in `manifest.json` relative to the manifest URL, and
caches schema/roster files **immutably by their `sha256-…` content hash** — so a hash
only changes when content changes. The default source is delivered via jsDelivr:

```
https://cdn.jsdelivr.net/gh/synergy2k-community/gamedata@main/manifest.json
```

Pin `@main` to a tag/commit (e.g. `@v1`) for immutable, hard-cacheable URLs at release.
A "custom version" is just a fork of this repo pointed at by a custom source.

### Hashes

`manifest.json` hashes are computed over the **canonical** form of each JSON document
(sorted keys, no whitespace) — not the pretty-printed file bytes. When you edit a
schema or roster, regenerate the manifest so its hashes match, or the client's cache
will not see the change.

## Schema shape

`schema.json` is a single per-version document: attribute + badge catalogs (mechanics
*and* display names), the badge-tier ladder, archetypes, starting-by-height tables,
positions, limits, and optional per-version overrides for the Synergy rating tuning,
the XP upgrade table, and season-award XP. Anything omitted falls back to the app's
defaults. See the app's `web/src/gamedata/models` for the typed shape.

## Provenance & affiliation

Not affiliated with, endorsed by, or sponsored by the NBA or 2K/Take-Two. Player,
team, and badge names are referenced for interoperability with users' own games;
ratings and attributes are community estimates. This repo is community-maintained and
forkable — contributions and corrections welcome.
