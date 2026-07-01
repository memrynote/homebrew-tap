cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-01.2,2026.701.2"
  sha256 arm:   "f23a8916ba6e9f9d2ce1abf423167fef62291de75f33f58084ac21e1a88a001b",
         intel: "01bf3e2fa023fd91ac7b8730b109512f0e2b6881b4c2a5b4aefebf2fad830e97"

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

  app "Memry.app"

  zap trash: [
    "~/Library/Application Support/Memry",
    "~/Library/Caches/com.memrynote.memry",
    "~/Library/Logs/Memry",
    "~/Library/Preferences/com.memrynote.memry.plist",
    "~/Library/Saved Application State/com.memrynote.memry.savedState",
  ]
end
