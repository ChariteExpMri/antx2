
% display files folderwise in command-window (no GUI)
%
%% [OPTIONAL PAIRWISE INPUTS] ___________________________________________
% 'form' or 'm':  form/mode to display (default: 1)
%       [1]    :files x folder ..long version
%       [11]   :files x folder ..compact version
%       [2]    :folder x files ..long version
%       [22]   :folder x files ..compact version
%     'list'   : list of all files
%     'cell'   : list of all files in quotes (directly usable in matlab)
%     'celline'/'line': one line-list of all files in quotes (directly usable in matlab)
%     'counts' : list and counts of all files
%
%    'sel'    : show files only for this  animal selection:
%             'selected' or 's' : show files only of GUI-selected animals 
%            or use: 
%             {FP-mdirs}    : cellstring with fullpath animal-dirs
%             {   mdirs}    : cellstring with animal-dirs assuming project is loaded
%             [index vector]: animal-indices such as: [1,2,3]--> show files of first 3 animals
%     index vector as string: specific animal-indices such as '[1 end]' ..show  files of first and last animals
%                other  examples  '[1 end]','end','end-2:end','[end-3:end]'
%
%      otherwise files of all animimals will be shown
%             example: dispfiles('sel','selected')
%
% 'flt'  or 'f' : filter   (default: '.*.nii')
%       examples;
%         '.*'  ...all files
%         '.*.nii'  ...all NIFTI-files
%         '^t2.*.nii'   ...all NIFTI-files starting with t2
%         '^ANO|^AVG.*.nii'  ...all NIFTI-files starting with ANO or AVG
% 'counts' or 'c' show extra column/raw with counts
%        [0] no; [1] yes    ..default: [1]
% 'countsonly' show only counts ...just filenames and counts across folders
%           [0] no; [1] yes    ..default: [1]
%         - 'counts' has to be set to [1] if 'countsonly' should be used
%           example: dispfiles('countsonly',1,'form',1)
%
% dir or 'd' :-as  <char> : upper dir ("dat"-dir) to search in subdirs or other dir
%           default: use data-path from loaded project (an.datpath)
%         : as <cell> list of fullpath-animal-dirs or other dir
% show or 's' : show  output
%       [1] show in comand-window, default: 1
%       [2] show in separate window
%       [0] no
%
%
%% [OPTIONAL OUTPUT] ___________________________________________
% o-struct with
%     hm:       header of m: {'dirs x files'}
%     m:        dirs x files table, with '1' if file exists otherwise '0'; example:  [13x51 double]
%     dirs:     fullpath-dirs; example:  {13x1 cell}
%     files:    filenames; example  {1x51 cell}
%     dirsshort:shortname-dirs; example:   {13x1 cell}
%     mainpath: upper path of 'dirs'; example:'F:\data5\nogui\dat'
%
%% [EXAMPLES] ______________________________________________________antver
%
% dispfiles;  %show all NIFTI from loaded project-file
% o=dispfiles('flt','.*'); % show all files
% dispfiles('tpm'); %search for files with string 'tpm' in it
% dispfiles({'PD' 'T1' 'MT'});  %search for files with strings 'PD','T1' or 'MT'
% same as
% dispfiles('flt',{'PD','T1' 'MT'})
% dispfiles('form',2,'flt','^t2.*.nii');  %find all NIFTIs starting with 't2'
% dispfiles('form',2,'flt','^ANO|^AVG.*.nii')  %find all NIFTI-files starting with ANO or AVG
% dispfiles('form',2,'flt','^ANO|^AVG.*.nii','counts',0,'dir',fullfile(pwd,'dat2')); %%find all NIFTI-files starting with ANO or AVG, show no count-column/row, use explicit main folder
% o=dispfiles('form',2,'flt','.*.nii','counts',0,'dir',fullfile(pwd,'dat'),'show',0); % find all NIFTIs,show no count-column/row, use explicit main folder, do not show, parse output
% -check nifti-files in template folder of two studies using shortcuts
% dispfiles('f','nii','m',1,'s',1,'c',1,'d',{'F:\data8_MPM\MPM_agBrandt3\templates','F:\data7\AG_schmid\templates'})
%
% from selected animals show all NIFTIs starting with 't2' or 'x_t2'
% dispfiles('sel','selected','flt','^t2.*.nii|^x_t2.*.nii')
%% ====
%% display files of these fullpath-folders
% md={'F:\data5\nogui\dat\tube_MN_t1_4D'
%     'F:\data5\nogui\dat\tube_MN_t2'
%     'F:\data5\nogui\dat\ventr'};
% dispfiles('sel',md);
%% ====
%% display files of these shortname folders (antx-project must be loaded before)
% md={'tube_MN_t1_4D'    'tube_MN_t2'    'ventr'};
% dispfiles('sel',md)
%
%



