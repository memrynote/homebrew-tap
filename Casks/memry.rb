cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-05-16,2026.516.1"
  sha256 arm:   "548e3d6e0be6077e9d2c70538cc91f9afcf6a57c6436919cc09e78ce52673f43",
         intel: "03b07429ab8f87eefedf4fc7c79200789cc7b6835338fdc50e00466e216d9f7e"

  url "https://github.com/memrynote/memry/releases/download/v#{version.csv.first}/Memry-#{version.csv.second}-#{arch}.dmg",
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

  app "Memry.app"

  zap trash: [
    "~/Library/Application Support/Memry",
    "~/Library/Caches/com.memrynote.memry",
    "~/Library/Logs/Memry",
    "~/Library/Preferences/com.memrynote.memry.plist",
    "~/Library/Saved Application State/com.memrynote.memry.savedState",
  ]
end
