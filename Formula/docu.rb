class Docu < Formula
  desc "Document your favourite scriptlets for fast reference."
  homepage "https://github.com/Magic-JD/docu"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.0/docu-aarch64-apple-darwin.tar.xz"
      sha256 "a01655bc6436467236ac9734647357b0fb222f290fdd1d216b1adb8e48f42607"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.0/docu-x86_64-apple-darwin.tar.xz"
      sha256 "53af2fd03650451c513a9438913270f686322cba5c0137c9da426f1654643266"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.0/docu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e142cf650238b048f63ab5f18cd00bbb970dd1f6a2b9e354f549b14a18cdcc36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.0/docu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0480c151719b4e6248e0ffd8f200661f2c318f059824ee20c057b710f7b675c0"
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
