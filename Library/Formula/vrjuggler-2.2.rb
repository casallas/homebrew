require 'formula'

class Vrjuggler22 <Formula
  url 'https://github.com/jscasallas/vrjuggler.git', :branch => '2.2'
  version "2.2.2-1"
  head 'https://github.com/jscasallas/vrjuggler.git', :branch => '2.2' 
  homepage 'http://code.google.com/p/vrjuggler/'

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

  def install
    #if Formula.factory('vrjuggler-3.0').installed?
    #  ohai 'Unlinking vrjuggler-3.0 before installing vrjuggler-2.2'
    #  system "brew", "unlink", "vrjuggler-3.0"
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
    if not (ENV['HOMEBREW_USE_LLVM'] or ARGV.include? '--use-llvm')
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
