require 'formula'

class Osgbullet < Formula
  url 'http://osgbullet.googlecode.com/files/osgBullet_02_00_00-rc3.zip'
  sha1 '92f8035d50e90072ddc407dce589c131c2440928' 
  head 'http://osgbullet.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/osgbullet/'
  version '2.0RC3'

  depends_on 'cmake'
  depends_on 'openscenegraph'
  depends_on 'osgworks'
  depends_on 'bullet'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
