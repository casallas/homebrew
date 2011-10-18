require 'formula'

class Wv < Formula
  url 'http://www.abisource.com/downloads/wv/1.2.4/wv-1.2.4.tar.gz'
  homepage 'http://wvware.sourceforge.net/'
  md5 'c1861c560491f121e12917fa76970ac5'

  depends_on 'glib'
  depends_on 'libgsf'
  depends_on 'libwmf'

  def install
    ENV.libxml2
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end

