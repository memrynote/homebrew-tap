cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-09-18,2026.918.1"
  sha256 arm:   "1d936f1409d1c9d01551d6908e84e5ed81b5904e6442d735b8655cc0d8b7f939",
         intel: "66dc19acc8ef3cde8af9fce0fec6e7302334e566167dad0ffad33ffb2f9ecd5e"

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
