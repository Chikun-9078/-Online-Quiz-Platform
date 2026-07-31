# deploy.ps1 - Compile and Deploy the OnlineQuizApplication to Apache Tomcat 9.0

$ErrorActionPreference = "Stop"

$tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
$env:CATALINA_HOME = $tomcatPath
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.11"
$appName = "OnlineQuizApplication"
$deployPath = Join-Path $tomcatPath "webapps\$appName"
$classesPath = Join-Path $deployPath "WEB-INF\classes"

Write-Output "Stopping Tomcat9 service..."
try {
    Stop-Service -Name "Tomcat9" -ErrorAction Stop
} catch {
    Write-Warning "Could not stop Tomcat9 service. Trying to stop using shutdown.bat..."
    if (Test-Path "$tomcatPath\bin\shutdown.bat") {
        & "$tomcatPath\bin\shutdown.bat"
    }
}

Write-Output "Creating deployment directories if they don't exist..."
if (-not (Test-Path $deployPath)) {
    New-Item -ItemType Directory -Force -Path $deployPath | Out-Null
}
if (-not (Test-Path $classesPath)) {
    New-Item -ItemType Directory -Force -Path $classesPath | Out-Null
}

Write-Output "Copying webapp files to deployment directory..."
Copy-Item -Path "src\main\webapp\*" -Destination $deployPath -Recurse -Force

Write-Output "Compiling Java files..."
$tomcatLib = Join-Path $tomcatPath "lib\*"
$mysqlLib = Join-Path $deployPath "WEB-INF\lib\mysql-connector-j-9.5.0.jar"
$classpath = "$tomcatLib;$mysqlLib"

$javaFiles = Get-ChildItem -Path "src\main\java" -Filter "*.java" -Recurse | ForEach-Object { $_.FullName }

if ($javaFiles.Count -eq 0) {
    Throw "No Java files found to compile!"
}

# Run javac
javac -d $classesPath -classpath $classpath $javaFiles

Write-Output "Starting Tomcat9 service..."
try {
    Start-Service -Name "Tomcat9" -ErrorAction Stop
    Start-Sleep -Seconds 2
    $status = Get-Service -Name "Tomcat9"
    Write-Output "Tomcat9 Service status: $($status.Status)"
} catch {
    Write-Warning "Could not start Tomcat9 service. Starting Tomcat using startup.bat..."
    if (Test-Path "$tomcatPath\bin\startup.bat") {
        & "$tomcatPath\bin\startup.bat"
        Write-Output "Tomcat started using startup.bat."
    } else {
        Throw "startup.bat not found at $tomcatPath\bin\startup.bat"
    }
}
