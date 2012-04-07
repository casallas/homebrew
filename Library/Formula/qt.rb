require 'formula'
require 'hardware'

class Qt <Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.3.tar.gz'
  md5 '5c69f16d452b0bb3d44bc3c10556c072'
  homepage 'http://www.qtsoftware.com'

  def options
    [
      ['--with-qtdbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
    ]
  end

  depends_on "d-bus" if ARGV.include? '--with-qtdbus'
  depends_on 'sqlite' 

  def install
    args = ["-prefix", prefix,
            "-nomake", "demos", "-nomake", "examples",
            "-release", 
            "-confirm-license", "-opensource",
            "-fast"]

    if ARGV.include? '--with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
      args << "-L#{Formula.factory('d-bus').lib}"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if ARGV.include? '--with-qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    args << '-arch' << 'x86_64'

    system "./configure", *args
    system "make install"

    # stop crazy disk usage
    (prefix+'doc/html').rmtree
    (prefix+'doc/src').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall."
  end
end
