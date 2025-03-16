class IsFast < Formula
  desc "Internet search fast - view webpages from the terminal."
  homepage "https://github.com/Magic-JD/is-fast"
  version "0.11.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.11.4/is-fast-aarch64-apple-darwin.tar.xz"
      sha256 "39d5ffaa2db3e32d2ec0e4bb1c3995da65ffe47429449dfa78bff5b4dda22939"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.11.4/is-fast-x86_64-apple-darwin.tar.xz"
      sha256 "df27e135a980527304a7df508fe965cbf6812559bd77feb322cc9a78ef921906"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.11.4/is-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53d3c72be1907cddff9443b2a6200e1b97b906344ea91c8e247a23d05b2c96bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.11.4/is-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0659229b94426b81922b50159f32afb9f60bf89ad1ea132f00a00d125c2c2e9"
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
