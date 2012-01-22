require 'formula'

class Freealut < Formula
  url 'http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0.tar.gz'
  homepage 'http://connect.creativelabs.com/openal/Documentation/The%20OpenAL%20Utility%20Toolkit.htm'
  md5 'e089b28a0267faabdb6c079ee173664a'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
