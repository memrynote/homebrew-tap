cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-09,2026.709.1"
  sha256 arm:   "4d021b820f0b1da1181004a3abc06db8e4169c4aba1e9c1434e424869fc5b450",
         intel: "06c5ebce1fb2161c9a7f0e301267920fec1438dbcd2609bbf9b539bd28fd93e5"

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
