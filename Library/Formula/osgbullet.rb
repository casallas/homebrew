require 'formula'

class Osgbullet < Formula
  url 'http://osgbullet.googlecode.com/files/osgBullet_02_00_00.tar.gz'
  sha1 '7715f989307667598612dd7b862cba31bf64a003'
  head 'http://osgbullet.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/osgbullet/'
  version '2.0'

  depends_on 'cmake'
  depends_on 'openscenegraph'
  depends_on 'osgworks'
  depends_on 'bullet'
  depends_on 'doxygen' if ARGV.include? '--with-docs'

  def options
    [['--with-docs', "Generate doxygen documentation"]]
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
    system "make Documentation" if ARGV.include? '--with-docs'
  end
end
