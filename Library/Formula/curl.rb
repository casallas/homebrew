require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.24.0.tar.bz2'
  sha256 'ebdb111088ff8b0e05b1d1b075e9f1608285e8105cc51e21caacf33d01812c16'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
