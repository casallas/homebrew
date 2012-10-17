require 'formula'

class VrJuggler < Formula
  head 'https://code.google.com/p/vrjuggler/', :using => :git, :branch => '3.0'
  homepage 'http://code.google.com/p/vrjuggler/'
  url 'https://code.google.com/p/vrjuggler/', :using => :git, :commit => '2f05d060da0749542daa1fa815bf2f95975052b7'
  version '3.0.0-1'

  depends_on 'boost'
  depends_on 'cppdom'
  depends_on 'gmtl'
  depends_on 'flagpoll'
  depends_on 'freealut' => :recommended
  depends_on 'vrpn' => :recommended
  #depends_on 'omniorb' => :optional

  def options
    [['--with-debug', 'Build debug and release libraries.']]
  end

  fails_with :clang

  def install
    #if Formula.factory('vrjuggler-2.2').installed?
    #  ohai 'Unlinking vrjuggler-2.2 before installing vrjuggler-3.0'
    #  system "brew", "unlink", "vrjuggler-2.2"
    #end

    args = ["--prefix=#{prefix}",
      "--with-boost=#{HOMEBREW_PREFIX}"]

    if Formula.factory("freealut").installed?
      args << "--with-alut=#{HOMEBREW_PREFIX}"
    end

    if Formula.factory("vrpn").installed?
      args << "--with-vrpn=#{HOMEBREW_PREFIX}"
    end

    if Formula.factory("omniorb").installed?
      args << "--with-cxx-orb=omniORB4"
      args << "--with-cxx-orb-root=#{HOMEBREW_PREFIX}"
    end

    # For some reason, juggler fails to build nicely in parallel in any kind
    # of packinging-like setup
    ENV.deparallelize()

    # Make our local aclocal dir before autogen, to be safe and avoid errors
    system "mkdir -p #{share}/aclocal"

    ENV['ACLOCAL_FLAGS'] = "-I #{share}/aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    ENV['FLAGPOLL_PATH'] = "#{lib}/flagpoll:#{share}/flagpoll:#{HOMEBREW_PREFIX}/lib/flagpoll:#{HOMEBREW_PREFIX}/share/flagpoll"
    ENV['AUTOCONF'] = "/usr/bin/autoconf"
    ENV['AUTOHEADER'] = "/usr/bin/autoheader"
    ENV['ACLOCAL'] = "/usr/bin/aclocal-1.10"
    if ENV['HOMEBREW_USE_CLANG'] or ARGV.include? '--use-clang'
      ENV['CC'] = "clang"
      ENV['CXX'] = "clang++"
    elsif ENV['HOMEBREW_USE_LLVM'] or ARGV.include? '--use-llvm'
      ENV['CC'] = "llvm-gcc"
      ENV['CXX'] = "llvm-g++"
    else
      ENV['CC'] = "gcc"
      ENV['CXX'] = "g++"
    end

    # Make the default Java location correct
    inreplace 'modules/tweek/java/tweek-base.sh.in', /\/usr\/java/, '/usr'

    # The prefix set here is immediately written to, so using the keg.
    system "./configure.pl", *args

    # setting the instprefix variable to put the homebrew prefix as the
    # libraries' "known root dir", while installing to the keg.

    # build debug libraries if requested
    if ARGV.include? '--with-debug'
      # First make the optimized libraries, then make the debug libraries
      system "make", "opt-dso", "instprefix=#{HOMEBREW_PREFIX}"
      system "make", "dbg-dso", "instprefix=#{HOMEBREW_PREFIX}"

      system "make", "install", "instprefix=#{HOMEBREW_PREFIX}"
    else
      # Make only the optimized libraries
      system "make", "opt-dso", "instprefix=#{HOMEBREW_PREFIX}"
      system "make", "install-optim", "instprefix=#{HOMEBREW_PREFIX}"
    end

  end

  def caveats
    "VRJConfig.app and Tweek.app installed to #{prefix} - you may copy them to /Applications if you like."
  end
end
