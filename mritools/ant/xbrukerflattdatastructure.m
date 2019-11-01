
%% #b flattens the bruker-data-structure
% help must be updated
% -this code is note validated !!
function xbrukerflattdatastructure(showgui,varargin )






%within ANT-data structure 
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
    % *** make flat structure of brukerFILES
    % ===================================
    x.path='O:\temp\Karina';	% main path where bruker data are stored <required to fill>
    x.destinationPath= 'O:\temp\Karina_bruker_flattened';	% destination path to write bruker data <required to fill>
    x.file2look4=      'subject';	% (don't change this) this file is recursively searched in sub/sub..structures of the brukerpath; (the "subject" file is always found in the brukerPath)
    xbrukerflattdatastructure(1,'params',x)
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

 


% try
%     global an;
%     pamain=an.datpath;
% catch
%     pamain=pwd;
% end

%% import 4ddata
p={...
    'inf98'      '*** make flat structure of brukerFILES                 '                         '' ''   %    'inf1'      '% PARAMETER         '                                    ''  ''
    'inf100'     '==================================='                          '' ''
    'path'                ''           'main path where bruker data are stored <required to fill>'  'd'
    'destinationPath'      ''           'destination path to write bruker data <required to fill>'  'd'
    'file2look4'    'subject'            'this file is recursively search in sub/sub..structures of brukerpath'    ''
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
if exist(z.path)~=7; return; end
if isempty(z.destinationPath); return; end
if exist(z.destinationPath)~=7;    mkdir(z.destinationPath); end

disp( ' ..wait..');
[files,dirs] = spm_select('FPListRec',z.path,z.file2look4);
files=cellstr(files);

%% get upper dir
pa2=[];
for i=1:length(files);
    [pa fi]=fileparts(files{i});
    pa2{i,1}=pa;
end


%% copy brukerdirs
for i=1:length(pa2);
    pa3=pa2{i};
    [~,fi2, ext]=fileparts(pa3);
    
  dirout=fullfile([z.destinationPath  ],[fi2 ext ['_' pnum(i,4)  ]] );
  copyfile(pa3, dirout,'f');
%         disp(dirout)

    %% MSG
    try
            disp(['new bruker dir ' ['[' 'flattened' '] in']  ' <a href="matlab: explorer('' ' dirout '  '')">' dirout '</a>' ';' ['[' ' ' ']' ]  ]);% show h<perlink
    catch
            disp(['new bruker dir  : '  ['[' 'flattened' ']' ] ' '  ['[' dirout ']']  '' ]);
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






























