cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-05,2026.705.1"
  sha256 arm:   "9fbbb28e271b428772090c6b8005d38319b422a877247a136c48e05edcedb2d4",
         intel: "6ac49f13534c7e241b48d3ce38f3f57c1bcb7baa5481425db92228206a7cedb2"

  url "https://github.com/memrynote/memry/releases/download/v#{version.csv.first}/Memrynote-#{version.csv.second}-#{arch}.dmg",
      verified: "github.com/memrynote/memry/"
  name "Memrynote"
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

  app "Memrynote.app"

  zap trash: [
    "~/Library/Application Support/Memrynote",
    "~/Library/Caches/com.memrynote.memry",
    "~/Library/Logs/Memrynote",
    "~/Library/Preferences/com.memrynote.memry.plist",
    "~/Library/Saved Application State/com.memrynote.memry.savedState",
  ]
end
