require 'formula'

class Osgworks < Formula
  url 'http://osgworks.googlecode.com/files/osgWorks_02_00_00-rc1.zip'
  sha1 '04c2dcc60bdd0a11c55545c686e868a2f43b910c'
  head 'http://osgworks.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/osgworks/'
  version '2.0RC1'

  depends_on 'cmake'
  depends_on 'openscenegraph'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  #def patches
    # openscenegraph 3 changed DisplaySettings::instance, thus we need to patch CameraConfigObject.cpp
    # This should be solved in osgWorks' HEAD (2.0 RC1)
    #return DATA unless ARGV.build_head?
  #end
 
end

__END__
diff --git a/src/osgwTools/CameraConfigObject.cpp b/src/osgwTools/CameraConfigObject.cpp
index 76d767c..eac0e4b 100644
--- a/src/osgwTools/CameraConfigObject.cpp
+++ b/Users/juan/Desktop/CameraConfigObject.cpp
@@ -101,7 +101,7 @@ CameraConfigObject::store( osgViewer::Viewer& viewer )
     }
 
     osg::DisplaySettings* ds = masterCamera->getDisplaySettings() != NULL ?
-        masterCamera->getDisplaySettings() : osg::DisplaySettings::instance();
+        masterCamera->getDisplaySettings() : osg::DisplaySettings::instance().get();
     
     double fovy, aspectRatio, zNear, zFar;        
     masterCamera->getProjectionMatrixAsPerspective(fovy, aspectRatio, zNear, zFar);

