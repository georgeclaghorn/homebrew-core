class GstPluginsUgly < Formula
  desc "GStreamer plugins (well-supported, possibly problematic for distributors)"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.6.3.tar.xz"
  sha256 "2fecf7b7c7882f8f62f1900048f4013f98c214fb3d3303d8d812245bb41fd064"

  bottle do
    sha256 "d00e1d28a2c5b37667fe1bc8680264eff3b594364293a3d11babf6076e150702" => :el_capitan
    sha256 "42de7b56a14187397b179f0d429e8a31c51e6036ba49a5a0b25c4f33b0033a75" => :yosemite
    sha256 "3d5f84e3c36f76ed93bd963f9b93a620f1ebf026dfc5037f1d4ea41524d392cc" => :mavericks
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-ugly"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "mad" => :optional
  depends_on "jpeg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "cdparanoia" => :optional
  depends_on "lame" => :optional
  depends_on "two-lame" => :optional
  depends_on "libshout" => :optional
  depends_on "aalib" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmpeg2" => :optional
  depends_on "a52dec" => :optional
  depends_on "liboil" => :optional
  depends_on "flac" => :optional
  depends_on "gtk+" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libmms" => :optional
  depends_on "x264" => :optional
  depends_on "opencore-amr" => :optional
  # Does not work with libcdio 0.9

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    if build.with? "opencore-amr"
      # Fixes build error, missing includes.
      # https://github.com/Homebrew/homebrew/issues/14078
      nbcflags = `pkg-config --cflags opencore-amrnb`.chomp
      wbcflags = `pkg-config --cflags opencore-amrwb`.chomp
      ENV["AMRNB_CFLAGS"] = nbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrnb"
      ENV["AMRWB_CFLAGS"] = wbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrwb"
    else
      args << "--disable-amrnb" << "--disable-amrwb"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
