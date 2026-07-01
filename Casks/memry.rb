cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-02,2026.702.1"
  sha256 arm:   "d024cb22fe13082bec5743d6b47ef8d6eeb98d8653e1b85752e83a4c94361ba4",
         intel: "5c0f7da5ea83645d90b782d12fa0a36c01edf4d6979a7f8442696a6f33fd6da5"

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
