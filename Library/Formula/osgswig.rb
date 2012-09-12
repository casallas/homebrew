require 'formula'

class Osgswig < Formula
  homepage 'http://code.google.com/p/osgswig'
  url 'https://code.google.com/p/osgswig', :using => :hg
  version '3.0.1' # it needs to be the same as osg's

  depends_on 'open-scene-graph'
  depends_on 'swig'
  depends_on 'cmake' => :build

  fails_with :clang do
    cause "clang detects some errors in the python wrapper"
  end

  def install
    args = std_cmake_args
    args << '..'
    if Formula.factory('python').installed?
      args << '-DPYTHON_INCLUDE_DIR='+Formula.factory('python').prefix+
        '/Frameworks/Python.framework/Headers'
      args << '-DPYTHON_LIBRARY='+Formula.factory('python').prefix+
        '/Frameworks/Python.framework/Python'

    mkdir "build" do
        system "cmake", *args
        system "make"
        # Do the library installation manually
        lib.install "lib/python"
    end
  end
end
