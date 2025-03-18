class IsFast < Formula
  desc "Internet search fast - view webpages from the terminal."
  homepage "https://github.com/Magic-JD/is-fast"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.0/is-fast-aarch64-apple-darwin.tar.xz"
      sha256 "09e79457d41fbe5763df236494347a2325cff237bc19b39df449905173dfca9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.0/is-fast-x86_64-apple-darwin.tar.xz"
      sha256 "4589c745b8fd188665ccb058d65ebce5b0d509d8dab02ff2ca693210de195d35"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.0/is-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e79fddf79338ee02dafa2838bbcd825ceb76ff00c4cd51301c0588facdd90d32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/is-fast/releases/download/v0.12.0/is-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c680b6bce0eb21e028cd7076bd63f2209a2b025d43da1b643fc1a9820180e3f3"
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
