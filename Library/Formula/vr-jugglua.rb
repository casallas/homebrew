require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class VrJugglua < Formula
  homepage 'https://github.com/vancegroup/vr-jugglua'
  head 'https://github.com/jscasallas/vr-jugglua.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'vrjuggler-3.0'
  depends_on 'osg28'
  depends_on 'qt'

  def install
    ENV['OSG_DIR'] = Formula.factory('osg28').prefix

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install" # if this fails, try separate make/make install steps
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vr-jugglua`.
    system "false"
  end
end
