require 'formula'

class Qvrpn < Formula
  url 'https://github.com/rpavlik/qvrpn/zipball/master'
  homepage 'https://github.com/rpavlik/qvrpn'
  md5 '4ff0baae5d7ddc4ae1e5bcbea45b0d54'
  version '1.0'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'vrpn' #--with-wiiuse --HEAD #this guarantees vrpn_Mainloop*

  def patches
    # Some Qt includes on vrpn_QTrackerRemote are not standard
    "https://raw.github.com/gist/1431746/vrpn_QTrackerRemote.h.diff" 
  end

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      lib.install "qvrpn/libqvrpn.a"
    end
    rm_f Dir["qvrpn/*.txt"]
    rm_f Dir["qvrpn/*.cpp"]
    include.install "qvrpn"
    prefix.install "LICENSE_1_0.txt"
  end
end
