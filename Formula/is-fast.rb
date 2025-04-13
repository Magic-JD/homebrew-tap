class IsFast < Formula
  desc "Internet search fast - view webpages from the terminal."
  homepage "https://github.com/Magic-JD/is-fast"
  version "0.15.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.15.3/is-fast-aarch64-apple-darwin.tar.xz"
      sha256 "57d1c57286dc921698ec2940cc0e7e439452e4d15cc72d6fff71d89b6bf3c9c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.15.3/is-fast-x86_64-apple-darwin.tar.xz"
      sha256 "d98e6ba13c9e07029aee0871033768390be249f7517ecffe313f7bd251922343"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.15.3/is-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aa04c9c33f650dc81676a2c494a01de1b4f094109dc2254dbfebdb45fb32be25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.15.3/is-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1cfb8546d2b17cc07e416864a6a2176e74b0626f6485a56cc01a14ab16d9eb46"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "i686-unknown-linux-gnu":            {},
    "i686-unknown-linux-musl-dynamic":   {},
    "i686-unknown-linux-musl-static":    {},
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
