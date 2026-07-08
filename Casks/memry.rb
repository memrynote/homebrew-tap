cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-08,2026.708.1"
  sha256 arm:   "fec1d3a6eaba33bc7ba648622ddc0c1688923c8c43bd227e3a2da1309fe516d6",
         intel: "b03037528a9246cafabdb76b8444cc2ec20e778569f00bd8c6afcfe5d8261134"

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
