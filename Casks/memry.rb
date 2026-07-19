cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-19.2,2026.719.2"
  sha256 arm:   "f91e21e31e44c2820fa346d4f015455240302f36d3dd9eae43298c012532e195",
         intel: "6f4d211c5d5437200d6928f0007b149809d20a36afb1ee38f45e9b7aeb8a2b1e"

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
