require 'formula'

class Flagpoll <Formula
  url 'http://flagpoll.googlecode.com/files/flagpoll-0.9.4-src.tar.bz2'
  homepage 'http://code.google.com/p/flagpoll/'
  sha1 'a20d89c78a26177eb0e66b8bcf5f93db726b65a2'

  def install
    system("mkdir -p #{HOMEBREW_PREFIX}/lib/flagpoll")
    system("mkdir -p #{HOMEBREW_PREFIX}/share/flagpoll")

    system "./setup.py", "install", "--prefix=#{prefix}"
  end
end
