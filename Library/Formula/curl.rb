require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.21.6.tar.bz2'
  sha256 'd9a3d3593796147ad9ca994c9e6834a42b49756420a10e996dbf849495d3d955'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
