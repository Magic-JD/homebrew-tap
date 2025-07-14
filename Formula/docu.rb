class Docu < Formula
  desc "Document your favourite scriptlets for fast reference."
  homepage "https://github.com/Magic-JD/docu"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.9/docu-aarch64-apple-darwin.tar.xz"
      sha256 "b7ad7f1e65cbd55da7894ffe075d9a852e66859eebdc684d8acb980bb7cdd4f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.9/docu-x86_64-apple-darwin.tar.xz"
      sha256 "74349295a61047ba4fefa12689c384eb931984eec2207d00407842c62df69a48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.9/docu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd56d32d0254e174de33152b5f855c8854a121a67db332a566340af6f9c9390e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Magic-JD/docu/releases/download/v0.1.9/docu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "528f0f93bf8dc9cec795d8aa67414b247d3ed4e4465f61fa85e2587ad99fc27c"
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
