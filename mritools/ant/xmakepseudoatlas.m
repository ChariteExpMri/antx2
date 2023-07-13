
% create a pseudo-color NIFTI-atlas based on existing NIFTI-ATLAS (such as 'ANO.nii' or 'ix_ANO.nii')
% RATIONALE: 
% Some atlases as the Allen brain atlas use sparse IDs over a large dynamic range. This is sometimes not
% optimal for displaying atlas
% The new atlas uses the input NIFTI-file and create the a new NIFTI with consecutive IDs starting with index 1
% where Index-1 in the new atlas is the region with the lowest ID in the old atlas, 
%       Index-2 in the new atlas is the region with the 2nd lowest ID in the old atlas
%       etc...
% #r IMPORTANT: pseudo-atlases applied on inverse atlases (such as "ix_ANO.nii") might differ between animals.
% #r  Specifically the assigned IDs might differ because the field of view for animals in native space 
% #r  might differ (i.e. potentially some regions not aquired in some animals)
% 
% 
% Please select the animal-folders in advance if you want to create RGB-NIFTIs from inside the animal-folders 
% 
% #ba __ INPUTS ________________
% inputfolder:  select the inputfolder here (1,2 or 3):
%            [1] template-folder .. if input atlas (Nifti-file) is located in the template-folder  
%            [2] animal folder   .. if input atlas (Nifti-file) such as "ANO.nii" or "ix_ANO.nii" are located in the animal-folders 
%            [3] other folder    .. if input atlas (Nifti-file(s)) is/are located somewhere else 
%            -default: [1]
% file:  NIFTI-file to select
%            -default: 'ANO.nii'
% outnameSuffix: suffix to add to the filename of the resulting NIFTI-file
%            -default: '_pcol'
% 
% #ga __ BATCH ________________
% % __EXAMPLE-1___
% % create pseudo-atlas. Here the inputfolder is "1" thus the file "ANO.nii" is used from the
% %  template-path to create the pseudo-atlas with suffix "_pcol". The file "ANO_pcol.nii" is
% % stored in the templates folder
% z=[];                                                                                                                                                                  
% z.inputfolder   = [1];                                                      % % select the input mode: [1] template-folder, [2] animal folder, [3] other folder        
% z.file          = 'ANO.nii';                                                % % select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used
% z.outnameSuffix = '_pcol';                                                  % % suffix to add to the filename of the resulting NIFTI file                              
% xmakepseudoatlas(1,z); 
%% ===============================================
% % __EXAMPLE-2___
% % create pseudo-atlas. Here the inputfolder is "2" thus the file "ix_ANO.nii" is used from the
% %  pre-selected animals folders to create the pseudo-atlas with suffix "_pcol". The file "ix_ANO_pcol.nii" is
% % stored in each of the selected animal folders.
% z=[];                                                                                                                                                                  
% z.inputfolder   = [2];                                                      % % select the input mode: [1] template-folder, [2] animal folder, [3] other folder        
% z.file          = 'ix_ANO.nii';                                             % % select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used
% z.outnameSuffix = '_pcol';                                                  % % suffix to add to the filename of the resulting NIFTI file                              
% xmakepseudoatlas(1,z);
%% ===============================================
% % __EXAMPLE-3___
% % create pseudo-atlas. Here the inputfolder is "3" and the list of files (here "ANO.nii") 
%% is used to create the pseudo-atlas with suffix "_pcol". New files are created in the respective folders
% z=[];                                                                                                                                                                                          
% z.inputfolder   = [3];                                                                              % % select the input mode: [1] template-folder, [2] animal folder, [3] other folder        
% z.file          = {'F:\generate_anttemplates\ADMBA_P28\test2_withNewTemplate\templates\ANO.nii'
%                     'F:\generate_anttemplates\ADMBA_P28\test2_withNewTemplate\dat\m11\ANO.nii'};     % % select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used
% z.outnameSuffix = '_pcol';                                                                          % % suffix to add to the filename of the resulting NIFTI file                              
% xmakepseudoatlas(1,z); 
% 
% 
% #ba __ Command line ________________
% xmakepseudoatlas();     % % open GUI with default settings (i.e. make pseudo-atlas using "ANO.nii" from template-path )
% xmakepseudoatlas(1,z);  % % open GUI with own settings 
% xmakepseudoatlas(0,z);  % % run with own settings without GUI

function xmakepseudoatlas(showgui, x)

if 0
   
end

% ==============================================
%%   
% ===============================================
global an
if isempty(an); 
    if x.inputfolder~=3
        disp('load project first') ;
        return
    end
end
% atlas=fullfile(fileparts(an.datpath),'templates', 'ANO.nii');
% if exist(atlas)~=2
%     atlas='';
% end


