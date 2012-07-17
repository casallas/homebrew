require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.2.tar.gz'
  sha256 '79a696070a058c233c72dd6ac697021cc64abd5ed51e59db867d66d196a89381'
  version '6.2.4'

  def patches
    {:p0 => [
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-001",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-002",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-003",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-004"
      ]}
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end
