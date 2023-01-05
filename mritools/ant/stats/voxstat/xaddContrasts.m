
%add contrasts to SPM-factorial design. 
% The contrasts are defined in a textfile:
%===================================================================================================
%% #wb A TEXTFILE WITH DEFINED COMPARISONS 
% if 'compType' is set to 'file', user has to specify a prepared textfile (*.txt).
% This textfile can contain one or several comparisons. 
% Each comparison contains the specifier "g1=" and "g2=" for the two groups, respectively. 
% Use curly brackets '{}' to define the groups. The factors must be in brackets '[]'
% Use the specifier "name" to assign a name for this comparison.
%        The name must contain the string "vs." in the string such as "Ctrl vs. All115dB".
%        Avoid special characters!
%% EXAMPLE: The below textfile contain 3 comparisons 
%% Explanation for the first comparison:the name of the comparison is "All Ctrl vs. All 115dB"
%% group-1 (g1) is defined by curly brackets and contains the subgroups: 7d-control animal,1d-control animal,
%% 56d-control animal and 84d-control animal.
%% group-2 (g2) is defined by curly brackets and contains the subgroups: 7d-115dB animal,1d-115dB animal,
%% 56d-115dB animal and 84d-115dB animal.
% 
%             name:All Ctrl vs. All 115dB
%             g1={      [7d] [Ctrl]             
%                       [1d] [Ctrl] 
%                       [56d][Ctrl] 
%                       [84d][Ctrl] }
%             g2={      [7d] [115dB]       
%                       [1d] [115dB] 
%                       [56d][115dB] 
%                       [84d][115dB]}
%             =============================================================================
%             name:All Ctrl vs. All 90dB
%             g1={      [7d]  [Ctrl]             
%                       [1d]  [Ctrl] 
%                       [56d] [Ctrl] 
%                       [84d] [Ctrl] }
%             g2={      [7d]  [90dB]      
%                       [1d]  [90dB] 
%                       [56d] [90dB] 
%                       [84d] [90dB] }
%             =============================================================================
%             name:All 115dB vs. All 90dB
%             g1={      [7d] [115dB]             
%                       [1d] [115dB] 
%                       [56d][115dB] 
%                       [84d][115dB] }
%             g2={      [7d] [90dB]      
%                       [1d] [90dB] 
%                       [56d][90dB] 
%                       [84d][90dB]  }
%             =============================================================================
%% #bo ___ PARAMETER ___ 
%                                                                                                                                                                                                                            
% compFile      [SELECT] a text-file with contrasts/comparisons (see example above)                                                                          
% spmpath       [SELECT] one or multiple SPM-path(s) with existing voxelwise analysis.
%               The new contrasts is added to the SPM.mat-file of the
%               selected SPM-path(s)
% startContrastIndex: starting index to appending the new contrasts
%                     if "append": the new contrasts will be appended to existing contrasts
%                     otherwise a numeric value: 
%                     example: if index is [20] the new contrasts are appended starting with index 20 
%                      all contrast-indices >=20 will be removed and overwritten by the new contrasts 
% deleteContrasts    : remove all contrasts {default: 0}
%                      [0] do not remove existing contrasts  {default}
%                      [1] remove all existing contrasts
% 
% 
%% #bo ___ EXAMPLES ___
% 
% ==============================================
%%  starting index for new contrasts is 25, ie. the 
%%  first 24 contrasts will be kept and new contrasts start with index 25...
% ===============================================
% z=[];                                                                                                                                                                                                                           
% z.compFile           = 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\group\victor_specContrasts.txt';     % % [SELECT] text-file with contrasts/comparisons                                                                          
% z.spmpath            = { 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\voxstat\vx_x_ad' };                % % [SELECT] SPM-path(s) to add new contrasts                                                                              
% z.startContrastIndex = [25];                                                                         % % starting contrast index, if "append" new contrasts will be appended to existing ones, otherwise specify starting index 
% z.deleteContrasts    = [0];                                                                          % % delete existing contrasts [0|1]: [1] existing contrasts will be deleted                                                
% xaddContrasts(1,z); 
% 
% ==============================================
%%   append to existing contrasts (no existing contrasts will be deleted)
% ===============================================
% z=[];                                                                                                                                                                                                                           
% z.compFile           = 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\group\victor_specContrasts.txt';     % % [SELECT] text-file with contrasts/comparisons                                                                          
% z.spmpath            = { 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\voxstat\vx_x_ad' };                % % [SELECT] SPM-path(s) to add new contrasts                                                                              
% z.startContrastIndex = 'append';                                                                         % % starting contrast index, if "append" new contrasts will be appended to existing ones, otherwise specify starting index 
% z.deleteContrasts    = [0];                                                                          % % delete existing contrasts [0|1]: [1] existing contrasts will be deleted                                                
% xaddContrasts(1,z); 




function xaddContrasts(showgui,x)

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end
% ==============================================
%%    PARAMETER-gui
% ===============================================
% z.compFile=fullfile( 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\group', 'victor_specContrasts.txt')
% z.spmpath ={'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\voxstat\vx_x_ad'}
% z.deleteContrasts=0;



if exist('x')~=1;        x=[]; end
p={...
    'compFile'            ''        '[SELECT] text-file with contrasts/comparisons'    'f'
    'spmpath'             ''        '[SELECT] SPM-path(s) to add new contrasts'          'md'
    'startContrastIndex'  'append'  'starting contrast index, if "append" new contrasts will be appended to existing ones, otherwise specify starting index '    { '1' '10' '21' 'append'}
    'deleteContrasts'     0         'delete existing contrasts [0|1]: [1] existing contrasts will be deleted'     'b'
    };
p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.25    0.4    0.6    0.2 ],...
        'title',['***add contrasts ***' '[' mfilename '.m]'],...
        'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end
%===========================================
%%   history
%===========================================
xmakebatch(z,p, mfilename);


% ==============================================
%%   process
% ===============================================
z.spmpath=cellstr(z.spmpath);

cprintf('*[0 0 1]',[ 'Adding contrasts\n']);

pathis=pwd;
for i=1:length(z.spmpath)
    z2=z;
    z2.spmpath=z.spmpath{i};
    process(z2);
end
cd(pathis);
cprintf('*[0 0 1]',[ 'DONE\n']);
% ==============================================
%%   
% ===============================================

function process(z)

%% ===============================================

% z.compFile=fullfile( 'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\group', 'victor_specContrasts.txt')
% z.spmpath ={'H:\Daten-2\Imaging\AG_Groeschel_LAERMRT\voxstat\vx_x_ad'}
% z.deleteContrasts=0;


spmpath =z.spmpath;
spmfile =fullfile(spmpath,'SPM.mat');
parfile =fullfile(spmpath,'xstatParameter.mat');
load(spmfile);
par=load(parfile);
x=par.par;


%% ==============read excelfile=================================
[~,~,a0]=xlsread(x.excelfile,x.sheetnumber );
he=a0(1,:);
a=a0(1:end,:);
% facts=a(:,x.group_col)
s.m.a_info='_groupfile___';
s.m.a=a;
s.m.s_info='_fields___';
if isfield(x,'group_col')
    s.m.d       =cellfun(@(a){num2str(a)},a(2:end,[ x.mouseID_col x.group_col ])   );
    s.m.dh      =a(1,[ x.mouseID_col x.group_col ]) ;
else
    s.m.d       =cellfun(@(a){num2str(a)},a(2:end,[ x.mouseID_col x.regress_col ])   );
    s.m.dh      =a(1,[ x.mouseID_col x.regress_col ]) ;
end
s.m.d=regexprep(s.m.d,{'\^|\.|\s|,|;|#|\d^|/|\'},{''});
%% ===========OBTAIN ====================================
M=s.m;
M.Nfactors=(size(M.dh,2)-1);
M.idxfactor=[1:M.Nfactors]+1;
factors=M.dh(M.idxfactor);
levels    =M.d(:,M.idxfactor);%s.d(:,2:length(s.dfactornames)+1);
% ---convert to numeric
levelsnumeric=cell(size(levels,1),size(levels,2));
levelsstring =levels;
levcode={};
for i=1:size(levels,2)
   [uniL IA IC ]=unique(levels(:,i),'stable');
   numL=cellfun(@(a){[num2str(a)]},num2cell([1:length(uniL)]'));
   uniLS=cellfun(@(a){['^' a '$']},uniL);
   levelsnumeric(:,i)=regexprep(levels(:,i),uniLS,numL);
   levcode{i}.hc={'Levelstring' 'LevelIndex'};
   levcode{i}.c=[uniL num2cell(IC(IA))];
end
% levels    =cell2mat(cellfun(@(a){[str2num(a)]},levels));
levels    =cell2mat(cellfun(@(a){[str2num(a)]},levelsnumeric));
%% ===============================================
[o labels compnames]=readcomparisonsfromfile(z);
%% ===============================================

% ==============================================
%%   create contrasts
% ===============================================

colnames=SPM.xX.name;

c={};
for con=1:size(o,1)
     vecc=zeros(2,size(colnames,1));
     for i=1:2
        w=o{con,i};
        if   i==1; ins= 1;
        else       ins=-1;
        end
        for j=1:size(w,1)
            facomb=strsplit(w{j},'][');
            facomb=regexprep(facomb,{'[' ']'},'');
            codecomb=[];
            for k=1:length(facomb)
                is=strcmp(levcode{k}.c(:,1), facomb(k));
                numcode0= cell2mat(levcode{k}.c(is,2));
                codecomb(1,k)=numcode0;
            end
            codestr=['{' regexprep(num2str(codecomb),'\s+',',') '}'];
            icol=regexpi2(colnames,[codestr '$']);
            vecc(i,icol)=ins;
        end
     end % two comparionsons
      dumcon  =sum(vecc,1);
      name    =strjoin(compnames(con,:),'>');%'_VS_'
      c(end+1,:)={name dumcon};
      
      dumcon2=-dumcon;
      name2   =strjoin(compnames(con,:),'<');%'_VS_'
      c(end+1,:)={name2 dumcon2};
end

% ==============================================
%%  define batch
% ===============================================
mb={};
ncon=1;

for i=1:size(c,1)
    mb{1}.spm.stats.con.consess{ncon}.tcon.name    =c{i,1} ;
    mb{1}.spm.stats.con.consess{ncon}.tcon.convec  =c{i,2} ;
    mb{1}.spm.stats.con.consess{ncon}.tcon.sessrep = 'none';
    ncon=ncon+1;
end
mb{1}.spm.stats.con.spmmat = {spmfile};
mb{1}.spm.stats.con.delete = z.deleteContrasts;

% spm_jobman('interactive',mb);

% mb{1}.spm.stats.con.delete = 0;
% mb{2}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% mb{2}.spm.stats.results.conspec.titlestr = '';
% mb{2}.spm.stats.results.conspec.contrasts = 1;
% mb{2}.spm.stats.results.conspec.threshdesc = 'FWE';
% mb{2}.spm.stats.results.conspec.thresh = 0.05;
% mb{2}.spm.stats.results.conspec.extent = 0;
% mb{2}.spm.stats.results.conspec.conjunction = 1;
% mb{2}.spm.stats.results.conspec.mask.none = 1;
% mb{2}.spm.stats.results.units = 1;
% mb{2}.spm.stats.results.export{1}.ps = true;

% ==============================================
%%   remove contrasts
% ===============================================
if z.deleteContrasts==0
    if isnumeric(z.startContrastIndex) && z.startContrastIndex<length(SPM.xCon)
        keepcon=1:z.startContrastIndex-1;
        deleteContrasts(spmpath,keepcon );
    end
end
% ==============================================
%%   run batch
% ===============================================
pathis=pwd;
cd(spmpath);
spm_jobman('run',mb);

%% ===============================================




function [o labels compnames]=readcomparisonsfromfile(z)

%% ===============================================
if isfield(z,'compFile')==1 && exist(char(z.compFile))==2
    file=char(z.compFile);
else
   [ fi pa] =uigetfile(fullfile(pwd, '*.txt'),'select comparison file');
   if isnumeric(fi); return; end
   file=fullfile(pa, fi);
end
q=preadfile(file);
q=q.all;
%======find indices =========================================
ig1=regexpi2(q,'^\s*g1\s*=');
ig2=regexpi2(q,'^\s*g2\s*=');
iname=regexpi2(q,'^\s*name\s*=|^\s*name\s*:');
% check equal number of g1 and g2
if length(ig1)~=length(ig2)
    error(['groups mismatch: "g1" and "g2" are not of same size (' num2str(length(ig1)) ' vs ' num2str(length(ig2)) ')'])
end
if ~isempty(iname)
    if length(iname)~=length(ig1)
        error(['name and group mismatch: "g1" and "name" are not of same size (' num2str(length(ig1)) ' vs ' num2str(length(iname)) ')'])
    end
end
% ==========extract comparisons=====================================
o         ={};
labels    ={};
compnames ={};
for i=1:length(ig1)
    for j=1:2
        if j==1; s=q(ig1(i):end);
        else   ; s=q(ig2(i):end);
        end
        v1=min(regexpi2(s,{'{'}));
        v2=min(regexpi2(s,{'}'}));
        
        s=s(v1:v2);
        s=regexprep(s,{'['},{'''['});
        s=regexprep(s,{']'},{']'''});
        % s=
        s=regexprep(s,{'''\s*'''},{''});
        s=regexprep(s,{'}'},{'};'});
        s=strjoin(s,';');
        eval(s);
    end
    if ~isempty(iname)
        s=q(iname(i));
        s=regexprep(s,{'vs.|vs' ,'versus'},{'_vs_'},'once');
        s=regexprep(s,{'name'},{''});
        s=regexprep([s],{'[^a-zA-Z0-9_]'},{''});
        name=(s);
        
        
        o(i,:)          ={g1 g2 };
        labels(i,:)     =name;
        compnames(i,:)  = strsplit(char(name),'_vs_');
    end
end



function deleteContrasts(spmpath,keepcon )

% ==============================================
%%   delete (contrasts) 
% ===============================================
% spmpath=pwd;

% keepcon=1:25
load(fullfile(spmpath,'SPM.mat'));
con=SPM.xCon(keepcon);
delcon=setdiff(1:length(SPM.xCon), keepcon);

for i=1:length(delcon)
    num=delcon(i);
    f1=fullfile(spmpath,['con_' pnum(num,4) '.nii']);
    if exist(f1)==2;     delete(f1); end
    f1=fullfile(spmpath,['spmT_' pnum(num,4) '.nii']);
    if exist(f1)==2;     delete(f1); end
    f1=fullfile(spmpath,['spmF_' pnum(num,4) '.nii']);
    if exist(f1)==2;     delete(f1); end
end
SPM.xCon=con;
save(fullfile(spmpath,'SPM.mat'),'SPM');