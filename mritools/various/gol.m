% go to specific line in active editor
function gol(linenum)

v=matlab.desktop.editor.getActive;
v.goToLine(linenum);