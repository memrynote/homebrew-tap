cask "memry" do
  arch arm: "arm64", intel: "x64"

  version "2026-07-18,2026.718.1"
  sha256 arm:   "ddfd3edc19c84b5efe8fc197c7ebb87adc66e07fa68763de72b31437df930063",
         intel: "8be47d9841ba5fd282e0fc5e49fa13f1678e3bbce1cfb12aa28275d92bdb7100"

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
