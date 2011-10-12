require 'formula'

class Osgworks < Formula
  url 'http://osgworks.googlecode.com/files/osgWorks_01_01_00.tar.gz'
  sha1 '1b50d29b5dcad6335c16d0db28f1bfaef07fcf74'
  head 'http://osgworks.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/osgworks/'
  version '1.1'

  depends_on 'cmake'
  depends_on 'openscenegraph'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
