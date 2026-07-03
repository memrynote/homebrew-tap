cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-03.5,2026.703.5"
  sha256 arm:   "d3625a0a48c831e546407fbda1e785246426dcf25d4d381367eb806b2a541a31",
         intel: "bda3e28f79177a2b0d75f58cd0b89c334865c45e66b223e8e8012597bacf14b1"

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
