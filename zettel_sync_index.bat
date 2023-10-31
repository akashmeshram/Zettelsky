@echo off
setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "script_dir=%~dp0"

REM Set the path to your Zettelkasten folder
set "zettelkasten_folder=!script_dir!\notes"

REM Check if the Zettelkasten folder exists
if not exist "%zettelkasten_folder%" (
    echo Zettelkasten folder does not exist. Exiting.
    exit /b
)

set "index_fleeting=!script_dir!index\fleeting.md"
set "index_fleeting_temp=!script_dir!index\fleeting_temp.md"

set "index_literature=!script_dir!index\literature.md"
set "index_literature_temp=!script_dir!index\literature_temp.md"

set "index_permanent=!script_dir!index\permanent.md"
set "index_permanent_temp=!script_dir!index\permanent_temp.md"

REM delete if exists
del "!index_fleeting!" >nul 2>&1
del "!index_fleeting_temp!" >nul 2>&1

del "!index_literature!" >nul 2>&1
del "!index_literature_temp!" >nul 2>&1

del "!index_permanent!" >nul 2>&1
del "!index_permanent_temp!" >nul 2>&1

REM Loop through all subfolders in the Zettelkasten folder
for /d %%D in ("%zettelkasten_folder%\*") do (
    set "subfolder=%%~nD"
    
    rem Determine the appropriate index file for the subfolder
    set "index_file=!script_dir!index\!subfolder!.md"
    echo. > "!index_file!"

    set "temp_file=!script_dir!index\!subfolder!_temp.md"

    rem Loop through the Zettelkasten notes in the subfolder and reverse their order
    for %%I in ("%%~fD\*.md") do (
        @REM Read front matter from the note and extract keys date and title
        set "note=%%~nI"
        set "note_type="
        set "date="
        set "title="
        for /f "tokens=1,* delims=:" %%A in ('findstr /b "type date title" "%%~fI"') do (
            if "%%A" == "type" set "note_type=%%B"
            if "%%A" == "date" (
                set "date=%%B"
            )
            if "%%A" == "title" (
                set "title=%%B"
                set "title=!title:~1,-1!"  REM Remove leading and trailing spaces
            )
        )
      
        SET index_entry=-!date!- [!title!](/notes/!subfolder!/!note!.md^)
        echo !index_entry! >> "!temp_file!"
    )
)

REM Replace the original index file with the reversed content
sort /r "!index_fleeting_temp!" > "!index_fleeting!" 
echo !index_fleeting! updated.

sort /r "!index_literature_temp!" > "!index_literature!" 
echo !index_literature! updated.

sort /r "!index_permanent_temp!" > "!index_permanent!" 
echo !index_permanent! updated.

REM Delete the temporary file
del "!index_fleeting_temp!" >nul 2>&1
del "!index_literature_temp!" >nul 2>&1
del "!index_permanent_temp!" >nul 2>&1

endlocal