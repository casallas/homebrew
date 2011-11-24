require 'formula'

class Blahtexml < Formula
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  homepage 'http://gva.noekeon.org/blahtexml/'
  md5 'ed790599223c2f8f6d205be8988882de'

  #depends_on 'xerces-c' unless ARGV.include? '--blahtex-only'

  def options
    [
      ['--blahtex-only', "Build only blahtex, not blahtexml"]
    ]
  end


  def install
    if ARGV.include? '--blahtex-only'
      system "echo blahtex-only"
    end

    system "make blahtex-mac"
    bin.install('blahtex')
    unless ARGV.include? '--blahtex-only'
      system "make blahtexml-mac"
      bin.install('blahtexml')
    end
  end

  def caveats; <<-EOS.undent
    This formula installs both blahtex and blahtexml.
    If you only want to install blahtex, then do:
      brew install blahtexml --blahtex-only
    EOS
  end
end
