class Je < Formula
  desc "Personal connections to J&E Studio models and memory"
  homepage "https://jestatsio.github.io/je/"
  url "https://github.com/jestatsio/je/releases/download/v0.3.1/je-0.3.1-macos-arm64.tar.gz"
  version "0.3.1"
  sha256 "50c6b5f9768d271c05be9a36dd3e4a209faa6ecee37ac51454bdd4277d02af6a"

  depends_on :macos
  depends_on arch: :arm64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"je"
  end

  test do
    # Profile writes store keys in macOS Keychain, which the Homebrew test
    # sandbox cannot reach, so this test covers read-only surfaces instead.
    assert_match "je #{version}", shell_output("#{bin}/je --version")
    state = testpath/"state"
    assert_match "je native core #{version}",
                 shell_output("#{bin}/je --state-dir #{state} status")
    assert_match "No saved connections",
                 shell_output("#{bin}/je --state-dir #{state} profile list")
    assert_match '"status" : "qualified"',
                 shell_output("#{bin}/je support-matrix --json")
  end
end
