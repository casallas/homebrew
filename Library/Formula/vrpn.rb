require 'formula'

class Vrpn < Formula
  homepage 'http://vrpn.org'
  url 'http://www.cs.unc.edu/Research/vrpn/downloads/vrpn_07_31.zip'
  sha1 'a78dd36cd301a7def2d54576cfa63604a8729ace'

  head 'git://git.cs.unc.edu/vrpn.git'

  option 'clients', 'Build client apps and tests'
  option 'docs', 'Build doxygen-based API documentation'

  depends_on 'cmake' => :build
  depends_on 'libusb' # for HID support
  depends_on 'doxygen' if build.include? 'docs'

  def options
    [
      ['--clients', 'Build client apps and tests.'],
      ['--with-wiiuse', 'Build with wiiuse library support, this makes the server GPL'],
      ['--docs', 'Build doxygen-based API documentation']
    ]
  end

  def install
    args = std_cmake_args

    if build.include? 'clients'
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end

    if ARGV.include? '--with-wiiuse'
      args << "-DVRPN_USE_WIIUSE:BOOL=ON"
      # Using the wiiuse library makes a GPL server
      # so we need to set this to true (see caveats)
      args << "-DVRPN_GPL_SERVER:BOOL=ON"
    else
      # Just in case wiiuse is installed, but the user
      # doesn't explicitly want to use it with VRPN
      # (e.g. because of the GPL license)
      args << "-DVRPN_USE_WIIUSE:BOOL=OFF"
    end
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make doc" if build.include? 'docs'
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    When using --with-wiiuse your VRPN libraries/binaries may
    automatically become GPL. If this is unacceptable, don't
    use that option.
    "I am not a lawyer, and this is not legal advice!"
    EOS
  end

end
