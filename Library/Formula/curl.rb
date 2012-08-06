require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.27.0.tar.gz'
  sha256 '8cbad34e58608f0e959fe16c7c987e57f5f3dec2c92d1cebb0678f9d668a6867'

  depends_on 'pkg-config' => :build
  depends_on 'libssh2' if ARGV.include? "--with-ssh"

  def options
    [["--with-ssh", "Build with scp and sftp support."]]
  end

  def install
    args = %W[
        --disable-debug
        --disable-dependency-tracking
        --prefix=#{prefix}]

    args << "--with-libssh2" if ARGV.include? "--with-ssh"

    system "./configure", *args
    system "make install"
  end
end
