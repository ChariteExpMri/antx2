
%%  #b displays the main functions of the [ANT]-toolbox with hyperlinks for HELP and EDIT-MODE
%   click on the function-name in the command-window to show the function's help 
%   click on the [ed]-hyperlink to open this function
%  showfun/ showfun(dosort), where dosort=[0|1] to sort functions 

function showfun(dosort)
f={ 'ant'
    'antcb'
    'antfun'
    'ante' 
    'antsettings'
    'antver'
    'dtistat'
    'xcopyrenameexpand'
    'xcoreg'
    'xwarp3'
    'xbruker2nifti'
    'paramgui'
    'showfun'
    'showfun2'
    'xoverlay'
    'xdeform2'
    'xdeformpop'
    'xexport'
    'xgenerateJacobian'
    'xgetlabels4'
    'xgetlesionvolume'
    'xnewproject'
    'xmaskgenerator'
    'xdistributefiles'
    'xselect'
    'ximportdir2dir'
    'xreplaceheader'
    'xdeletefiles'
    'xrename'
    'antkeys' 
    'xstat_2sampleTtest'
    'xstat_anatomlabels'
    'xregister2d'
    'xextractslice'
    'watchfiles'
    'xstatlabels'
    'xstat'
    'xcalc'
    'xheadmanfiles'
    'xheadman'
    'xdicom2nifti'
    'xmergedirs'
    'xregisterCT'
    'manuorient3points'
    'getorientation'
};

f2={'xseldirs'
    'xselectfiles'
    };


if exist('dosort')==0
    dosort=1
end
if dosort==1
    f=sort(f);
end

disp(' ');
displaythat(2,f2);
displaythat(1,f);
disp([' show showfuns ordering by : <a href="matlab: showfun(0)">' '[date]' '</a> <a href="matlab: showfun">' '[alphabetical]' '</a>']);

function displaythat(modus,f)
format compact

% f=sort(f);
f=cellfun(@(a) { [ strrep(a,'.m','')  '.m' ]  },f );

% disp(' ');
if modus==1
    col=[1 .3 0];
    col=['*[' num2str(col) ']'];
    cprintf(col,' *** useful functions [showfun.m] ***\n');
    cprintf(col,'*************************************\n');
elseif modus==2
    col=[0.4667    0.6745    0.1882];
    col=['*[' num2str(col) ']'];
    cprintf(col,' *** useful subfunctions [showfun.m] ***\n');
    cprintf(col,'*************************************\n');
end
    

for i=1:size(f,1)
    % ff='antcb.m'
    ff=f{i};
    txt=help(ff);
    h1=txt(1:min(strfind(txt,char(10))));
    
     k=dir(which(ff)); 
     datemodif=k.date;
    
do_help=['showfunhelp(' '''' ff '''' ')'];
do_edit=['edit(' '''' ff '''' ')'];

disp([...' f <a href="matlab:  '  do ' ">' ff '</a>'  ' :' strrep(h1,char(10),'')  ....
    '<a href="matlab:  ' do_edit  ' ">' '[ed]' '</a>' ...
    ' <a href="matlab:  ' do_help  ' ">' ff '</a>' ...
    strrep(h1,char(10),'')...
      '    [# dT: ' datemodif ']' ...
      ]);

    
%    disp([' f <a href="matlab:  '  'uhelp(g3(g2(g1(txt)),ff))'  ' ">' ff '</a>'  ' :' h1   ]);
%    disp([' f <a href="matlab:  '  '@dohelp(ff,h1, txt)'  ' ">' ff '</a>'  ' :' h1   ]);

end

 
