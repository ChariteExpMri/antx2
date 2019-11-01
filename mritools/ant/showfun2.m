
%%  #b displays secondary functions of the [ANT]-toolbox with hyperlinks for HELP and EDIT-MODE
%   click on the function-name in the command-window to show the function's help 
%   click on the [ed]-hyperlink to open this function

function showfun2
f={ 'mergexlsfiles'
    'xmakeJD_2d'};

f2={};

disp(' ');
% displaythat(2,f2)
displaythat(1,f)

function displaythat(modus,f)
format compact

f=sort(f);
f=cellfun(@(a) { [ strrep(a,'.m','')  '.m' ]  },f );

% disp(' ');
if modus==1
    col=[1 .3 0];
    col=['*[' num2str(col) ']'];
    cprintf(col,[' *** useful additional functions [' mfilename '] ***\n']);
    cprintf(col,'*******************************************************\n');
elseif modus==2
    col=[0.4667    0.6745    0.1882];
    col=['*[' num2str(col) ']'];
    cprintf(col,[' *** useful additional functions [' mfilename '] ***\n']);
    cprintf(col,'*******************************************************\n');
end
    

for i=1:size(f,1)
    % ff='antcb.m'
    ff=f{i};
    txt=help(ff);
    h1=txt(1:min(strfind(txt,char(10))));
    
do_help=['showfunhelp(' '''' ff '''' ')'];
do_edit=['edit(' '''' ff '''' ')'];

disp([...' f <a href="matlab:  '  do ' ">' ff '</a>'  ' :' strrep(h1,char(10),'')  ....
    '   <a href="matlab:  ' do_edit  ' ">' '[ed]' '</a>' ...
    '   <a href="matlab:  ' do_help  ' ">' ff '</a>' ...
    strrep(h1,char(10),'')
    ]);

    
%    disp([' f <a href="matlab:  '  'uhelp(g3(g2(g1(txt)),ff))'  ' ">' ff '</a>'  ' :' h1   ]);
%    disp([' f <a href="matlab:  '  '@dohelp(ff,h1, txt)'  ' ">' ff '</a>'  ' :' h1   ]);

end

 
