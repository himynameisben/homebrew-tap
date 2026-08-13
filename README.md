# himynameisben/homebrew-tap

Homebrew casks for my macOS apps.

| Cask | What it is |
|---|---|
| `your-turn` | [Your Turn](https://github.com/himynameisben/your-turn) — a menu bar inbox for Claude Code sessions |

## Install

```bash
brew install --cask himynameisben/tap/your-turn
```

That taps this repository and installs in one step. Afterwards:

```bash
brew upgrade --cask your-turn      # follows new releases
brew uninstall --cask your-turn    # removes the app
brew uninstall --cask --zap your-turn   # …and its preferences, archive list and usage cache
```

`--zap` cannot remove the "start at login" registration — that one lives with macOS
(`SMAppService`), not with Homebrew. Switch it off in the app before uninstalling, or
clear it in System Settings › General › Login Items.

## Cutting a new version

The cask holds no binaries; it points at a GitHub release asset and pins its checksum.
So a new version is two lines, and `Scripts/bump.sh` writes both of them — it downloads
the published zip and hashes what it actually got, which is the only way the checksum
can be trusted:

```bash
Scripts/bump.sh 0.3.0
brew audit --cask --online --new Casks/your-turn.rb
git commit -am "your-turn 0.3.0" && git push
```

Run it **after** the GitHub release is published — `curl` fails loudly on a missing tag,
which is the intended guard.

Never re-upload an asset under an existing tag: the URL stays the same while the
checksum changes, and every user mid-download gets a mismatch instead of an app.
