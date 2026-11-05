class WgLauncher < Formula
  desc "Command-line launcher for Wargaming game assets"
  homepage "https://github.com/gabrielhamel/wg-launcher"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gabrielhamel/wg-launcher/releases/download/1.4.0/wg-launcher-cli-aarch64-apple-darwin.tar.gz"
      sha256 "1446c47f324ca32703c2fbe012ac691017ea1aaa3268fbb021fb0f2a9fb2bc99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gabrielhamel/wg-launcher/releases/download/1.4.0/wg-launcher-cli-x86_64-apple-darwin.tar.gz"
      sha256 "043ecc1cb1404b2db24cd3efdc629b413f9f21aaedb54ebde0f2db471d1827e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gabrielhamel/wg-launcher/releases/download/1.4.0/wg-launcher-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e2c39741c435c38302474ad18ea067401edb1732ec1b673c66892085fd72ee0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "wg-launcher"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "wg-launcher"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wg-launcher"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
