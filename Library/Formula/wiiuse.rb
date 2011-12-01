require 'formula'

class Wiiuse < Formula
  url 'https://github.com/jscasallas/wiiuse/zipball/master'
  homepage 'http://www.hci.iastate.edu/~rpavlik/doxygen/wiiuse-fork/'
  md5 '95b1f1c4961f86c1abc675dc948e248f'
  version '0.14.0'

  depends_on 'cmake' => :build

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end

  def test
    exec "wiiuseexample"
  end
end
