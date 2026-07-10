cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-10,2026.710.1"
  sha256 arm:   "6711301a98e869ff47473a14140d93a47cea80b7025a7627af58ab5c53ac5686",
         intel: "ecd083eafe665f5cc539b50385a5c018bc4c945ca128f39352a1de3a795e9718"

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
