
% import files to dat-structure
function ximport(showgui,varargin )

% function ximport(showgui,varargin )
%% INPUT
% showgui  : [0,1] no,yes,  open gui 
% optional :varargin 
% varargin: pairwise parametersettings (name + data)
%  currently implemented imput
%    <params>  with <s>   ...where params is the strunct fieldname and <s> is th struct with optinal parmaters from th list 
%   for parameters of <s> type  ximport without inputs to see list of inputparameters
%        
% type ximport without inputs to see list of inputparameters
%% see parameter list
% ximport   ;%see parameter list
%% example with GUI
% ximport(1) ; %open gui with default params
%% example2  with/without GUI vut with predefined parameters  
%   s=[]
%     s.files={ 'O:\Processing_dti\20160623HP_M37\20160623HP_M37_reg_dsiStudio.nii'
%         'O:\Processing_dti\20160623HP_M40\20160623HP_M40_reg_dsiStudio.nii'}
%     s.targetDir ='c:\mist\dat'
%     ximport(1,'params',s );  use this parameters from <s> & open GUI
%      ximport(0,'params',s ); use this parameters from <s> but do not show GUI



if 0
    s=[]
    s.files={ 'O:\Processing_dti\20160623HP_M37\20160623HP_M37_reg_dsiStudio.nii'
        'O:\Processing_dti\20160623HP_M40\20160623HP_M40_reg_dsiStudio.nii'}
    s.targetDir ='c:\mist\dat'
    ximport(1,'params',s );
end


try
    global an;
    pamain=an.datpath;
catch
    pamain=pwd;
end

%% import 4ddata
p={...
    'inf98'      '*** IMPORT DATA                 '                         '' ''
    'inf100'     '==================================='                          '' ''
    'inf1'      '% PARAMETER         '                                    ''  ''
    'files'      ''                                                           'files to import <required to fill>'  'mf'
    'targetDir'      pamain                                                       'data target path (datpath): folder were all mouse dirs with data will be generated '  'd'
    'createDir'            1                                                   'create mouse directories based on filename ,[0,1] '  'b'
    'keepSubDirStructure'  1                                                   'use existing subdirectory structure from filenames to create directory names [0,1] '  'b'
    'imageNum'             1                                                   'import volume-Number in 4Dim volume '        {1 inf 'end' 'end-1'}
    'inf2'      '% IMPORT ONE OR SEVERAL FILES TO EACH MOUSE DIR        '                                    ''  ''
    'clipFileName'          0                                                   'should file names be clipped/shortend by "clipFileNameString" '  'b'
    'clipFileNameString'  ''                                                    'this string is clipped from file names '  {'mask' '_reg_dsiStudio'}
    'inf3'      '% IMPORT EXACTLY ONE FILE TO EACH MOUSE DIR      '                                    ''  ''
    'rename'  ''                                                    ' <filename string without extention> rename file, this works if only one file is copied per dir'  {'mask' 'raw' 'test'}
    };
