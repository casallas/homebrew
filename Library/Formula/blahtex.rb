require 'formula'

class Blahtex < Formula
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  homepage 'http://gva.noekeon.org/blahtexml/'
  md5 'ed790599223c2f8f6d205be8988882de'

  def install
    system "make blahtex-mac"
    bin.install('blahtex')
  end

  def caveats; <<-EOS.undent
    This formula only installs blahtex, not blahtexml.
    If you want to install blahtexml, then do:
      brew install blahtexml
    EOS
  end
end
