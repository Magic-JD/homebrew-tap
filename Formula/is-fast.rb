class IsFast < Formula
  desc "Internet search fast - view webpages from the terminal."
  homepage "https://github.com/Magic-JD/is-fast"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.3/is-fast-aarch64-apple-darwin.tar.xz"
      sha256 "c465c0ba7841737df48539b3f736e9206917d94c59ac2f4d0f851e6e33542d80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.3/is-fast-x86_64-apple-darwin.tar.xz"
      sha256 "cfa3d7dc2494c52b841551fb0cd86ec8b2d65658ff716d53f8fb95e5c2bc66fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.3/is-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6cd5f9c85f027eb4f8aded42729e2b18297574f65a388d1e92aa7e2e5376e49f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.3/is-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d546b225a3fd5d930ab02d1487a5eb562cafecd416f629d0b09889972d0c3bc"
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
