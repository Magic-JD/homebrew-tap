class Tokenburn < Formula
  desc "Measures token spend when using claude code."
  homepage "https://github.com/Magic-JD/tokenburn"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.4/tokenburn-aarch64-apple-darwin.tar.xz"
      sha256 "a2bd32e0373fec6af2b0949bca64d538bedbaabcb12beeff86a28555034d1bd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.4/tokenburn-x86_64-apple-darwin.tar.xz"
      sha256 "8961488d6bdf9e56dd97d7e8570a445eae08ce81ac781bae462e4531203407fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.4/tokenburn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22ed89282f3d37f35b9a97099780bc23baf2ba5c6c60ce8fa9862ae952af511b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/tokenburn/releases/download/v0.1.4/tokenburn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ff75f93fcdfbd0183e8db181b3bc3356a7d870d52643d746638e8d4382ef08b"
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