%show parameter
if nargin==0;
    pinfo={};
    for i=1:size(p,1)
        var=p{i,1}; if regexpi(var,'^inf\d'); var=''; else;  var=sprintf('%s\t\t\t' ,[var ': ' ]  ) ;end
        if isempty(var);des=p{i,2};defaults='@@' ; else  ; des=p{i,3};defaults=  p{i,2}    ;end
        if isnumeric(defaults); defaults=num2str(defaults);end
        if isempty('defaults'); defaults='''';end
         if strcmp(defaults,'@@'); defaults='';
             defaults='';
         else
             defaults=['(default: ' defaults ')'];
%         if ~strcmp(defaults,'_'); default=['(default: ' defaults ')'];else;default='';end
         end
        
       pinfo{i,1}=[var des  defaults] ;
    end
    disp('*** STRUCT WITH PARAMETERS ***');
   disp(char( pinfo));
   return;
end



if  exist('showgui')~=1 ; showgui=1; end
%% additional parameters
para=struct();
if ~isempty(varargin)
    if length(varargin)==1
        para=varargin{1};
    else
    para=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    end
end

p=paramadd(p,para);%add/replace parameter



 if isfield(para,'params') %%&& strcmp(getfield(para,'parameter'),'default') ==1
    p0=para.params;
    fn=fieldnames(p0);
    for i=1:length(fn)
        is=regexpi2(p(:,1),['^' fn{i} '$' ]);
        if ~isempty(is)
            p{is,2}=getfield(p0,fn{i});
        end
    end
end


%% show gui
if showgui==1
     hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z a params]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .8 .6 ],...
        'title','import','pb1string','OK','info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
%     z=[];
%     for i=1:size(p,1)
%         eval(['z.' p{i,1} '=' 'p{' num2str(i) ',2};']);
%     end
    z=param2struct(p);
end

xmakebatch(z,p, mfilename); % ## BATCH


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% test-data
% 
% z.files={ 'O:\Processing_dti\20160623HP_M36\20160623HP_M36_reg_dsiStudio.nii' 	% files used for calculation
%     'O:\Processing_dti\20160623HP_M37\20160623HP_M37_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160623HP_M40\20160623HP_M40_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160623HP_M41echt\20160623HP_M41echt_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160623HP_M42echt\20160623HP_M42echt_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160623HP_M43\20160623HP_M43_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160624HP_M38\20160624HP_M38_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160624HP_M39\20160624HP_M39_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160624HP_M44\20160624HP_M44_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160624HP_M45\20160624HP_M45_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M36\20160706HP_M36_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M37\20160706HP_M37_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M38\20160706HP_M38_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M39\20160706HP_M39_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M40\20160706HP_M40_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M41\20160706HP_M41_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M42\20160706HP_M42_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M43\20160706HP_M43_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M44\20160706HP_M44_reg_dsiStudio.nii'
%     'O:\Processing_dti\20160706HP_M45\20160706HP_M45_reg_dsiStudio.nii' }



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
pamain=z.targetDir;

for i=1:length(z.files)
    f1=z.files{i};
    [pa fi ext]=fileparts(f1);
    name=[fi ext];
    if z.createDir==1
        if z.keepSubDirStructure==1
            sub=pa(max(strfind(pa,filesep))+1:end);
            pa2=fullfile(pamain,sub);
            mkdir(pa2);
        end
    end
    
    %% clip file name
    name2=name;
    if z.clipFileName==1
        name2=strrep(name2,z.clipFileNameString,'' ); %clip name
    end
    %% rename file
    if ~isempty(z.rename)
        name2=[z.rename ext];
    end
    
    % 4D if not all volumes copied (i.e. z.imageNum=inf)
    if strcmp(ext,'.nii') && ~any(isinf(z.imageNum))
        [ha a]   =rgetnii(f1); %MASKexr
        if isnumeric(z.imageNum)
            hb=ha(z.imageNum);
            b=a(:,:,:,z.imageNum);
        else %used if z.imageNum is 'end' or 'end-1' or '3:7' or '3:end-1' ...
            eval(['hb=ha(' z.imageNum ');']);
            eval(['b=a(:,:,:,' z.imageNum ');']);
        end
        rsavenii(fullfile(pa2,name2) ,hb,b);
    else
        copyfile(f1, fullfile(pa2,name2));
    end
    
    %% make root information
    if exist(fullfile(pa2,'roots.mat'))~=2
        roots={};
        save(fullfile(pa2,'roots'),'roots');
    end
    load(fullfile(pa2,'roots'));
    roots(end+1,:)={ f1 fullfile(pa2,name2)};
    save(fullfile(pa2,'roots'),'roots');
    
    %% MSG
    %disp(['..import: '  fullfile(pa2,name2) ]);
    [~, ID]=fileparts(pa2);
    showinfo2(['..new file in ["' ID '"]:'],fullfile(pa2,name2))
    
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% %% coder
% % disp('        ');
% hh={};
% hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
% hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
% hh{end+1,1}=('%    ..copy/evaluate the this section');
% hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
% hh=[hh; struct2list(z)];
% hh(end+1,1)={[mfilename '(' '1', ',''params''' ,',z' ')' ]};
% % disp(char(hh));
% uhelp(hh,1);
% 





























