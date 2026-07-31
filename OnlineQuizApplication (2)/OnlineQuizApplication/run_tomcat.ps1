$tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
$env:CATALINA_HOME = $tomcatPath
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.11"
& "$tomcatPath\bin\catalina.bat" run
