class Lesstif < Formula
  desc "Open source implementation of OSF/Motif"
  homepage "https://lesstif.sourceforge.io"
  url "https://downloads.sourceforge.net/project/lesstif/lesstif/0.95.2/lesstif-0.95.2.tar.bz2"
  sha256 "eb4aa38858c29a4a3bcf605cfe7d91ca41f4522d78d770f69721e6e3a4ecf7e3"

  bottle do
    rebuild 1
    sha256 "7f9c7fcc2d0313e6b9d2c9e73ddc2f6ee4e25f67f1e4dcd56135b8900e369398" => :catalina
    sha256 "4c7d5c15896694afd346ed12b62b8bfc7a7241d0067238ce546838014fcfdf67" => :mojave
    sha256 "1691f111917e5dcc96f5cc3faf77743d9ac135c16b4a1c2bf7c4f8e55cd26dbf" => :high_sierra
    sha256 "d3c4ea1fe9c0e12a88f9a35dbdd4903d93b69bf89b570e9b1a0e15c8d1104275" => :sierra
    sha256 "bc26ea0e27740c5b3a045b776737ff94ea0bc68b833fc013b92177511271bbcd" => :el_capitan
    sha256 "a9c9a7fe8261ddbf4830655e6a1a3baa8849669064b990d04338c7bcfb57e6c3" => :yosemite
    sha256 "b5650ec87b85ac2b36f8e9cb53a452af1ed28f939cf007b209b458773d0634a6" => :mavericks
  end

  depends_on "freetype"
  depends_on :x11

  conflicts_with "openmotif",
    :because => "Lesstif and Openmotif are complete replacements for each other"

  def install
    # LessTif does naughty, naughty, things by assuming we want autoconf macros
    # to live in wherever `aclocal --print-ac-dir` says they should.
    # Shame on you LessTif! *wags finger*
    inreplace "configure", "`aclocal --print-ac-dir`", "#{share}/aclocal"

    # 'sed' fails if LANG=en_US.UTF-8 as is often the case on Macs.
    # The configure script finds our superenv sed wrapper, sets SED,
    # but then doesn't use that variable.
    ENV["LANG"] = "C"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-production",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static"

    system "make"

    # LessTif won't install in parallel 'cause several parts of the Makefile will
    # try to make the same directory and `mkdir` will fail.
    ENV.deparallelize
    system "make", "install"
  end
end
