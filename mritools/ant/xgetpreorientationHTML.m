% #wb xgetpreorientationHTML: create HTML-document with pre-orentations of the source-file
% AIM: function creates a HTML-file in the study's 'checks'-folder containing
%   different pre-orientations between a source-file and a target-file
%  For example between the 't2.nii' (native space) and 'AVGT.nii' of the standard-space
% you can use the respective rotationTable-Index (single numeric value in brackets [ ] from HTMLfile) or
% the three rotation-values ('rotX rotY rotZ') from HTMLfile.
% 
% #lk pre-orientation from native-space to standard-space  
% For the pre-orientation from native-space to standard-space you have to use:
% z.target       = 't2.nii'; 
% z.source       = the 'AVGT.nii' from the study's template-folder
% This is the default setting in the parameter-GUI, i.e. no changes needed..just click [Run]
% 
% AFTERWARDS, when pre-orientation is determined: 
% change the ANTx-projectfile (proj.m): specify variable [x.wa.orientType] either :
%     - as numeric value, i.e. the rotationTable-Index (single numeric value in brackets [ ] from HTMLfile)
%     - as string, containing the three rotation-values ('rotX rotY rotZ') from HTMLfile
% when done, update the ANTx-GUI via : antcb('reload') or reload the project-file
% 
% 
% 
% #ka    EXAMPLES   
% #b Example-1: without GUI  : get-pre-orientatin native-to-standardSpace
% z=[];                                                                                                                    
% z.target       = 't2.nii';                                         % % reference image         
% z.source       = 'F:\data8_MPM\MPM_agBrandt3\templates\AVGT.nii';  % % source image            
% z.outputstring = 'Reorient';                                       % % prefix of HTML-fileName 
% xgetpreorientationHTML(0,z);                                       % %  execute function
% 
% #b Example-2: Check if two files in the selected mouse-folder have the same orientation
% z=[];                                                                                                                                                                                                 
% z.target       = 'MT.nii';     % % reference image                                                                                                                                                  
% z.source       = 'PD.nii';     % % source image                                                                                                                                                     
% z.outputstring = 'sameOrient'; % % prefix of HTML-fileName                                                                                                                                          
% xgetpreorientationHTML(1,z);                                                                                                                                                                          
%                                
% #b Example-3: without GUI, use "ANO.nii" as targetImage and use external mouse-folder
% xgetpreorientationHTML(0,struct('source','t2.nii','target', 'F:\data8_MPM\MPM_agBrandt3\templates\ANO.nii'),{'F:\data8_MPM\MPM_agBrandt3\dat\20220725AB_MPM_18-9_DTI_T2_MPM'});
% 
% #ka     CMDline    
% xgetpreorientationHTML(1);   % show GUI  ..same as xgetpreorientationHTML
% xgetpreorientationHTML(1,z); % show GUI with parameters defined in z
% xgetpreorientationHTML(0,z); % no GUI, use parameters defined in z
%
% #ka    Batch    
% -when executed the command is stored in the 'anth'-history variable
% type char(anth) to visualize/ modify/re-use the commands
% 
% 
% 



function xgetpreorientationHTML(showgui,x,pa)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui  =1               ;end
if exist('x')==0                           ;    x        =[]              ;end
if exist('pa')==0      || isempty(pa)      ;    pa       =[]              ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x        =[]  ;
end

if isempty(pa)
    pa=antcb('getsubjects');
end
[tb tbh v]=antcb('getuniquefiles',pa);


% ==============================================
%%   get preorientation
% ===============================================
f1=fullfile(pa{1},'t2.nii');
f2=fullfile(fileparts(fileparts(pa{1})),'templates','AVGT.nii');

if exist('x')~=1;        x=[]; end

p={...
    'inf1'     [ '_create HTML-file with pre-orientations of source-file(' mfilename '.m)']                         '' ''
    'target'      f1                    'reference image'        {@dialog_whichpath,v,'x.target'} %    {@selectFile,v}
    'source'      f2                    'source image'           {@dialog_whichpath,v,'x.source'} %    {@selectFile,v}
    'inf2'       ''      '' ''
    'inf3'       'other inputs'      '' ''
    'outputstring'   'Reorient'  'prefix of HTML-fileName' {'Reorient' 'pre-align'}
    };
p=paramadd(p,x);




% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .3 ],...
        'title',['***'  mfilename '***'],'info',{@uhelp,[ mfilename '.m']});
    try
        fn=fieldnames(z);
    catch
        return
    end
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%% =====[batch]==========================================
xmakebatch(z,p, mfilename)

