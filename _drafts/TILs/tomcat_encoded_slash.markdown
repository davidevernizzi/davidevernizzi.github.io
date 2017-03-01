Tomcat does not allow for encoded slash for security reasons:

http://i-proving.com/2014/01/20/tomcat-apachehttpd-encoded-slashes-problem/

to enabled them, edit `/etc/tomcat7/catalina.properties` and add `org.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true` at the end of the file