%===========================================
%%    GUI
%===========================================
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'    'create pseudo-colored-atlas (dispaly purpose only)'         ''               ''
    'inputfolder'    [1]          'select the input mode: [1] template-folder, [2] animal folder, [3] other folder' {1,2,3}
    'file'           'ANO.nii'    'select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used'          {  @selecteFile}
   % 'excelfile'      'ANO.xlsx'   'select correponding excelfile such as "ANO.xlsx"' {@selectexcelfile}
    'outnameSuffix'   '_pcol'     'suffix to add to the filename of the resulting NIFTI file'  ''
%     'outpath'   'ressources'      'output directory to save the RGB-atlas'  'd'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .4 .6 .2 ],...
        'title','create pseudo-colored-atlas','info',{@uhelp, mfilename});
    if isempty(m);return; end
else
    z=param2struct(p);
end


%===========================================
%%   RUN
%===========================================
cprintf([1 0 1],['wait... [' mfilename '.m]'    '\n' ]);
xmakebatch(z,p, mfilename)
process(z);
cprintf([1 0 1],['done... '    '\n' ]);

%===========================================
%%   process
%===========================================
function process(z);




% ==============================================
%%   
% ===============================================

global an
if ~isempty(an)
    patemp=fullfile(fileparts(an.datpath),'templates'); %from template folders
end
if z.inputfolder==1
    fall=cellstr(fullfile(patemp, z.file));
elseif  z.inputfolder==2                  %from animal-folders
    pa=cellstr(antcb('getsubjects'));
    fall=stradd(pa,[filesep, z.file] ,2);  
elseif z.inputfolder==3                   % from other folders
    fall=cellstr(z.file);
end
% file=char(file);
fall=cellstr(fall)  ; 

% ==============================================
%%   now create RGB-image
% ===============================================
% if exist(file)~=2 
%   error('NIFTI-file does not exist!!...abort prcess');
% end


for i=1:length(fall)
    f1=fall{i};
    if exist(f1)==2
        [pas name ext]=fileparts(f1);
        [~,animal]=fileparts(pas);
        % f1='F:\data5\nogui\templates\ANO.nii'
        [hb b]=rgetnii(f1);
        
        uni=unique(b); 
        uni(uni==0)=[];
        
        b2=zeros([numel(b) 1]);
        for i=1:length(uni)
           b2( b==uni(i))=i;
        end
        b2=reshape(b2,hb.dim);
        
        
        outdir=pas;
        if exist(outdir)~=7; mkdir(outdir); end
        f2=fullfile(outdir,[name z.outnameSuffix '.nii'] );
        rsavenii(f2 , hb, b2,64);
        showinfo2(['new pseudo-color NIFTI: [' animal ']'], f2);
        
        
        
%         [~,~,a0]=xlsread(xls);
%         a0=xlsprunesheet(a0);
%         ha=a0(1,:);
%         a=a0(2:end,:);
%         tb=a(:,[4 3]);
%         cc=makeRGBvol( b, tb );
%         
%         outdir=pas;
%         if exist(outdir)~=7; mkdir(outdir); end
%         f2=fullfile(outdir,[name z.outnameSuffix '.nii'] );
%         rsaveniiRGB(f2 , hb, cc);
%         showinfo2(['new RGB-NIFTI: [' animal ']'], f2);
    else
       disp([' file not found: ' f1 ]) ;
    end 
end

% ==============================================
%%   sub funs
% ===============================================
function he=selectexcelfile(e,e2)
he='ANO.xlsx';
[t,sts] = spm_select(1,'any','select corresponding Excel-file (such as "ANO.xlsx")','',pwd,'.*.xlsx','');
if t==0; he='';
else;    he=(t);
end


function he=selecteFile(e,e2)
he='ANO.nii';
global an;
[x1,x2]= paramgui('getdata');
if x2.inputfolder==1   %template folder
    pat=fullfile(fileparts(an.datpath),'templates');
    [t,sts] = spm_select(1,'any','select ATLAS (NIFTI) such as "ANO.nii" file','',pat,'.*.nii','');
    if isempty(t); return; end
    [px name ext]=fileparts(t);
    he=[name ext];
elseif x2.inputfolder==3 %any folder
    pat=fullfile(fileparts(an.datpath));
    [t,sts] = spm_select(1,'any','select ATLAS (NIFTI) such as "ANO.nii" file','',pat,'.*.nii','');
    if isempty(t); return; end
    he=char(t);
else
    pa=antcb('getsubjects');
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
     s=selector2(li,{'file'},'out','list','selection','single');
     he=char(s);
end





