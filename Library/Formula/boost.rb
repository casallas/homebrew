require 'formula'

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.48.0/boost_1_48_0.tar.bz2'
  md5 'd1e9a7a7f532bb031a3c175d86688d95'
  head 'http://svn.boost.org/svn/boost/trunk', :using => :svn

  def patches
    # https://svn.boost.org/trac/boost/ticket/6131
    #
    # #define foreach BOOST_FOREACH causes weird compile error in certain
    # circumstances with boost 1.48
    #
    # #define foreach BOOST_FOREACH causes compile error "'boost::BOOST_FOREACH'
    # has not been declared" on its line if it appears after #include
    # <boost/foreach.hpp> and before certain other boost headers.
    DATA
  end

  def patches
    # https://svn.boost.org/trac/boost/ticket/6131
    #
    # #define foreach BOOST_FOREACH causes weird compile error in certain
    # circumstances with boost 1.48
    #
    # #define foreach BOOST_FOREACH causes compile error "'boost::BOOST_FOREACH'
    # has not been declared" on its line if it appears after #include
    # <boost/foreach.hpp> and before certain other boost headers.
    DATA
  end

  def options
    [
      ["--with-mpi", "Enable MPI support"],
      ["--without-python", "Build without Python"]
    ]
  end

  # Fix ENV.make_jobs
  def install
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            #"-j#{ENV.make_jobs}",
            "--layout=tagged",
            "threading=multi",
            "install"]

    args << "--without-python" if ARGV.include? "--without-python"

    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "./bjam", *args
  end
end
__END__
Index: /boost/foreach_fwd.hpp
===================================================================
--- /boost/foreach_fwd.hpp  (revision 62661)
+++ /boost/foreach_fwd.hpp  (revision 75540)
@@ -15,4 +15,6 @@
 #define BOOST_FOREACH_FWD_HPP

+#include <utility> // for std::pair
+
 // This must be at global scope, hence the uglified name
 enum boost_foreach_argument_dependent_lookup_hack
@@ -26,4 +28,7 @@
 namespace foreach
 {
+    template<typename T>
+    std::pair<T, T> in_range(T begin, T end);
+
     ///////////////////////////////////////////////////////////////////////////////
     // boost::foreach::tag
@@ -47,4 +52,22 @@
 } // namespace foreach

+// Workaround for unfortunate https://svn.boost.org/trac/boost/ticket/6131
+namespace BOOST_FOREACH
+{
+    using foreach::in_range;
+    using foreach::tag;
+
+    template<typename T>
+    struct is_lightweight_proxy
+      : foreach::is_lightweight_proxy<T>
+    {};
+
+    template<typename T>
+    struct is_noncopyable
+      : foreach::is_noncopyable<T>
+    {};
+
+} // namespace BOOST_FOREACH
+
 } // namespace boost

Index: /boost/foreach.hpp
===================================================================
--- /boost/foreach.hpp  (revision 75077)
+++ /boost/foreach.hpp  (revision 75540)
@@ -166,5 +166,5 @@
 //   at the global namespace for your type.
 template<typename T>
-inline boost::foreach::is_lightweight_proxy<T> *
+inline boost::BOOST_FOREACH::is_lightweight_proxy<T> *
 boost_foreach_is_lightweight_proxy(T *&, BOOST_FOREACH_TAG_DEFAULT) { return 0; }

@@ -191,5 +191,5 @@
 //   at the global namespace for your type.
 template<typename T>
-inline boost::foreach::is_noncopyable<T> *
+inline boost::BOOST_FOREACH::is_noncopyable<T> *
 boost_foreach_is_noncopyable(T *&, BOOST_FOREACH_TAG_DEFAULT) { return 0; }

