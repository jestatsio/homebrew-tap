class Je < Formula
  desc "Personal connections to J&E Studio models and memory"
  homepage "https://jestatsio.github.io/je/"
  url "https://github.com/jestatsio/je/releases/download/v0.3.0/je-0.3.0-macos-arm64.tar.gz"
  version "0.3.0"
  sha256 "69d71a49b39a3eeadf491180311942079abbc8c75567352022b57f7d04e730f0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"je"
  end

  test do
    state = testpath/"profiles"
    ENV["JE_FORMULA_TEST_KEY"] = "synthetic-homebrew-profile-key"
    system bin/"je", "--state-dir", state, "profile", "add", "example",
           "--endpoint", "https://models.example.test", "--model", "example-model",
           "--key-env", "JE_FORMULA_TEST_KEY"
    output = shell_output("#{bin}/je --state-dir #{state} profile show example")
    assert_match "example-model", output
    refute_match "synthetic-homebrew-profile-key", output
    system bin/"je", "--state-dir", state, "profile", "remove", "example"
    refute_path_exists state/"profiles/example.json"
  end
end