function varargout=dispfiles(varargin)

% clc

% ==============================================
%%
% ===============================================
warning off;
p.flt='.*.nii';
p.form =1;
p.counts=1;
p.dir   =[];
p.show  =1;
p.countsonly=0;
p.info  ='';


if nargin>0
    if nargin==1 % direct search for work...1st-arg
        if ischar(varargin{1})
            p.flt=varargin{1};
        elseif  iscell(varargin{1})  % search for files using multiple strings
            p.flt= strjoin(varargin{1},'|');
        end
    else
        pin= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        p=catstruct(p,pin);
    end
end

%shortcuts
if isfield(p,'m');  p.form   =p.m; end %->form/mode
if isfield(p,'s');  p.show   =p.s; end %show
if isfield(p,'f');  p.flt    =p.f; end %flt
if isfield(p,'c');  p.counts =p.c; end %counts
if isfield(p,'d');  p.dir    =p.d; end %dirs



if  iscell(p.flt)
    p.flt= strjoin(p.flt,'|');
end


if isfield(p,'sel') && ischar(p.sel) && strcmp(p.sel,'s');
    p.sel='selected';
end


%===================================================================================================
% ==============================================
%%   get datpath
% ===============================================
useglobVar=1; % use animal-selection via "an"

if isfield(p,'dir') && ~isempty(p.dir)
    if ischar(p.dir)
        if ~isempty(p.dir) && exist(p.dir)==7
            pam=p.dir;
            useglobVar=0;
        end
    elseif iscell(p.dir)
        if sum(existn(p.dir)==7)==length(p.dir)
            pam=p.dir;
            useglobVar=0;
        end
    end
    
end


if useglobVar==1
    global an
    if ~isempty(an) && isfield(an,'datpath')
        pam=an.datpath;
    end
end

% [files,dirs] = spm_select('FPListRec',direc,filt)
%% ============[obtain all files]===================================
if ischar(pam)
    [dirs] = spm_select('FPList',pam,'dir','.*');
    dirs=cellstr(dirs);
    [dirs2] = spm_select('List',pam,'dir','.*');
    dirs2=cellstr(dirs2);
elseif iscell(pam)
    dirs      =pam;
    [~, dirs2]=fileparts2(pam);
else
    error('dir(s) not specified');
end

if   isfield(p,'sel') && (strcmp(char(p.sel),'selected')==1 || strcmp(char(p.sel),'s')==1)
    if useglobVar==1
        dirs= antcb('getsubjects');
    end
    dirs2=dirs;
    
