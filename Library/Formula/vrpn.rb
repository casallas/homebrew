require 'formula'

class Vrpn < Formula
  url 'ftp://ftp.cs.unc.edu/pub/packages/GRIP/vrpn/vrpn_07_29.zip'
  md5 '422f13fc9cbb62d36c96f3cc3b06cec9'
  head 'git://git.cs.unc.edu/vrpn.git'
  homepage 'http://vrpn.org'

  depends_on 'libusb' # for HID support
  depends_on 'cmake' => :build
  depends_on 'doxygen' if ARGV.include? '--docs'
  depends_on 'wiiuse' if ARGV.include? '--with-wiiuse'

  def options
    [
      ['--clients', 'Build client apps and tests.'],
      ['--with-wiiuse', 'Build with wiiuse library support, this makes the server GPL'],
      ['--docs', 'Build doxygen-based API documentation']
    ]
  end

  def install
    args = std_cmake_parameters.split

    if ARGV.include? '--clients'
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

    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", *args

      if ARGV.include? '--docs'
        system "make doc"
      end

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
