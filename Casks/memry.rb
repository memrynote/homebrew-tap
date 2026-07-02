cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-03,2026.703.1"
  sha256 arm:   "8b9bb7a2dfb4da3855498a363d5342f03d1c57e7ed6f6f585a15d0d48b35065f",
         intel: "b0730b0e582060554b73fbfc3acf21eb59c7b6620d442b9c40310990ee148914"

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
