require 'formula'

class Flusspferd < Formula
  url 'https://github.com/Flusspferd/flusspferd.git'
  homepage 'http://flusspferd.github.com/'
  version '0.9'

  depends_on 'cmake' => :build
  depends_on 'arabica'
  depends_on 'gmp'
  depends_on 'boost'
  depends_on 'spidermonkey'

  fails_with_llvm

  #Fix CMakeModules/FindSpidermonkey.cmake to be able to find SM 1.8.5
  def patches
    "https://raw.github.com/gist/1347323/flusspferd-cmake_find_spidermonkey1.8.5.patch"
    "https://raw.github.com/gist/49c4e09a8285d4d2c4d0/flusspferd-git_to_https_submodules.patch"
  end

  def install
    system "cmake -H. -Bbuild #{std_cmake_parameters}"
    system "git submodule sync"
    system "make install"
  end
end
