require 'formula'

class Osgworks < Formula
  url 'http://osgworks.googlecode.com/files/osgWorks_02_00_00.tar.gz'
  sha1 '109c4b253f26345c51e0f5df0b3edaea3732485f'
  head 'http://osgworks.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/osgworks/'
  version '2.0'

  depends_on 'cmake'
  depends_on 'openscenegraph'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
