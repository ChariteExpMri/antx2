
% split string into tokens separated by delim
% if no delimiter is given, white space characters are used as delimiters
% syntax: Tokens = strsplit(Delim, String)

function Tokens = strsplit2(String, Delim)

Tokens = [];

while (size(String,2) > 0)
    if isempty(Delim)
         [Tok, String] = strtok(String);    
    else
        [Tok, String] = strtok(String, Delim);    
    end
    Tokens{end+1} = Tok;
end