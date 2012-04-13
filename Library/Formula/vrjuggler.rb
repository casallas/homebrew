require 'formula'

class Vrjuggler <Formula
  head 'git://github.com/jscasallas/vrjuggler.git', :branch => 'cmake-3.0'
  homepage 'http://code.google.com/p/vrjuggler/'
  url 'git://github.com/jscasallas/vrjuggler.git', :branch => 'cmake-3.0'
  version '3.0.0-1'

  depends_on 'boost'
  depends_on 'cppdom'
  depends_on 'gmtl'
  depends_on 'flagpoll'
  depends_on 'freealut' => :recommended
  depends_on 'vrpn' => :recommended
  depends_on 'omniorb' => :optional

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
