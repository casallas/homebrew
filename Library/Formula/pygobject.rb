require 'formula'

class Pygobject <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.28/pygobject-2.28.4.tar.bz2'
  homepage 'http://pygtk.org'
  sha256 '70e3a05dd5f688e68b5dafa2412cd4fdbc0af83792a5752ef6353c4accf2022c'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'pycairo'

  def install
    ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    ENV['FFI_LIBS'] = '-L/usr/lib -lffi'
    system "./configure", "--prefix=#{prefix}",
      "--disable-dependency-tracking", "--disable-introspection"
    inreplace 'pygobject-2.0.pc', 'Requires.private: libffi',
      'Libs.private: -lffi'
    inreplace 'pygobject-2.0.pc', 'Cflags: ', 'Cflags: -I/usr/include/ffi '
    system "make install"
  end
end
