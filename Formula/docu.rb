class Docu < Formula
  desc "Document your favourite scriptlets for fast reference."
  homepage "https://github.com/Magic-JD/docu"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.7/docu-aarch64-apple-darwin.tar.xz"
      sha256 "9de93cc4d6a91b10e2490fb84552daa1d68c1a148e86d2fb88d564eabaefe3d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.7/docu-x86_64-apple-darwin.tar.xz"
      sha256 "6f61414967f1d41ddcb9dd133371233274bb78bcd59e074293ed0f690e22560d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.7/docu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3a3c1b1ed63912c31527b866ec1c4375e5b755dbd56550be7eec9de6ea9837a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.7/docu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a85a47578f0f0f3e04c389b0c2c69f83fafb6a67959e2635ab06b674f7939be7"
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
