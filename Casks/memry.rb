cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-17,2026.717.1"
  sha256 arm:   "84d6c33e6f1a8c07b4a1e57916e5dc3fd17ed44689738b251091cdc71fa452d1",
         intel: "6bb70a153ddacd0140d612995b7dc7f9bad518c7346e2b8dd1a9c5d40b5f309b"

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

  zap trash: [
    "~/Library/Application Support/MemryNote",
    "~/Library/Caches/com.memrynote.memry",
    "~/Library/Logs/MemryNote",
    "~/Library/Preferences/com.memrynote.memry.plist",
    "~/Library/Saved Application State/com.memrynote.memry.savedState",
  ]
end
