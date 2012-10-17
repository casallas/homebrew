require 'formula'

class VrJugglua < Formula
  homepage 'https://github.com/vancegroup/vr-jugglua'
  url 'https://github.com/vancegroup/vr-jugglua.git', :commit => '88a572683e'
  version '1.0.6' # Guessed, since there's no official version

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'osg28'
  depends_on 'vr-juggler'
  depends_on 'qt'

  def install
    ENV['OSG_DIR'] = Formula.factory('osg28').prefix

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install" # if this fails, try separate make/make install steps
    end
  end
end
