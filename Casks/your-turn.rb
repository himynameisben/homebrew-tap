cask "your-turn" do
  version "0.2.0"
  sha256 "c819c0710492f0709a5fd383ceb7f92474093a55201db5db161f8ab9be89f0e3"

  url "https://github.com/himynameisben/your-turn/releases/download/v#{version}/YourTurn-#{version}.zip"
  name "Your Turn"
  desc "Menu bar inbox for Claude Code sessions"
  homepage "https://github.com/himynameisben/your-turn"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "YourTurn.app"

  # LSUIElement: there is no Dock icon and often no window, so an upgrade would
  # otherwise leave the old build running in the menu bar with the new one on disk.
  uninstall quit: "tw.lychee.yourturn"

  zap trash: [
    "~/Library/Application Support/YourTurn",
    "~/Library/Caches/tw.lychee.yourturn",
    "~/Library/HTTPStorages/tw.lychee.yourturn",
    "~/Library/Preferences/tw.lychee.yourturn.plist",
  ]

  caveats <<~EOS
    Your Turn has no Dock icon — after launching it, look for the icon in the menu bar.

    "Start at login" is registered with macOS itself (SMAppService), so uninstalling
    does not remove it. Switch it off in Your Turn's settings before uninstalling, or
    clear the leftover entry in System Settings › General › Login Items.
  EOS
end
