require 'formula'

class Pycairo <Formula
  url 'http://cairographics.org/releases/pycairo-1.8.6.tar.gz'
  homepage 'http://cairographics.org/pycairo/'
  md5 'd10a68f88da0a6a02864bf8f0c25ee4d'

  depends_on 'pkg-config' => :build

  # cairo 1.8.6 is bundled with Snow Leopard
  depends_on 'cairo' if MACOS_VERSION < 10.6

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
