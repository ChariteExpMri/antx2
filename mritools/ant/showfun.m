
%%  #b displays the main functions of the [ANT]-toolbox with hyperlinks for HELP and EDIT-MODE
%   click on the function-name in the command-window to show the function's help 
%   click on the [ed]-hyperlink to open this function
%  showfun/ showfun(dosort), where dosort=[0|1] to sort functions 

function varargout=showfun(dosort)
f={ 'ant'
    'antcb'
    'ante'
    'antfun'
    'antkeys'
    'antsettings'
    'antver'
    'dtistat'
    'getorientation'
    'manuorient3points'
    'paramgui'
    'showfun'
    'showfun2'
    'watchfiles'
    'xQAregistration'
    'xbruker2nifti'
    'xbrukerflattdatastructure'
    'xcalc'
    'xcalcSNRimage'
    'xcheckoverlay'
    'xcheckreghtml'
    'xcopyfiles'
    'xcopyfiles2'
    'xcopyimg2t2'
    'xcopytpm'
    'xcoreg'
    'xcoregmanu'
    'xcreateANOblanko'
    'xcreateGWC'
    'xcreateMaps'
    'xcreateTPMfromANO'
    'xcreatetemplatefiles'
    'xcreatetemplatefiles2'
    'xdeform'
    'xdeform2'
    'xdeformpop'
    'xdeletefiles'
    'xdicom2nifti'
    'xdistributefiles'
    'xdraw'
    'xdraw_caller'
    'xexcel2atlas'
    'xexport'
    'xextractslice'
    'xfastview'
    'xgenerateJacobian'
    'xgetlabels4'
    'xgetlesionvolume'
    'xgunzip2nifti'
    'xheadman'
    'xheadmanfiles'
    'ximport'
    'ximportAnalyzemask'
    'ximportdir2dir'
    'ximportnii_headerrplace'
    'xincidencemap'
    'xlsprunesheet'
    'xmakeJD_2d'
    'xmakeRGBatlas'
    'xmakebatch'
    'xmaskgenerator'
    'xmaskgenerator_old'
    'xmergedirs'
    'xmergemasks'
    'xmeta_1'
    'xnewgroupassignment'
    'xnewproject'
    'xnormalize'
    'xnormalizeElastix'
    'xnormalizeElastix__backup1'
    'xobj2nifti'
    'xoverlay'
    'xprepelastix'
    'xprepelastix_old'
    'xrealign'
    'xrealign_elastix'
    'xregister2d'
    'xregister2dapply'
    'xregisterCT'
    'xregisterexvivo'
    'xrename'
    'xrenamedir'
    'xrenamefile'
    'xreplaceheader'
    'xresizeAtlas'
    'xsegment'
    'xsegment_test'
    'xsegment_test2'
    'xsegmenttube'
    'xsegmenttubeManu'
    'xseldirs'
    'xselect'
    'xselectfiles'
    'xsplittubedata'
    'xstat'
    'xstat_2sampleTtest'
    'xstat_anatomlabels'
    'xstatlabels'
    'xvol3d'
    'xwarp3'
};

f2={'xseldirs'
    'xselectfiles'
    };


if exist('dosort')==0
    dosort=1;
end
if dosort==1
    f=sort(f);
end

if nargout==1
    outfun=[f;f2];
    varargout{1}=outfun;
    return
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

 
