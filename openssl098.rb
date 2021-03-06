require "formula"

class Openssl098 < Formula
  homepage "https://www.openssl.org"
  url "https://www.openssl.org/source/openssl-0.9.8zc.tar.gz"
  sha256 "461cc694f29e72f59c22e7ea61bf44671a5fc2f8b3fc2eeac89714b7be915881"

  keg_only :provided_by_osx

  def install
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{etc}/openssl
      no-ssl2
      zlib-dynamic
      shared
    ]

    if MacOS.prefer_64_bit?
      args << "darwin64-x86_64-cc" << "enable-ec_nistp_64_gcc_128"
    else
      args << "darwin-i386-cc"
    end

    system "perl", "./Configure", *args

    ENV.deparallelize # Parallel compilation fails
    system "make"
    system "make", "test"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end
end