end
%% ===============================================
if isfield(p,'sel')
    if isnumeric(p.sel)
        p.sel=dirs(p.sel)  ;
    end
    if ~isnumeric(p.sel)  && ischar(p.sel) % for: '[1 end]','end','end-2:end','[end-3:end]' ,etc
        %% ===============================================
        tf = ~isempty(regexp(strtrim(p.sel), '(?<![A-Za-z0-9_])end(?![A-Za-z0-9_])', 'once'));
        if tf==1
            eval([ 'p.sel=dirs(' p.sel ');']);
        end
        % first 4 should work
        %         q={'[1 end]'
        %             'end'
        %             'end-2:end'
        %             '[end-3:end]'
        %             'F:\data10\tonsend'
        %             'F:\data10\ende'
        %             'wendung'}
        %         for i=1:length(q)
        %              str = strtrim(q{i});
        % %          tf = ~isempty(regexp(str, '\bend\b', 'once'));
        %           tf = ~isempty(regexp(str, '(?<![A-Za-z0-9_])end(?![A-Za-z0-9_])', 'once'));
        %          disp(tf);
        %         end
        %% ===============================================
        
    end
    
    
    if (strcmp(char(p.sel),'selected')==1)==0
        % ===[fullpath folders]============================================
        isexistDir=unique(existn(p.sel)==7);
        if length(isexistDir)==1 && isexistDir==1
            [dirs,dirs2]=deal(cellstr(p.sel));
        end
        % ====[shortname folders]==========================
        if useglobVar==1
            dirtest=stradd(cellstr(p.sel), [ an.datpath filesep ],1);
        else
            dirtest=p.sel;
        end
        isexistDir=unique(existn(dirtest)==7);
        if length(isexistDir)==1 && isexistDir==1
            [dirs,dirs2]=deal(cellstr(dirtest));
        end
    end
end


%% ===============================================


%% ===============================================
if isempty(char(dirs2{1})) %some other direct path such as 'templates'
    dirs=cellstr(pam);
    [~, dirs2]=fileparts2(dirs);
end



% p.flt='.*.nii';
% fis={};
fisall={};
for i=1:length(dirs)
    [files] = spm_select('List',dirs{i},p.flt);
    if ~isempty(files)
        files=cellstr(files);
        fisall=[fisall; files];
    end
    
    %     if isempty(files)
    %         files=[];
    %     else
    %         files=cellstr(files);
    %     end
    %     fis{1,i}=files;
    %     fisall=[fisall; files];
end
% ==============================================
%%   find unique files in each  mdir
% ===============================================

fisuni=unique(fisall);
fisuni=natsort(fisuni);
sortertype=0;
if isfield(p,'sort') && strcmp(p.sort,'time')
    sortertype=1; %sort accrding date
elseif isfield(p,'sort') && strcmp(p.sort,'bytes')
    sortertype=2; %sort accrding bytes
end


% sorter='date'
dates=[];
try
    df=zeros(length(dirs),length(fisuni) );
    for i=1:length(dirs)
        for j=1:length(fisuni)
            if exist(fullfile(dirs{i},fisuni{j}))==2
                df(i,j)=1;
                if sortertype==0; continue; end
                %% ===============================================
                if sortertype==1
                    k=dir(fullfile(dirs{i},fisuni{j}));
                    dates(i,j)=k.datenum;
                elseif sortertype==2
                    k=dir(fullfile(dirs{i},fisuni{j}));
                    dates(i,j)=k.bytes;
                end
                %% ===============================================
                'a'
                
                %% ===============================================
                
            end
        end
    end
catch
    df=[];
end

%sort according date
if sortertype==1 && ~isempty(dates)
    dates(dates==0)=nan;
    %     datevec=nanmean(dates,1);
    datevec=nanmax(dates,[],1);
    [~, isort]= sort(datevec);
    fisuni=fisuni(isort);
    df=df(:,isort);
    
end

