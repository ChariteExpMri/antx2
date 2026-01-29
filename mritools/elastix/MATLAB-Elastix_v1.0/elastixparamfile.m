
% elastixparamfile: list/copy/modify elastix-parameterfile
% options (1st input-arg)
% 'list'  -list  ANTx-paramter-files 
%         -no other input-args
%      <optional> OUTPUT: list of parameterfiles
% 
% 'list2' -list  ANTx-paramter-files as hyperlinks to check content
%         -no other input-args
%      <optional> OUTPUT: list of parameterfiles
% 
% 'copy'  -copy paramterfile to target-folder (i.e. ANTx-study path)
%         -new file is <name of parameterfile + '_mod.txt'> to avoid shadowing of parameterfile
%       other input-args:
%           'pfile': -name of the parameterfile
%                    -shortname ('trafoeuler5_MutualInfo.txt') if an existing ANTx-parameterfile is used
%           'outdir': -target-dir to copy the parameterfile
%                     -for instance the ANTx-study-dir, obtained via: antcb('getstudypath') 
% 
%      <optional> OUTPUT: name of the parameterfile
% 
% 'set'  change/delete paramters in the copied parameter-file
%       other input-args:
%            -'pfile': -name of the parameterfile to modify (!do not directly modify the paramterfile in the Antx-tbx!)
%            -change: PAIRWISE ARGS: <elastixparameterNAME>, <elastixparameterVALUE>,  ..which should be changed
%            -delete: PAIRWISE ARGS: <elastixparameterNAME>, [], ..which should be deleted
% 
%      <optional> OUTPUT: name of the parameterfile
% 
%% EXAMPLES
%% list available ANTx-parameterfiles
% elastixparamfile('list2');
%% first: make copy of existing parameterfile in current study-dir:
%    paramfile=elastixparamfile('copy','pfile','trafoeuler5_MutualInfo.txt','outdir',antcb('getstudypath')   );
%% than change parameters:
%   paramfile=elastixparamfile('set','pfile',paramfile, 'NumberOfResolutions',2, 'MaximumNumberOfIterations',1000); 
%% OR delete parameters:
%   paramfile=elastixparamfile('set','pfile',paramfile, 'ImagePyramidSchedule',[], 'ErodeMask',[]); 
% 
%% OR change and delete parameters:
%   paramfile=elastixparamfile('set','pfile',paramfile, 'NumberOfResolutions',3, 'ImagePyramidSchedule',[]); 




function varargout=elastixparamfile(varargin)
o='';

if 0
    %% ===============================================
    clc
    paramfile=elastixparamfile('copy','pfile','trafoeuler5_MutualInfo.txt','outdir',antcb('getstudypath')   );
    %o=elastixparamfile('list');
    %o=elastixparamfile('list2');
    
    
  paramfile=elastixparamfile('set','pfile',paramfile, 'NumberOfResolutions',2, 'MaximumNumberOfIterations',1000); 
    
%     paramfile=elastixparamfile('set','pfile',paramfile,...
%         'NumberOfResolutions',33, 'ImagePyramidSchedule', [3 3 1], 'ErodeMask', 'false' ,...
%         'MaximumNumberOfIterations', 500);
    
%       paramfile=elastixparamfile('set','pfile',paramfile,...
%         'NumberOfResolutions',[], 'ImagePyramidSchedule', [], 'ErodeMask', [] ,...
%         'MaximumNumberOfIterations', []);
    %% ===============================================
    
end
if nargin==0; return; end
pin=varargin(2:end);
p0=cell2struct(pin(2:2:end),pin(1:2:end),2);


if strcmp(varargin{1},'list')
    dir_parfiles=fullfile(fileparts(fileparts(which('set_ix.m'))),'\paramfiles');
    ls(fullfile(dir_parfiles,'*.txt'));
    o=cellstr(ls(fullfile(dir_parfiles,'*.txt')));
     if nargout==1; varargout{1}=o; end
end
if strcmp(varargin{1},'list2')
    dir_parfiles=fullfile(fileparts(fileparts(which('set_ix.m'))),'\paramfiles');
    o=cellstr(ls(fullfile(dir_parfiles,'*.txt')));
    oFP=stradd(o,[dir_parfiles filesep],1);
    disp(['*** PARAMETER-FILES ***']);
    for i=1:length(o);
        disp([' <a href="matlab: edit(''' oFP{i} ''');">' o{i} '</a>' ]);
    end
    if nargout==1; varargout{1}=o; end
end

if strcmp(varargin{1},'copy')
    %% ===============================================
    p.suffix='_mod';
    p=catstruct(p,p0);
    
    [pa fi ext]=fileparts(p.pfile);
    if isempty(pa)
        p.pfile=which(p.pfile);
    end
    if exist(p.pfile)~=2
        error(['[p.pfile]: parameterfile not found: ' p.pfile]) ;
    end
    if exist(p.outdir)~=7
        error(['[p.outdir] outdirectory not found: ' p.pfile]) ;
    end
        
    p.pfileNew=stradd(strrep(p.pfile, fileparts(p.pfile),p.outdir), p.suffix  ,2 );
    copyfile(p.pfile,p.pfileNew,'f'  );
    showinfo2(['...copied paramfile'],p.pfileNew);
    o=p.pfileNew;
    if nargout==1; varargout{1}=o; end
    return
   %% ===============================================
   
end
if strcmp(varargin{1},'set')
    %% ===============================================
   p=p0;
   pfile=p.pfile;
   par=rmfield(p,'pfile');
      %% ===============================================

   a=preadfile(pfile); a=a.all;
   
   fn=fieldnames(par);
   chk_old={};chk_new={};
   for i=1:length(fn)
       ix=regexpi2(a,fn{i});
       if ~isempty(ix)
           a(ix)=cellfun(@(f) {['//' f]},regexprep(a(ix),'//',''));
           ixe=ix(end);
       else
          ixe= length(a)+1;
       end
       val=getfield(par,fn{i});
       if isnumeric(val)==1
           valstr=regexprep(num2str(val),'\s+',' ');
       else
           valstr=['"' val '"'];
       end
       if length(a)<ixe
           chk_old{end+1,1}=['--not found: ' fn{i} ];
       else
           chk_old{end+1,1}=a{ixe};
       end
       if ~isempty(valstr)
       a{ixe}= ['('  fn{i}  ' '  valstr     ')' ];
       chk_new{end+1,1}=a{ixe};
       else
          chk_new{end+1,1}=['--removed: ' fn{i} ]; 
       end
       
   end
   
%    clc
%    chk_old
disp(' ..changed parameters: ');
   disp(chk_new);
   
    pwrite2file(p.pfile,a);
    showinfo2(['...modified pfile'],p.pfile);
    o=p.pfile;
    if nargout==1; varargout{1}=o; end
    
    %% ===============================================
    
    
    return
   %% ===============================================
   
end



