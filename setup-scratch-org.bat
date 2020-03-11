@ECHO OFF
REM This script creates a scratch org, pushes the project into it,
REM assigned the permission sets and creates the named credentials.
REM Finally it opens the created scratch org in a new browser window.
REM Use it to speed up scratch org development!

IF %1.==. GOTO:FEHLER
IF %2.==. GOTO:FEHLER

ECHO Create the scratch org
CALL sfdx force:org:create -a %1 -v %2 -n -f config/project-scratch-def.json

ECHO Push all sources within manifest (DOES NOT CONTAIN named credential!)
CALL sfdx force:source:deploy -u %1 -x manifest/package.xml

ECHO Assign the permission set
CALL sfdx force:user:permset:assign -u %1 -n "Corona_Statistics"

ECHO Create named credentials
CALL sfdx force:source:deploy -u %1 -m NamedCredential:Corona_API

ECHO Open the org
CALL sfdx force:org:open -u %1

ECHO Ready creating Scratch org %1

GOTO:EOF

:FEHLER
ECHO Please provide a name of the new scratch org as FIRST parameter and the DevHub alias as SECOND parameter!