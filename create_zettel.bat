@echo off
setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "script_dir=%~dp0"

REM Set the path to your Zettelkasten main folder (current directory)
set "zettelkasten_main_dir=!script_dir!"

REM Check if the Zettelkasten main folder exists
if not exist "%zettelkasten_main_dir%" (
    echo Zettelkasten main folder does not exist. Exiting.
    exit /b
)

REM Prompt for the numeric Zettelkasten note type (1 for fleeting, 2 for literature, 3 for permanent)
set /p note_type=Enter the Zettelkasten note type (1 for fleeting, 2 for literature, 3 for permanent): 

REM Map the numeric code to the actual note type
if !note_type! == 1 (
    set "note_type_name=Fleeting"
    set "note_subfolder=Fleeting"
    set "index_file=!zettelkasten_main_dir!\index\fleeting.md"
) else if !note_type! == 2 (
    set "note_type_name=Literature"
    set "note_subfolder=Literature"
    set "index_file=!zettelkasten_main_dir!\index\literature.md"
) else if !note_type! == 3 (
    set "note_type_name=Permanent"
    set "note_subfolder=Permanent"
    set "index_file=!zettelkasten_main_dir!\index\permanent.md"
) else (
    echo Invalid note type code. Exiting.
    exit /b
)

REM Prompt for the Zettelkasten note title
set /p title=Enter the Zettelkasten note title: 

REM Remove special characters from the title and replace them with underscores
set "title=!title:~0,100!"  REM Truncate the title if it's too long
set "title=!title:^!=!"
set "title=!title:&=!"
set "title=!title:|=!"
set "title=!title:\=!"
set "title=!title:/=!"
set "title=!title::=!"
set "title=!title:.=!"
set "title=!title:,=!"
set "title=!title:;=!"
set "title=!title:'=!"
set "title=!title:"=!"
set "title=!title:?=!"
set "title=!title:[=!"
set "title=!title:]=!"
set "title=!title:{=!"
set "title=!title:}=!"
set "title=!title:<=!"
set "title=!title:>=!"
set "title=!title:(=!"
set "title=!title:)=!"
set "title=!title:[=!"
set "title=!title:]=!"
set "title=!title:{=!"
set "title=!title:}=!"
set "title=!title:,=!"
set "title=!title:&=!"

REM Convert spaces to hyphens
set "title=!title: =-!"

REM Get the current date and time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "datetime=%%I"
set "timestamp=!datetime:~0,4!!datetime:~4,2!!datetime:~6,2!!datetime:~8,2!!datetime:~10,2!!datetime:~12,2!"

REM Get a human-readable date and time
set "human_readable_time=!timestamp:~0,4!-!timestamp:~4,2!-!timestamp:~6,2! !timestamp:~8,2!:!timestamp:~10,2!"

REM Define the filename with a .md extension and the path to the note
set "filename=!timestamp!-%title%.md"
set "note_path=!zettelkasten_main_dir!\notes\!note_subfolder!\!filename!"


REM Create the note file and add a timestamp and note type to the note as YAML front matter
echo ^--- >> "!note_path!"
echo Title: !title! >> "!note_path!"
echo Date: %human_readable_time% >> "!note_path!"
echo Type: %note_type_name% >> "!note_path!"
echo ^--- >> "!note_path!"
echo. >> "!note_path!"

REM Open the note in the default text editor (change 'notepad' to your preferred text editor)
start notepad "!note_path!"

REM Prepare a temporary file for reordering the index file
set "temp_file=!index_file!.tmp"
echo ## %human_readable_time% - [!title!](\notes\!note_subfolder!\!filename!) > "!temp_file!"
type "!index_file!" >> "!temp_file!"

REM Overwrite the original index file with the reordered content
move /y "!temp_file!" "!index_file!" > nul

endlocal