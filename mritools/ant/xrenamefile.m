

function xrenamefile(showgui,varargin )
% rename/copy files within ANT-data structure 
%   with options - select image(s) from 4d vol 
%                - reorient image(s)
%                - delete source file(s)
%                + with/without GUI
% function xrenamefile(showgui,varargin )
%% INPUT
% showgui  : [0,1] no,yes,  open gui 
% optional :varargin 
% varargin: pairwise parametersettings (name + data)
%  currently implemented input
%    <params>  with <s>   ...where params is the struct name and <s> is the struct with parmaters that override 
% the default parameters (for a parameter list type this function without inputs arguments)
%        
% type this function without inputs to get a list of input parameters
% note: input parameters override default parameters, others has to be defined
%% see parameter list
%    xrenamefile   ;%see parameter list
%% example with GUI
%     xrenamefile(1) ; %open gui with default params
%% example2  with GUI and predefined parameters
%     x.files={ 'O:\data\dtiSusanne\analysis\dat\20160623HP_M36\20160623HP_M36_reg_dsiStudio.nii' 	% files to be renamed <required to fill>
%         'O:\data\dtiSusanne\analysis\dat\20160623HP_M37\20160623HP_M37_reg_dsiStudio.nii'    };
%     x.imageNum=     [1];	% import volume-Number in 4Dim volume {examples:  a number, inf (import all images), 'end' (use last vol), 'end-1' (use penultimate vol) }
%     x.renameString= 't2';	%  <filename string without extention> rename file, this works if only one file is copied per dir
%     x.reorient=[0 0 0 0 0 0 1 -1 1]	;%  <9 lement vector> reorient volume, default: [] (do nothing); nb: [0 0 0 0 0 0 1 -1 1] is for DTIstudio
%     xrenamefile(1,'params',x)
%% example3  without GUI and predefined parameters (see example-2)
%     xrenamefile(0,'params',x)


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% test-data
% 
if 0
    x.files={ 'O:\data\dtiSusanne\analysis\dat\20160623HP_M36\20160623HP_M36_reg_dsiStudio.nii' 	% files to be renamed <required to fill>
        'O:\data\dtiSusanne\analysis\dat\20160623HP_M37\20160623HP_M37_reg_dsiStudio.nii'
        };
    x.imageNum=     [1];	% import volume-Number in 4Dim volume {examples:  a number, inf (import all images), 'end' (use last vol), 'end-1' (use penultimate vol) }
    x.renameString= 't2';	%  <filename string without extention> rename file, this works if only one file is copied per dir
    x.reorient=[0 0 0 0 0 0 1 -1 1]	;%  <9 lement vector> reorient volume, default: [] (do nothing); nb: [0 0 0 0 0 0 1 -1 1] is for DTIstudio
    xrenamefile(1,'params',x)
    
end

 


% try
%     global an;
%     pamain=an.datpath;
% catch
%     pamain=pwd;
% end

%% import 4ddata
p={...
    'inf98'      '*** RENAME FILES                 '                         '' ''   %    'inf1'      '% PARAMETER         '                                    ''  ''
    'inf100'     '==================================='                          '' ''
    'files'            ''           'files to be renamed <required to fill>'  'mf'
    'imageNum'         1            'import volume-Number in 4Dim volume {examples:  a number, inf (import all images), ''end'' (use last vol), ''end-1'' (use penultimate vol) } '        {1 inf 'end' 'end-1'}
    'renameString'     ''           'new file name (without extention), this works if only one file is copied per dir'  {'mask' 'raw' 'test'}
    'prefixDirName'    0            'adds mouse Dir/folder name as prefix to the new filename'                          'b' 
    'reorient'         ''           ' <9 lement vector> reorient volume, default: []: do nothing; (nb: use [0 0 0 0 0 0 1 -1 1] if data came from DSIstudio)'  {'0 0 0 0 0 0 -1 1 1';'0 0 0 0 0 0 1 -1 1'; '0 0 0 0 0 0 -1 -1 1'}
    'deleteSourceFile' 0            'delete source files [0,1] -->WARNING: the source files will be removed'  'b'
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
    
    eval(['help ' mfilename]);
    disp('__________________________________________________________________________________________');
    disp([' INPUT PARAMETERS of ' mfilename ' (must be arranged as struct) ***' ]);
   disp(char( pinfo(2:end)));
   return;
end



if  exist('showgui')~=1 ; showgui=1; end
%% additional parameters
para=struct();
if ~isempty(varargin)
    para=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
end





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
    [m z a params]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .8 .6 ],...
        'title','SETTINGS','pb1string','OK');
else
    z=[];
    for i=1:size(p,1)
        eval(['z.' p{i,1} '=' 'p{' num2str(i) ',2};']);
    end
    
end




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if ischar(z.files); z.files=cellstr(z.files); end
if isempty(z.files); return; end

for i=1:length(z.files)
    f1=z.files{i};
    [pa fi ext]=fileparts(f1);
    pa2=pa;
    
    f2=fullfile(pa2,[z.renameString ext]);
 
    
    %add foldername
    if z.prefixDirName==1
        [~,subdir,~]= (fileparts(pa2)) ;
        f2=fullfile(pa2,[subdir '_' z.renameString ext]);
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
        
        %% write volume
        for j=1:size(hb,1)
            hb(j).fname=f2;
            hb(j).n=[j 1]
            spm_create_vol(hb(j));
            spm_write_vol(hb(j),b(:,:,:,j));
        end
        try; delete( strrep(f2,'.nii','.mat')  ) ;     end
        
        
    else
        copyfile(f1, f2);
    end
    
    %% reorient image
    if strcmp(ext,'.nii')
        if ~isempty(z.reorient) && length(z.reorient)==9
            predef=[ z.reorient 0 0 0]; % [[0 0 0   0 0 0 ]]  1 -1 1  ->used fpr DTIstudio
            fsetorigin(f2, predef);  %ANA
        end
    end
    
    %% make root information
    if exist(fullfile(pa2,'roots.mat'))~=2
        roots={};
        save(fullfile(pa2,'roots'),'roots');
    end
    load(fullfile(pa2,'roots'));
    roots(end+1,:)={ f1 f2};
    save(fullfile(pa2,'roots'),'roots');
    
    
 
    
    %% delete SourceFile
    if z.deleteSourceFile==1
       delete(f1);
    end
    
    %% MSG
   [pa3 fi3 ext3]=fileparts(f2);
    try
            disp(['create file ' ['[' fi3 ext3 '] in']  ' <a href="matlab: explorer('' ' pa '  '')">' pa '</a>' '; sourceVol: ' ['[' fi ext ']' ]  ]);% show h<perlink
    catch
            disp(['..rename: '  ['[' fi ext ']' ] ' to '  ['[' fi3 ext3 ']']  ' in path: ' pa ]);
    end
    
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% coder
% disp('        ');
hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=('%    ..copy/evaluate the this section');
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1', ',''params''' ,',z' ')' ]};
% disp(char(hh));
uhelp(hh,1);






























