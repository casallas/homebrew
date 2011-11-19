require 'formula'

class Pygtk < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  homepage 'http://pygtk.org'
  sha256 'cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'pygobject'
  depends_on 'pycairo'
  depends_on 'gtk+' => :optional
  depends_on 'libglade' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    python_lib = Formula.factory("python").prefix
    <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHONPATH=#{python_lib}/site-packages:$PYTHONPATH

Also note that you need to execute pygtk apps using the X11 terminal.
    EOS
  end

  def test
    system "xinit pygtk-demo"
  end
end
