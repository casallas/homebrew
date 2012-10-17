require 'formula'

class VrJugglua < Formula
  homepage 'https://github.com/vancegroup/vr-jugglua'
  head 'https://github.com/vancegroup/vr-jugglua.git'
  url 'https://github.com/vancegroup/vr-jugglua.git', :commit => 'cecdebd2e86d3e89ae82305ace6ba0922a30c05f'
  version '1.0.6' # Guessed, since there's no official version

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'open-scene-graph28'
  depends_on 'vr-juggler'
  depends_on 'qt'

  def install
    args = std_cmake_args
    # Don't bundle dependent libraries, they should be in our system anyways
    args << "-DINSTALL_LIBRARIES_BUNDLE=OFF"
    mkdir 'build' do
      system "cmake", "..", *args
      system "make install"
      # Avoid conflicts with lua
      #TODO really vr-jugglua should depend on local lua rather than on bundled one
      if Formula.factory('lua').installed?
        rm_rf bin/'luac'
        rm_rf lib/'liblua.a'
        rm_rf include/'lauxlib.h'
        rm_rf include/'lua.h'
        rm_rf include/'lualib.h'
      end
    end
  end
end
