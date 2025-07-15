class Docu < Formula
  desc "Document your favourite scriptlets for fast reference."
  homepage "https://github.com/Magic-JD/docu"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.1/docu-aarch64-apple-darwin.tar.xz"
      sha256 "45f3d1854751d6f225dc4ccf33837f0e3f6e0fed7a7902649f5b969070a3a9c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.1/docu-x86_64-apple-darwin.tar.xz"
      sha256 "dbd38466007d4981730ea73c2a8486e24210a10402926e3849289d805cf8313a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.1/docu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3bbdfc08e0f22b7f5c4e04436dea1f398038614ae4480f4d33ad985d2a07e083"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.2.1/docu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab6879bf8229d01bf8e38758dc31f1caf7f5d0d6c49bbaa8b6ae37b2cb549e00"
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
