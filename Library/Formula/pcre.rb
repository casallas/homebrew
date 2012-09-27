require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2'
  sha256 '5778a02535473c7ee7838ea598c19f451e63cf5eec0bf0307a688301c9078c3c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2"
    system "make test"
    system "make install"
  end
end
