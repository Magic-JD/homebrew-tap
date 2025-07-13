class Docu < Formula
  desc "Document your favourite scriptlets for fast reference."
  homepage "https://github.com/Magic-JD/docu"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.8/docu-aarch64-apple-darwin.tar.xz"
      sha256 "125b50480b425be2f70f7fc64951e36b1bb83aa7ec98e93ca05bf08fca738302"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.8/docu-x86_64-apple-darwin.tar.xz"
      sha256 "175329d2f095211959a5b9c820563e69e90a1b2aa5a053fc3430d065bba53f95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.8/docu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2dd96b4fc59ea935082b1bf23243f4f66cdb99aacc5d10247549d849e9164dbd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.8/docu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c6e4b85b620386c755a64a1327b376bc76c5708cee138b72fe1468cb5fc2e7e"
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
    bin.install "docu" if OS.mac? && Hardware::CPU.arm?
    bin.install "docu" if OS.mac? && Hardware::CPU.intel?
    bin.install "docu" if OS.linux? && Hardware::CPU.arm?
    bin.install "docu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
