require 'formula'

class Jpeg < Formula
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  homepage 'http://www.ijg.org/'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'
  version "8d"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-dependency-tracking"
    system "make install"
  end
end


