cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-08-06,2026.806.1"
  sha256 arm:   "7cdedaa2c8e17f687569fcf640a30d89e9cee27c026d0d4dc83f540a6621dbb2",
         intel: "be2c79db4c8734779a4c59bd1cb5c4f9a06452b881d53f5e2028b23c46c507b6"

  url "https://github.com/memrynote/memry/releases/download/v#{version.csv.first}/MemryNote-#{version.csv.second}-#{arch}.dmg",
      verified: "github.com/memrynote/memry/"
  name "MemryNote"
  desc "Local-first notes, tasks, and projects"
  homepage "https://memrynote.com/"

  livecheck do
    url :url
    regex(%r{/v?(\d{4}-\d{2}-\d{2}(?:\.\d+)?)/Memry(?:note)?[._-]?v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: :monterey

  app "MemryNote.app"

  # Three naming eras coexist. Today app.name is package.json "name"
  # (@memry/desktop) — electron-builder never writes productName into the asar —
  # so live app state (Chromium profile, crdt-store, models, config) sits under
  # @memry/, logs under Logs/@memry, and electron-updater's cache under
  # @memrydesktop-updater (name with "/" sanitized). The memrynote entries cover
  # the runtime identity rename (PR #897) that moves userData/logs/updater cache
  # there; @memry* entries stay for not-yet-migrated installs. The App Support/
  # MemryNote entry is aspirational but harmless — kept. Bundle-id
  # (com.memrynote.memry) keys Caches/HTTPStorages/Preferences/ShipIt and is
  # rename-independent.
  # Vault content (notes + .memry/*.db) lives under the user-chosen vault dir
  # (default ~/Documents/Memry) and is deliberately NOT zapped.
  zap trash: [
    "~/Library/Application Support/@memry",
    "~/Library/Application Support/MemryNote",
    "~/Library/Application Support/memrynote",
    "~/Library/Caches/@memrydesktop-updater",
    "~/Library/Caches/com.memrynote.memry",
    "~/Library/Caches/com.memrynote.memry.ShipIt",
    "~/Library/Caches/memrynote-updater",
    "~/Library/HTTPStorages/com.memrynote.memry",
    "~/Library/Logs/@memry",
    "~/Library/Logs/memrynote",
    "~/Library/Preferences/com.memrynote.memry.plist",
    "~/Library/Saved Application State/com.memrynote.memry.savedState",
  ]
end
