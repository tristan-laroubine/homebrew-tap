class Allfy < Formula
  desc "Butler for your CLI: run your own shell commands from a JSON file"
  homepage "https://github.com/tristan-laroubine/alfred"
  version "0.8.0"

  on_macos do
    on_arm do
      url "https://github.com/tristan-laroubine/alfred/releases/download/v#{version}/alfred-darwin-arm64.tar.gz"
      sha256 "12bb1572a2552a59ffe4bb57b4d5a34a68864d030e0af300c780a9b50d0d1e2a"
    end
    on_intel do
      url "https://github.com/tristan-laroubine/alfred/releases/download/v#{version}/alfred-darwin-x64.tar.gz"
      sha256 "294b0fabea74dce2316523f31c80e5c6bc710a849ee8d833585ff0352e0aa0d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tristan-laroubine/alfred/releases/download/v#{version}/alfred-linux-arm64.tar.gz"
      sha256 "ca9df0a21679e6e8eb980079de5f8653784f7a1fc1906793fba1e53a69fc9583"
    end
    on_intel do
      url "https://github.com/tristan-laroubine/alfred/releases/download/v#{version}/alfred-linux-x64.tar.gz"
      sha256 "09b98d30f0ebe0c5b9b7870f451e1f41495b336f707b12f86201ddcabd66d80b"
    end
  end

  def install
    bin.install "alfred"
    generate_completions_from_executable(bin/"alfred", "completion")
  end

  def caveats
    <<~EOS
      Your commands live in ~/.config/alfred/commands.json, run `alfred edit` to change them.
      Run `alfred doctor` to check your setup.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alfred --version")
    (testpath/"commands.json").write <<~JSON
      [{ "name": "hello", "command": { "cmd": "echo Hello ${name}" }, "options": [{ "flags": "--name <name>" }] }]
    JSON
    ENV["ALFRED_COMMANDS"] = testpath/"commands.json"
    assert_equal "Hello Brew", shell_output("#{bin}/alfred hello --name Brew 2>/dev/null").strip
  end
end
