class IsFast < Formula
  desc "Internet search fast - view webpages from the terminal."
  homepage "https://github.com/Magic-JD/is-fast"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.6.0/is-fast-aarch64-apple-darwin.tar.xz"
      sha256 "f1a71301ccef84b13dffb88934dbbd7a21e96a1cf539c7fd00fa4f5e29c9c9f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.6.0/is-fast-x86_64-apple-darwin.tar.xz"
      sha256 "dfea9942c40e7a8774ba8c87e1287cee9c1c8edf18372ae4cb98de49c8409816"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.6.0/is-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd114bf3107f14253223432a4508a39cddbe0db2e7d4647f1304ad782fb6d302"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.6.0/is-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8cf00d0592607f49e7b5274f8663e61380f8c7163d25764b639677113660f74"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "is-fast" if OS.mac? && Hardware::CPU.arm?
    bin.install "is-fast" if OS.mac? && Hardware::CPU.intel?
    bin.install "is-fast" if OS.linux? && Hardware::CPU.arm?
    bin.install "is-fast" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
