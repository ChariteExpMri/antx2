function [] = add_semicolon(fileName)
%# Find the lines where a given mlint warning occurs:

mlintIDinScript = 'NOPTS';                       %# The ID of the warning
mlintIDinFunction = 'NOPRT';
mlintData = mlint(fileName,'-id');       %# Run mlint on the file
index = strcmp({mlintData.id},mlintIDinScript) | strcmp({mlintData.id},mlintIDinFunction);  %# Find occurrences of the warnings...
lineNumbers = [mlintData(index).line];   %#   ... and their line numbers

if isempty(lineNumbers)
    return;
end;
%# Read the lines of code from the file:

fid = fopen(fileName,'rt');
%linesOfCode = textscan(fid,'%s', 'Whitespace', '\n\r');  %# Read each line
lineNo = 0;
tline = fgetl(fid);
while ischar(tline)
    lineNo = lineNo + 1;
    linesOfCode{lineNo} = tline;
    tline = fgetl(fid);
end
fclose(fid);
%# Modify the lines of code:

%linesOfCode = linesOfCode{1};  %# Remove the outer cell array encapsulation
linesOfCode(lineNumbers) = strcat(linesOfCode(lineNumbers),';');  %# Add ';'

%# Write the lines of code back to the file:

fim = fopen(fileName,'wt');
fprintf(fim,'%s\n',linesOfCode{1:end-1});  %# Write all but the last line
fprintf(fim,'%s',linesOfCode{end});        %# Write the last line
fclose(fim);