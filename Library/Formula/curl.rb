require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.21.7.tar.bz2'
  sha256 '1a50dd17400c042090203eef347e946f29c342c32b6c4843c740c80975e8215a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
