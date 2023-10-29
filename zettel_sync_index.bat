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

REM Loop through all subfolders in the Zettelkasten folder
for /d %%D in ("%zettelkasten_folder%\*") do (
    set "subfolder=%%~nD"
    
    rem Determine the appropriate index file for the subfolder
    set "index_file=!script_dir!index\!subfolder!.md"

    REM Create a temporary file to store the reversed notes for each subfolder
    set "temp_file=!script_dir!\temp_!subfolder!.md"
    echo. > "!temp_file"

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
      
        SET index_entry=-!date!- [!title!](/notes/!subfolder!/!note!.md)
        echo !index_entry! >> "!temp_file!"
    )

    rem Replace the original index file with the reversed content
    move /y "!temp_file!" "!index_file!" >nul 2>&1
    echo !index_file! updated.

    REM Delete the temporary file
    del "!temp_file"
)

endlocal