% ==============================================
% %
% ===============================================
% if isfield(p,'hlink') && ~isempty(p.hlink) && p.hlink==1
%             %% ===============================================
%             e=repmat({'-'}, [size(df)] );
%             for i=1:size(df,1)
%                 for j=1:size(df,2)
%                     if df(i,j)==1
%                         f1=fullfile(dirs{i}, fisuni{j});
%                         [hb]=spm_vol(f1);
%                         %q='';
%                          e{i,j}=(['<a href="matlab: rmricron([],''' f1 ''',[], 0)">' '+' '</a>']);
%                     else
%                          e{i,j}=(['<a href="matlab: rmricron([],''' f1 ''',[], 0)">' '-' '</a>']);
% 
%                          
% 
% %                         e{i,j}=q;
% 
%                     end
%                 end
%             end
%             %% ===============================================
% end
% ==============================================
%%   variable output
% ===============================================
if nargout>0
    o.hm={'dirs x files'};
    o.m=df;
    o.dirs =dirs;
    o.files=fisuni(:)';
    o.dirsshort =dirs2;
    o.mainpath  =pam;
    varargout{1}=o;
end
if isempty(fisuni)
    disp('not files found') ;
    return
end
% ==============================================
%%  prep display in cmd-window
% ===============================================
w=[];
df2=df;
df2=num2cell(df2);
df2=cellfun(@(a){[ num2str(a) ]} , df2 );
df2=regexprep(df2,{'0','1'},{'.','+'});

% if isfield(p,'hlink') && ~isempty(p.hlink) && p.hlink==1
%     df2=e;
% end

if isfield(p,'info') && ~isempty(p.info)
    p.form='info';
end


if p.counts==1
    %add counts
    df2=[df2; cellfun(@(a){[ num2str(a) '/' num2str(size(df,1)')]} , num2cell(sum(df,1)) )];
    dirs2(end+1)={'counts'};
    
    %add file-counts
    dx=[ cellfun(@(a){[ num2str(a) '/' num2str(size(df,2)')]} , num2cell(sum(df,2)) ) ;{''}];
    df2=[df2 dx];
    fisuni(end+1)={'counts'};
end
% plog([],[ dirs2 num2cell(df)],0,'','al=1;')
if 1
    if p.form==22
        % ==============================================
        %%   not transposed :  mdirs x files
        % ===============================================
        
        nc=size(char(fisuni(:)),2); %number of characters
        he=cellfun(@(a){[ repmat(' ',[nc-length(a)  1 ]); a(:)  ]} , fisuni )';
        he2={};
        for i=1:length(he)
            he2(:,i)=cellstr(he{i});
        end
        
        hedirs=repmat({''},[ size(he2,1) 1] );
        % ===============================================
        helin={repmat('=',[1 nc ])};
        dlin =repmat({'='},[1 size(df2,2) ]);
        
        try
            w=plog([],[[hedirs he2];[helin dlin]; [ dirs2  (df2)]],0,'FOLDER x FILE','al=1;');
        catch
            w=plog([],[[hedirs he2];[helin dlin]; [ dirs2'  (df2)]],0,'FOLDER x FILE','al=1;');
        end
        
        irep=regexpi2(w,'====');
        w{irep}=repmat('-',[ 1 length(w{irep}) ]);
        
        if p.show==1 % show table
            disp(char(w))
        end
        
        
    elseif p.form==2
        % ==============================================
        %%   not transposed :  mdirs x files
        % ===============================================
        
        he2=['  ' cellfun(@(a){[ repmat('=',[1 length(a)]) ]} , fisuni(:)' )];
        x=[[ {'  '}  fisuni(:)'  ]; [ he2]; [  dirs2(:)  df2  ] ];
        if p.countsonly==1
            x=[[ {'  '}  fisuni(:)'  ]; [ he2]; [  dirs2(end)  df2(end,:)  ] ];
        end
        
        % resort counts as 2nd column
        try
            x=[x(:,1) x(:,end) x(:,2:end-1)];
            x=[x(1,:); x(2,:);x(end,:); x(2:end-1,:)];
        end
        
        w=plog([],x,0,'FILE x FOLDER','al=1;');
        
        
        
        
        if p.show==1 % show table
            disp(char(w))
        end
        %
        %         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        %         FILE x FOLDER
        %         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        %         x_t2.nii counts
        %         ======== ======
        %         1001_a1                         +        1/1
        %         1001_a2                         .        0/1
        %         20201118CH_Exp10_9258           +        1/1
        %         Devin_5apr22                    +        1/1
        %         Kevin                           +        1/1
        %         anna_issue                      .        0/1
        %         empty                           .        0/1
        %         k3339                           .        0/1
        %         nodata                          .        0/1
        %         statImage                       .        0/1
        %         sus_20220215NW_ExpPTMain_009938 +        1/1
        %         ventr                           .        0/1
        %         xx31                            .        0/1
        %         counts                          5/13
        %         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        
    elseif p.form==11
        
        
        % ==============================================
        %%   transposed: file x mdirs
        % ===============================================
        df3=df2';
        nc=size(char(dirs2(:)),2); %number of characters
        he=cellfun(@(a){[ repmat(' ',[nc-length(a)  1 ]); a(:)  ]} , dirs2 )';
        he2={};
        for i=1:length(he)
            he2(:,i)=cellstr(he{i});
        end
        hedirs=repmat({''},[ size(he2,1) 1] );
        helin={repmat('=',[1 nc ])};
        dlin =repmat({'='},[1 size(df3,2) ]);
        w=plog([],[[hedirs he2];[helin dlin]; [ fisuni(:)  (df3)]],0,'FILE x FOLDER','al=1;');
        
        irep=regexpi2(w,'====');
        w{irep}=repmat('-',[ 1 length(w{irep}) ]);
        
        
        if p.show==1 % show table
            disp(char(w))
        end
        
        
    elseif p.form==1
        % ==============================================
        %%   transposed: file x mdirs  ..LONG VERSION
        % ===============================================
        df3=df2';
%         if isfield(p,'hlink') && ~isempty(p.hlink) && p.hlink==1
% %             
% %             ix=min(regexpi2(df3(:,1),'+'))
% %             we=df3{ix}
% %             
%             
% %             qd=repmat(dirs2(:)',[size(df3,1) 1 ])
% %             qf=repmat(fisuni(:),[ 1 size(df3,2)  ])
% %             df3=cellfun(@(a,b,c) {[ a repmat('.' ,1,length(b)-length(a)+length(c) )  ]},df3,qf,qd );
% %             
%             for i=1:size(df3,2)
%                 si=size(char(df3(:,i)),2);
%                  df3(:,i)=cellfun(@(a) {[ a  repmat('.' ,1, si-length(a)    )   ]},...
%                      df3(:,i) );
% 
%             end
%             
%             
%         end
        he2=['  ' cellfun(@(a){[ repmat('=',[1 length(a)]) ]} , dirs2(:)' )];
        x=[[ {'  '}  dirs2(:)'  ]; [ he2]; [  fisuni(:)  df3  ] ];
        if p.countsonly==1
            he2=he2([1 end]);
            df3=df3(:,[end]);
            x=[[ {' ' 'counts'}  ]; [ he2]; [  fisuni(:)  df3  ] ];
        end
        % resort counts as 2nd column
        try
            x=[x(:,1) x(:,end) x(:,2:end-1)];
            x=[x(1,:); x(2,:);x(end,:); x(2:end-1,:)];
        end
        w=plog([],x,0,'FILE x FOLDER','al=1;');
        if p.show==1 % show table
            disp(char(w))
        end
        
    elseif ischar(p.form) && ( strcmp(p.form,'list') || strcmp(p.form,'cell') || strcmp(p.form,'celline') ...
            || strcmp(p.form,'line'))
        x=fisuni;
        if strcmp(x{end,1},'counts')==1
            x(end,:)=[];
        end
        %w=plog([],x,0,'FILES','al=1;');
        w=x;
        if strcmp(p.form,'cell')
            w=cellfun(@(a) {[ ''''  a '''' ]},w);
        elseif strcmp(p.form,'celline') || strcmp(p.form,'line')
            w=cellfun(@(a) {[ ''''  a '''' ]},w);
            w=strjoin(w,', ');
        end
        
        
        
        
        if p.show==1 % show table
            disp(char(w))
        end
    elseif ischar(p.form) && strcmp(p.form,'counts')
        x=[[fisuni df2(end,:)' ]];
        if strcmp(x{end,1},'counts')==1
            x(end,:)=[];
        end
        
        w=plog([''],x,0,'FILES','al=1;');
        
        
        if p.show==1 % show table
            disp(char(w))
        end
        
        
        
        
        
        
        
        %         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        %         FILE x FOLDER
        %         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        %         1001_a1 1001_a2 20201118CH_Exp10_9258 Devin_5apr22 Kevin anna_issue empty k3339 nodata statImage sus_20220215NW_ExpPTMain_009938 ventr xx31  counts
        %         ======= ======= ===================== ============ ===== ========== ===== ===== ====== ========= =============================== ===== ====  ======
        %         1-1_TriPilot-multi_1.nii                      .       .       +                     .            .     .          .     .     .      .         .                               .     .     1/13
        %         1-2_FISP_sagittal_1.nii                       .       .       +                     .            .     .          .     .     .      .         .                               .     .     1/13
        %         1_Localizer_multi_slice_1.nii                 .       .       .                     .            +     .          .     .     .      .         .                               .     .     1/13
        %         2_1_T2_ax_mousebrain_1.nii                    .       .       +                     .            .     .          .     .     .      .         .                               .     .     1/13
        %         ANO.nii                                       +       +       +                     +            +     +          .     +     .      .         +                               .     +     9/13
        %         AVGT.nii                                      +       +       +                     +            +     +          .     +     .      +         +                               .     +     10/13
        %         AVGThemi.nii                                  +       +       +
        %
    elseif ischar(p.form) && strcmp(p.form,'info')
        %% ===============================================
        if ~isempty(p.info)
            
            %% ===============================================
            %e=repmat({''}, [size(df)] );
            for i=1:size(df,1)
                for j=1:size(df,2)
                    if df(i,j)==1
                        f1=fullfile(dirs{i}, fisuni{j});
                        [hb]=spm_vol(f1);
                        
                        disp([ pnum(i,3) ' '  dirs{i}]);
                        disp([ pnum(j,3) ' '  fisuni{j}]);
                        
                        cprintf('*[0 0 1]',[strrep([ pnum(i,3) ' '  dirs{i}], filesep,[filesep filesep]) '\n']);
                        cprintf('*[0 0.5 0]',[['    ' pnum(j,3) ' '  fisuni{j}] '\n']);
                         
                        
                        if strcmp(p.info,'dim')
                            if length(hb)==1
                                q=sprintf('[%d,%d,%d]',hb(1).dim);
                                disp(q);
                            else
                                q=sprintf('[%d,%d,%d,%d]',hb(1).dim, length(hb));
                                disp(q);
                            end
                        elseif strcmp(p.info,'mat')
                            q=hb(1).mat;
                            disp(q);
                        elseif strcmp(p.info,'hdr')
                            q=hb(1);
                            disp(q);
                        elseif strfind(p.info,'hdr')
                            %eval(strrep(['disp(' p.info ');'],'hdr','hb(1)'));
                            eval(strrep(['q=' p.info ';'],'hdr','hb(1)'));
                            disp(q);
                        end
                        
                        
                        
                        
                        %                                 e{i,j}=q;
                        
                    end
                end
                
                %% ===============================================
            end
            
        end
        
        
        
        %% ===============================================
        
        
        
    end
end

if nargout>0
    o.m2=(w);
    varargout{1}=o;
end

if p.show==2 % show table in help-window
    try;
        uhelp(w);
    end
end









