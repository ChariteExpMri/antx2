
% function to convert an NIFTI-ATLAS to 4D-RGB-NIFTI file. This RGB-Atlas can be displayed for instance 
% via "MRIcroGL" (https://www.nitrc.org/projects/mricrogl)
% specifically for the Allen Brain atlas, the RGB-Atlas depicts the brain regions in the Allen Colors
% similar to http://atlas.brain-map.org/atlas#atlas=1
% 
% Please select the animal-folders in advance if you want to create RGB-NIFTIs from inside the animal-folders 
% 
% #ba __ INPUTS ________________
% inputfolder:  select the inputfolder here (1,2 or 3):
%            [1] template-folder .. if input Atlas, excelfile and nifti are located in the template-folder  
%            [2] animal folder   .. input NIFTI such as "ANO.nii" or "ix_ANO.nii" are located in the animal-folders 
%            [3] other folder    .. if input Atlas, excelfile and nifti are located somewhere else 
%            -default: [1]
% file:  NIFTI-file to select
%            -default: 'ANO.nii'
% excelfile:  NIFTI-file to select
%            -default: 'ANO.xlsx'
% outnameSuffix: suffix to add to the filename of the resulting NIFTI RGB-file
%            -default: '_RGB'
% 
% #ga __ BATCH ________________
% % __EXAMPLE-1___
% % create ANO-NIFTI file with original RGB-colors. Here the inputfolder is "1" therefore from the
% %  template-path the "ANO.nii" and its corresponding excelfile ('ANO.xlsx') are used to create the
% %  RGB-NIfti-file with suffix '_RGB': "ANO_RGB.nii" in the template-folder
% z=[];
% z.inputfolder   = [1];                            % % select the input mode: [1] template-folder, [2] animal folder, [3] other folder
% z.file          = 'ANO.nii';                      % % select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used
% z.excelfile     = 'ANO.xlsx';                     % % select correponding excelfile such as "ANO.xlsx"
% z.outnameSuffix = '_RGB';                         % % suffux to add to the filename of the resulting RGB-file (NIFTI)
% xmakeRGBatlas(1,z);
%
% % __EXAMPLE-2___
% % create RGB-NIFTI of the file 'ix_ANO.nii' (atlas warped back to animal's native space). 
% % For this the the inputfolder is set to "2" (animal-folder). The "ANO.nii" and its corresponding 
% % excelfile ('ANO.xlsx') are used from the template-path. For each selected animal the new RGB-NIFTI 
% % file is stored in the respective animals folder with suffix '_RGB': "ix_ANO_RGB.nii"
% z=[];                                                                                                                                                                                                                    
% z.inputfolder   = [2];                            % % select the input mode: [1] template-folder, [2] animal folder, [3] other folder                                                                                    
% z.file          = 'ix_ANO.nii';                   % % select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used                                                                            
% z.excelfile     = 'ANO.xlsx';                     % % select correponding excelfile such as "ANO.xlsx"                                                                                                                   
% z.outnameSuffix = '_RGB';                         % % suffux to add to the filename of the resulting RGB-file (NIFTI)                                                                                                    
% xmakeRGBatlas(1,z); 
% 
% #ba __ Command line ________________
% xmakeRGBatlas();     % % open GUI with default settings (i.e. make RGB-NIFTI from ANI.xls/nii of template-path and)
% xmakeRGBatlas(1,z);  % % open GUI with own settings 
% xmakeRGBatlas(0,z);  % % run with own settings without GUI

function xmakeRGBatlas(showgui, x)

if 0
   
end

% ==============================================
%%   
% ===============================================
global an
if isempty(an); 
   disp('load project first') ;
end
atlas=fullfile(fileparts(an.datpath),'templates', 'ANO.nii');
if exist(atlas)~=2
    atlas='';
end


%===========================================
%%    GUI
%===========================================
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'    'create RGB-colored-atlas'         ''               ''
    'inputfolder'    [1]          'select the input mode: [1] template-folder, [2] animal folder, [3] other folder' {1,2,3}
    'file'           'ANO.nii'    'select atlas-file (ANO.nii); if "ANO.nii", than the file from the templates-dir is used'          {  @selecteFile}
    'excelfile'      'ANO.xlsx'   'select correponding excelfile such as "ANO.xlsx"' {@selectexcelfile}
    'outnameSuffix'   '_RGB'      'suffix to add to the filename of the resulting NIFTI RGB-file'  ''
%     'outpath'   'ressources'      'output directory to save the RGB-atlas'  'd'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .4 .6 .2 ],...
        'title','create RGB-colored-atlas','info',{@uhelp, mfilename});
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
patemp=fullfile(fileparts(an.datpath),'templates');
if z.inputfolder==1
    fall=cellstr(fullfile(patemp, z.file));
    xls=(fullfile(patemp, z.excelfile));
elseif z.inputfolder==3
    fall=cellstr(z.file)
    [paoth name ext]=fileparts(z.excelfile);
    if isempty(paoth)
        paoth=fileparts(z.file);
    end
     xls= fullfile(paoth, [name ext] );
else %from animal-folders
    pa=cellstr(antcb('getsubjects'));
    fall=stradd(pa,[filesep, z.file] ,2);
     [paat name ext]=fileparts(z.excelfile);
    if isempty(paat)
        paat=patemp;
    end
     xls= fullfile(paat, [name ext] );
    
    
end
xls=char(xls);
    

% ==============================================
%%   now create RGB-image
% ===============================================
if exist(xls)~=2 
  error('excel-file does not exist!!...abort prcess');
end


for i=1:length(fall)
    f1=fall{i};
    if exist(f1)==2
        [pas name ext]=fileparts(f1);
        [~,animal]=fileparts(pas);
        % f1='F:\data5\nogui\templates\ANO.nii'
        [hb b]=rgetnii(f1);
        
       
        [~,~,a0]=xlsread(xls);
        a0=xlsprunesheet(a0);
        ha=a0(1,:);
        a=a0(2:end,:);
        
        tb=a(:,[4 3]);
        cc=makeRGBvol( b, tb );
        
        outdir=pas;
        if exist(outdir)~=7; mkdir(outdir); end
        f2=fullfile(outdir,[name z.outnameSuffix '.nii'] );
        rsaveniiRGB(f2 , hb, cc);
        showinfo2(['new RGB-NIFTI: [' animal ']'], f2);
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





