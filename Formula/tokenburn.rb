class Tokenburn < Formula
  desc "Measures token spend when using claude code."
  homepage "https://github.com/Magic-JD/tokenburn"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.3/tokenburn-aarch64-apple-darwin.tar.xz"
      sha256 "e2b7f8d067c1a748aecaba29d493ace83f1657baf2f09f96b9a096bf916cccba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.3/tokenburn-x86_64-apple-darwin.tar.xz"
      sha256 "f1f1721fd0e831ca42087edca0bc22af816fba89848cc3bd70599e27eca54610"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.3/tokenburn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ebb41ebc07f4dee67adb7c2afc48dd77fd9c94eefbaa3f885642d5d797a8b9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.3/tokenburn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17c5c3ac8830164d19103f91c2fb4c30f917e2be869cd809473ce93648f5bc8a"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "tokenburn" if OS.mac? && Hardware::CPU.arm?
    bin.install "tokenburn" if OS.mac? && Hardware::CPU.intel?
    bin.install "tokenburn" if OS.linux? && Hardware::CPU.arm?
    bin.install "tokenburn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