%% =====[proc]==========================================

pa=cellstr(pa);
% for i=1:length(pa)
process( pa{1}, z);
% end

return


function process( pa, z);
%% ===============================================

f1=char(z.source);   % SOURCE   .. 't2w.nii');
f2=char(z.target);   % REFIMAGE .. 't1_fistIMG_001.nii');
[pa1 name1 ext1]=fileparts(f1);
[pa2 name2 ext2]=fileparts(f2);

if isempty(pa1)
    f1=fullfile(pa,[name1 ext1]);
end
if isempty(pa2)
    f2=fullfile(pa,[name2 ext2]);
end

if exist(f1)==2 && exist(f2)==2
    cprintf('*[0 .5 0]',[ 'Create HTML-file please inspect [checks]-folder'   '\n'] );
    % getorientationHtml(f1,f2);
    htmlfile=getorientationHtml(f1,f2,'outputstring',z.outputstring);
else
    %% ===============================================
    cprintf('*[1 0 1]',[ 'Could not create HTML-file, reason: '   '\n'] );
    if exist(f1)~=2
        disp(['..file not found: ' f1]);
    end
    if exist(f2)~=2
        disp(['..file not found: ' f2]);
    end
   %% ===============================================
   
    
end
%% ===============================================





return
%% ===============================================



%% ===============================================
cprintf('*[0 0 1]',[ 'GET PREORIENTATION'  '\n'] );
cprintf('[0 0 1]',[ 'set the 3 landmarks in each volume.'  '\n'] );
cprintf('[0 0 1]',[ 'When done, select MRICRON from pulldown and click [check]-button to inspect the overlay.'  '\n'] );
cprintf('[0 0 1]',[ 'If the overlay is "ROUGHLY" OK, hit [CLOSE]-button.'  '\n'] );
%% ===============================================

p.f1=f1n;
p.f2=f2n;
p.info=''; % info
p.info='';
p.showlabels=0;
p.wait=1;              % busy mode
manuorient3points(p);  % execute function
%% ===============================================


if do_delete==1
    for i=1:length(delfiles)
        delete(delfiles{i})
    end
end

%% ===============================================
%  1.2246e-16 -1.2246e-16 -3.1416
% [0 0 -3.1416]


% cprintf('*[0 0 1]',[ 'Insert the three "ROTATON"-values in the "xcoreg"-preorientation-field'  '\n'] );
% showinfo2(['mpm-config file:' ],mpm.mpm_configfile);

%% ===============================================


% if 0
%     %% ___SUBS_____________________________________________________________________________________________
%     function out=selectFile(v)
%     out='';
%     %  sdirs=antcb('getsubjects')
%     % [tb tbh v]=antcb('getuniquefiles',sdirs);
%     he=selector2(v.tb,v.tbh, 'out','col-1','selection','single');
%     if isempty(he) || (isnumeric(he) && he==-1);
%         out=[];
%     else
%         out=he;
%     end
%     % paramgui('setdata','x.reorienttype','[]')
%   end

function out=dialog_whichpath(v,task)
out='';


%% ============[quest-DLG]===================================

op=struct('WindowStyle','modal','Interpreter','tex','Default','AnimalDir');
msg={
    ['\color{black}\bf Please specify FILE-PATH of '  '\color{blue}'  task '\rm'   ]
    '\color{blue}[AnimalDir] : \color{black} from study''s animal-folder'
    '\color{blue}[other path]: \color{black} from other path'
    };
answer = questdlg(msg,['FILE-PATH ' ],...
    'AnimalDir','other path',op);

if strcmp(answer,'AnimalDir')
    he=selector2(v.tb,v.tbh, 'out','col-1','selection','single','title',['Select file as "'  task  '"']);
    if isempty(he) || (isnumeric(he) && he==-1);
        out=[];
    else
        out=char(he);
    end
else
    %% ===============================================
    patemp='';
    try
        global an
        patemp=fullfile(fileparts(an.datpath),'templates');
        if exist(patemp)~=7
            patemp=fullfile(fileparts(an.datpath));
        end
    catch
        patemp=pwd;
    end
    
    [t,sts] = cfg_getfile2(1,'any',{['Select file as "'  task  '"']},[],patemp,'nii',1);
    he=char(t);
    if isempty(he) || (isnumeric(he) && he==-1);
        out=[];
    else
        out=char(he);
    end
    
    %% ===============================================
    
end
%% ===============================================






