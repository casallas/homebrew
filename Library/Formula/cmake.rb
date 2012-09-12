require 'formula'

class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.9.tar.gz'
  sha1 'b96663c0757a5edfbddc410aabf7126a92131e2b'
  homepage 'http://www.cmake.org/'

  def install

    if ENV['GREP_OPTIONS'] == "--color=always"
      opoo "GREP_OPTIONS is set to '--color=always'"
      puts <<-EOS.undent
        Having `GREP_OPTIONS` set this way causes CMake builds to fail.
        You will need to `unset GREP_OPTIONS` before brewing.
      EOS
    end

    system "./bootstrap", "--prefix=#{prefix}",
                          "--system-libs",
                          "--no-system-libarchive",
                          "--datadir=/share/cmake",
                          "--docdir=/share/doc/cmake",
                          "--mandir=/share/man"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/cmake", "-E", "echo", "testing"
  end
end
