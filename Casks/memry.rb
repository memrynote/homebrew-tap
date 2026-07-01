cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-01.4,2026.701.4"
  sha256 arm:   "6b7b3668edcc2995a254cb9f1ee6d32f47defe93d38574323e1715ef06167268",
         intel: "b8c989b9e3dd4d0c1ab795e1c1648f08361128b560d97112eacc92ac191a5a76"

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
