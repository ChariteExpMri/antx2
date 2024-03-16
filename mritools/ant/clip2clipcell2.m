

%% convert clipboard files-names (from matlab commandwidow) to matlab-cellstring
%% ...put it back to clipboard
% ---no input /no output ..only content in clipboard changed
% WORKS ONLY FOR FILES WITHOUT SPACES IN FILENAME !!!
% usage: 
% 1) get items in workspace:  dir *.nii
% 2) copy to clipboard
% 3) run  clip2clipcell2


% mat2clip(s.folder);

function clip2clipcell2

a=clipboard('paste');
a2=strsplit2(a,char(32))';
% a2=sort(a2);
a2(cellfun(@isempty,a2))=[];
a2(strcmp(a2,'.'))=[];
a2(strcmp(a2,[char(10) char(46) char(46)]))=[]; %'..'
ro =['{' ; cellfun(@(a) {[ ' ''' a '''']},a2); '};'];
ro=regexprep(ro,char(10),'');
mat2clip(ro);



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

