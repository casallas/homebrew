require 'formula'

class Freealut < Formula
  url 'http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0.tar.gz'
  homepage 'http://connect.creativelabs.com/openal/Documentation/The%20OpenAL%20Utility%20Toolkit.htm'
  md5 'e089b28a0267faabdb6c079ee173664a'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
