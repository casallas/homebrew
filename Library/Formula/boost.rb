require 'formula'

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.50.0/boost_1_50_0.tar.bz2'
  sha1 'ee06f89ed472cf369573f8acf9819fbc7173344e'

  head 'http://svn.boost.org/svn/boost/trunk'

  depends_on "icu4c" if ARGV.include? "--with-icu"

  def options
    [
      ["--with-mpi", "Enable MPI support"],
      ["--without-python", "Build without Python"],
      ["--with-icu", "Build regexp engine with icu support"],
    ]
  end

  def install
    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if ARGV.include? "--with-icu"
      icu4c_prefix = Formula.factory('icu4c').prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    end

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-j#{Hardware.processor_count}",
            "--layout=tagged",
            "threading=multi",
            "install"]

    args << "--without-python" if ARGV.include? "--without-python"

    system "./bootstrap.sh", *bargs
    system "./bjam", *args
  end
end
