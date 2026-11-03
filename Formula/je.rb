class Je < Formula
  desc "Personal connections to J&E Studio models and memory"
  homepage "https://jestatsio.github.io/je/"
  url "https://github.com/jestatsio/je/releases/download/v0.2.0/je-0.2.0-macos-arm64.tar.gz"
  version "0.2.0"
  sha256 "e18ef358f7d9e2bba3f86213046775f469e45484adf6709713247a47326de6c0"

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
