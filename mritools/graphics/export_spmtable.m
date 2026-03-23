
% export_spmtable: export spm_table(s)  as reduced excelfile) or wordfile
% if outputformat is 'word': several word-docs with tables will be automatically megered
% to one wordfile.
%% USAGE:
% fo=export_spmtable(xlsfiles)
% fo=export_spmtable(xlsfiles, v)
%% ===============================================
%% INPUT:
% xlsfiles:  -1/several eexcelfiles from SPM-analysis
%            -or a folder containing several eexcelfiles from SPM-analysis
% 
% v  : struct with additional paramters
% 
% --GLOBAL OPTIONS 
% v.meth           ='clust'; % results-method (currently the only option..ausbaubar..)
% v.format         ='word'; %output-format: 'word' or 'excel'; default: 'word'
% v.prefix         ='tab_'; %prefix to used for output
% v.outdir         ='';  % ouput-dir, if empty, resulting file will be saved in input folder
% v.addtablenumber =1;  %word: add table-number, options: [0,1]
% v.addfilenumber =1;   %word: add table-number, options: [0,1]
% v.mergetables   =1;   %merge word-tables to one single WORD-document [0,1]
% v.deletetables  =1;   %if "mergetables" is [1] than delete single word-doc-tables 
% v.mergename     ='alltables.docx' ; %if "mergetables" is [1],name of merged WORDfile
% % --WORD-SPECIFIC OPTIONS
% % ---margins---------------
% v.cm2pointsfac=28.35 ; % factor: 1cm is 28.35points
% v.margLR=[1.5 1.5];  % page-left & right margin in cm; default: [1.5 1.5]
% v.margTB=[2.0 2.0];  % page-top & botton margin in cm; default: [2.0 2.0]
% % ---title  ..here called /header (h..) -----
% v.hfn  ='Arial'; %header: fontname, default 'Arial'
% v.hfs  =10; %header: fontSize, default 10
% v.hfb  = 1; %header: fontBold, options: [0,1], default: 1,
% v.hsb  = 0; %header: remove space before each row, default:0
% v.hsa  = 0; %header: remove space after each row, default:0
% v.hlsr = 0; %header: linespace rule/ wdLineSpaceS: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:0
% v.hls  =10; %header: linespace in points, default:10
% % --table (t..)----------------
% v.tfn  ='Arial'; %table: fontname, default 'Arial'
% v.tfs  =9; %table: fontSize, default 9
% v.tsb  =0; %table: remove space before each row, default:0
% v.tsa  =0; %table: remove space after each row, default:0
% v.tlsr =5; %table: linespace rule/ wdLineSpaceS: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:5
% v.tls =12; %table: linespace in points, default:12
% v.ta  = 2; %table: alignment: options: [0,1,2,3];  0,Left;1,Center;2 Right;3,Justify, default: [2]
% v.tpadLR=[3.5 3.5]; % table Left&Right Padding; default: [3.5 3.5] 
% v.tpadTB=[0  0];    % table Top&Bottom Padding; default: [0  0]
% % ---metadata (m..)---------------
% v.mfn  ='Arial'; %metadata: fontname, default 'Arial'
% v.mfs  =7; %metadata: fontSize, default 7
% v.msb  =0; %metadata: remove space before each row, default:0
% v.msa  =0; %metadata: remove space after each row, default:0
% v.mlsr =0; %metadata: linespace rule/wdLineSpaceS:: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:0
% v.mls =10; %metadata: linespace in points, default:10
% 
% 
%% OUTPUT:
% [fo]: resulting output file(s), input-arg depending 
% 
%% EXAMPLES
% [1]: convert file to word-doc 
% fis=fullfile(pwd,'mpm_R1_C1__NS_GT_SI__CLUST0.001k656.xlsx');
% export_spmtable(fis)
% 
% [2]: convert 2 files to word-doc, with title.fontsize=20, table-fonsize=8, 
% table font is 'consolas', outputfile with prefix 'table_'    
% fis={...
%     fullfile(pwd,'mpm_R1_C1__NS_GT_SI__CLUST0.001k656.xlsx')
%     fullfile(pwd,'mpm_R1_C1__NS_GT_SI__CLUST0.001k656_n2.xlsx')
%     };
% export_spmtable(fis, struct('prefix','table_','hfs',20, 'tfs',8,'tfn','consolas'))
% 
% [3]: convert all files in pwd-folder to word-doc
% export_spmtable(pwd, struct('prefix','table2_'))

% [4]: convert all files in specific-folder, and save merged wordfile as fullfile(pwd,'mytbles.xlsx') 
% paexcel='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstatPlots\method_clust\xls'
% export_spmtable(paexcel, struct('mergename',fullfile(pwd,'mytbles.xlsx')))
% 
% [5a]: convert all files in specific-folder, keep single worddoc (don't merge doc-files) 
% paexcel='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstatPlots\method_clust\xls'
% docfiles=export_spmtable(paexcel, struct('mergetables',0));
% 
% [5b]:merge a list of word-docs with tables,  keep orig. worddocs
% fo=export_spmtable(docfiles,struct('deletetables',0),'merge')
% 
% [5c]: merge a list of word-docs with tables, delete orig, worddocs
% fo=export_spmtable(docfiles,[],'merge')
% 
% [6]: convert all files in specific-folder, save as specific single worddoc (don't merge doc-files) 
% paexcel='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstatPlots\method_clust\xls';
% docfile=export_spmtable(paexcel, struct('mergename',fullfile(fileparts(paexcel), 'resSig_clust_tables.docx')  ));

function fo=export_spmtable(xlsfiles, v0, task)

%% =[inputs]==============================================

% --GLOBAL OPTIONS 
v.meth           ='clust'; % results-method (currently the only option..ausbaubar..)
v.format         ='word'; %output-format: 'word' or 'excel'; default: 'word'
v.prefix         ='tab_'; %prefix to used for output
v.outdir         ='';  % ouput-dir, if empty, resulting file will be saved in input folder
v.addtablenumber =1;  %word: add table-number, options: [0,1]
v.addfilenumber =1;   %word: add table-number, options: [0,1]
v.mergetables   =1;   %merge word-tables to one single WORD-document [0,1]
v.deletetables  =1;   %if "mergetables" is [1] than delete single word-doc-tables 
v.mergename     ='alltables.docx' ; %if "mergetables" is [1],name of merged WORDfile
% --WORD-SPECIFIC OPTIONS
% ---margins---------------
v.cm2pointsfac=28.35 ; % factor: 1cm is 28.35points
v.margLR=[1.5 1.5];  % page-left & right margin in cm; default: [1.5 1.5]
v.margTB=[2.0 2.0];  % page-top & botton margin in cm; default: [2.0 2.0]
% ---title  ..here called /header (h..) -----
v.hfn  ='Arial'; %header: fontname, default 'Arial'
v.hfs  =10; %header: fontSize, default 10
v.hfb  = 1; %header: fontBold, options: [0,1], default: 1,
v.hsb  = 0; %header: remove space before each row, default:0
v.hsa  = 0; %header: remove space after each row, default:0
v.hlsr = 0; %header: linespace rule/ wdLineSpaceS: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:0
v.hls  =10; %header: linespace in points, default:10
% --table (t..)----------------
v.tfn  ='Arial'; %table: fontname, default 'Arial'
v.tfs  =9; %table: fontSize, default 9
v.tsb  =0; %table: remove space before each row, default:0
v.tsa  =0; %table: remove space after each row, default:0
v.tlsr =5; %table: linespace rule/ wdLineSpaceS: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:5
v.tls =12; %table: linespace in points, default:12
v.ta  = 2; %table: alignment: options: [0,1,2,3];  0,Left;1,Center;2 Right;3,Justify, default: [2]
v.tpadLR=[3.5 3.5]; % table Left&Right Padding; default: [3.5 3.5] 
v.tpadTB=[0  0];    % table Top&Bottom Padding; default: [0  0]
% ---metadata (m..)---------------
v.mfn  ='Arial'; %metadata: fontname, default 'Arial'
v.mfs  =7; %metadata: fontSize, default 7
v.msb  =0; %metadata: remove space before each row, default:0
v.msa  =0; %metadata: remove space after each row, default:0
v.mlsr =0; %metadata: linespace rule/wdLineSpaceS:: options:[ ,0,1,2,3,4,5], whis is single 1.5, 2,..; default:0
v.mls =10; %metadata: linespace in points, default:10
%% ===============================================
fo=[];
if exist('v0')~=1 || isempty(v0); v0.dummy=1; end
v=catstruct(v,v0);
% ==============================================
%%   specific tasks
% ===============================================
if exist('task')==1
    if strcmp(task,'merge')
        v.mergetables=1;
        fo=merge_docfiles(xlsfiles,v);
       return  
    else
       disp('..not defined'); 
        return
        
    end  
end










%% =[check files or path of xlsfiles ]=================================
xlsfiles=cellstr(xlsfiles);
ftype=existn(xlsfiles);
if ftype(1)==7  %path
    [fis] = spm_select('FPList',xlsfiles{1},'.*CLUST.*.xlsx');
    fis=cellstr(fis);
else
    fis= xlsfiles(find(ftype==2));
end



%% =========[proc ofer xlstable]======================================
tableno=1;
fileout={};
for i=1:length(fis)
    fclose('all');
    [tableno fileoutx]=proc(fis{i},v,tableno);
    if ~isempty(fileoutx)
       fileout=[fileout; fileoutx] ;
    end
end
fclose('all');
fo=fileout;

%% =====[merge word-doc]==========================================
if strcmp(v.format,'word') && v.mergetables==1 && length(fileout)>=1 
    fo2=merge_docfiles(fileout,v);
    fo=fo2;
end


%% ===============================================
function outputFile=merge_docfiles(files,v)
%% ===============================================


% files = spm_select('FPList',paexcel,'^table.*.docx')
% files=cellstr(files);
[pax name ext]     =fileparts(files{1});
[pax0 name0  ext0 ]=fileparts(v.mergename);
if ~isempty(pax0)
    pax=pax0;
end
outputFile = fullfile(  pax, [name0  '.docx' ]);
word = actxserver('Word.Application');
word.Visible = false;
% --- open first file to read margins ---
docIN = word.Documents.Open(files{1});
left   = docIN.PageSetup.LeftMargin;
right  = docIN.PageSetup.RightMargin;
top    = docIN.PageSetup.TopMargin;
bottom = docIN.PageSetup.BottomMargin;
docIN.Close(false);
% --- create output document ---
docOUT = word.Documents.Add;
docOUT.PageSetup.LeftMargin   = left;
docOUT.PageSetup.RightMargin  = right;
docOUT.PageSetup.TopMargin    = top;
docOUT.PageSetup.BottomMargin = bottom;
selection = word.Selection;
% --- insert all files ---
for i = 1:length(files)
    selection.InsertFile(files{i});
    selection.Collapse(0);
    if i < length(files)
        selection.TypeParagraph;
        selection.TypeParagraph;
    end
end
docOUT.SaveAs2(outputFile);
docOUT.Close;
word.Quit;
delete(word);
showinfo2([' mergedWord'],outputFile);


if v.deletetables==1
    for i=1:length(files)
        try; delete(files{i}); end
    end
end









%% =====within==========================================

function [tableno fileout]=proc(infile,v,tableno)
fileout='';
if isempty(v.outdir)
    outdir=fileparts(infile) ;
else
    outdir=v.outdir;
end
if exist(outdir)~=7; mkdir(outdir); end

% fileout=[outfile '.xlsx'];
% fileout=[pwd '\' outfile '.docx'];

[~, inname]=fileparts(infile);

if v.addtablenumber==1
  outname=[ regexprep(v.prefix,'_$','')  pnum(tableno,3)  '_' inname ];  
else
  outname=[ v.prefix inname ];  
end



if strcmp(v.format, 'word')
    fileout=fullfile(outdir, [outname '.docx' ]);
else
    fileout=fullfile(outdir, [outname '.xlsx'  ]);
end


%% ===============================================




% EXPORT_SPM_PUB_TABLE_FINAL2
% Publication-ready SPM cluster table (Excel or Word) for MATLAB 2016
%
% infile  : input SPM Excel file
% outfile : output filename without extension
% format  : 'excel' or 'word'

%% --- Detect sheets
[~, sheets] = xlsfinfo(infile);
% if length(sheets)==1; return; end



%% --- Read metadata from sheet1
sheet_meta  = sheets{1};
[~,~,raw_meta] = xlsread(infile, sheet_meta);
col1=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,1) );
col2=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,2) );

%check if 'k' exist and if k>0
isok=0;

checkprefixinfile=strfind(inname,v.prefix);
if ~isempty(checkprefixinfile) && checkprefixinfile==1
    isok=0;
end
try
    ik=regexpi2(col2,'k=');
    cl_size=str2num(regexprep(col2{ik},'k=',''));
    if cl_size>1
        isok=1;
    end
end

if isok==0; return; end


%% --- Read table (raw)
sheet_table = sheets{2};
[~,~,raw] = xlsread(infile, sheet_table);

% Combine header rows (row1 + row2)
header1 = raw(1,:);
header2 = raw(2,:);
headers_combined = strcat(header1,'_',header2);

% Data starts from row 3
data = raw(3:end,:);

%% --- Correct column mapping for publication table
% Based on your two header rows
colIdx = [1, 5, 3, 9, 7, 12, 13, 14, 15];
pub_headers = {'Cluster','k (voxels)','p(FWE-cluster)','Peak T','p(FWE-peak)',...
    'x','y','z','Region'};

data = data(:, colIdx);

%% --- Identify clusters
kCol = 2; % equivk column indicates new cluster


clusterCounter = 0;            % sequential cluster ID
clusterNum = nan(size(data,1),1);

for i = 1:size(data,1)
    % Check if row has a cluster (equivk)
    if ~isempty(data{i,2}) && isnumeric(data{i,2}) && ~isnan(data{i,2})
        clusterCounter = clusterCounter + 1;  % increment cluster ID
        currentCluster = clusterCounter;
    end
    clusterNum(i) = currentCluster;
end


clusters = unique(clusterNum(~isnan(clusterNum)));

%% --- Format table: max 3 peaks per cluster
formattedData = {};
for i = 1:length(clusters)
    idx = clusterNum == clusters(i);
    sub = data(idx,:);
    %     cl_col=cell2mat(sub(1:end,2));
    %     cl_col(1,1)=nan;
    %     sub = sub(1:min(3,size(sub,1)),:); % keep max 3 peaks
    for j = 1:size(sub,1)
        row = sub(j,:);
        if j == 1
            row{1} = clusters(i); % first peak: cluster number
        else
            row{1} = '';          % sub-peaks: leave cluster empty
            row(2:3) = {''};      % clear k and cluster p for sub-peaks
        end
        formattedData = [formattedData; row];
    end
end

%% --- Ensure 9 columns
for r = 1:size(formattedData,1)
    if size(formattedData,2) < 9
        formattedData(r,end+1:9) = {''};
    end
end

% %% --- Round numeric values, keep p-values in scientific notation
% for r = 1:size(formattedData,1)
%     for c = 1:size(formattedData,2)
%         val = formattedData{r,c};
%         if isnumeric(val)
%             if isempty(val)
%                 formattedData{r,c} = '';
%             elseif c == 3 || c == 5 % cluster and peak p-values
%                 formattedData{r,c} = sprintf('%.2e', val);
%             else
%                 formattedData{r,c} = round(val*100)/100;
%             end
%         end
%     end
% end

%% --- Round numeric values, conditional p-value formatting
for r = 1:size(formattedData,1)
    for c = 1:size(formattedData,2)
        val = formattedData{r,c};
        if isnumeric(val)
            if isempty(val)
                formattedData{r,c} = '';
            elseif c == 3 || c == 5 % cluster and peak p-values
                if val < 0.001
                    formattedData{r,c} = sprintf('%.2e', val); % scientific notation
                else
                    formattedData{r,c} = sprintf('%.3f', val); % normal decimal
                end
            else
                formattedData{r,c} = round(val*100)/100; % other numeric values
            end
        end
    end
end


%% --- Read metadata from sheet1
% [~,~,raw_meta] = xlsread(infile, sheet_meta);
col1=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,1) );
col2=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,2) );
i_add=[regexpi2(col2, 'table shows') regexpi2(col2, 'Voxel size:')];
meta_str=col2(i_add(1):i_add(2));
meta_str=strjoin(meta_str,char(10));

[~,map]=fileparts(col2{regexpi2(col1,'image')}); %map/image
ix_contrastname=regexpi2(col1,'^contrast');
contrast=col2{ix_contrastname}; %contrast

head=[map  ': ' contrast  ];

%% ===============================================


%% --- Example: dynamic additional info from meta_str
% meta_str = ['table shows 3 local maxima more than 0.5mm apart\n', ...
%     'Height threshold: T = 3.50, p = 0.001 (1.000)\n', ...
%     'Extent threshold: k = 656 voxels, p = 0.000 (0.001)\n', ...
%     'Expected voxels per cluster, <k> = 20.647\n', ...
%     'Expected number of clusters, <c> = 0.00\n', ...
%     'FWEp: 8.117, FDRp: Inf, FWEc: 366\n', ...
%     'Degrees of freedom = [1.0, 22.0]\n', ...
%     'FWHM = 0.58 0.56 0.55 mm mm mm; 6.43 6.23 6.13 {voxels}\n', ...
%     'Volume: 2604 = 3572481 voxels = 14081.3 resels\n', ...
%     'Voxel size: 0.09 0.09 0.09 mm mm mm; (resel = 245.55 voxels)'];

%% --- Extract values using regular expressions

% Number of local maxima
num_max = regexp(meta_str,'table shows (\d+) local maxima','tokens');
num_max = str2double(num_max{1});

% peakdistance
%     'table shows 3 local maxima more than 0.5mm apart
peak_dist = regexp(meta_str,'more than ([\d\.]+)mm','tokens');
peak_dist = str2double(peak_dist{1});

% Height threshold T and p
Tval = regexp(meta_str,'Height threshold: T = ([\d\.]+)','tokens');
Tval = str2double(Tval{1});
p_height = regexp(meta_str,'Height threshold: T = [\d\.]+, p = ([\d\.]+)','tokens');
p_height = str2double(p_height{1});

% Extent threshold k and p
k_thresh = regexp(meta_str,'Extent threshold: k = (\d+)','tokens');
k_thresh = str2double(k_thresh{1});
p_extent = regexp(meta_str,'Extent threshold: k = \d+ voxels, p = ([\d\.]+)','tokens');
p_extent = str2double(p_extent{1});
% **** watch out ***
% p_extent=p_height;
p_extent=0.05;

% Expected voxels per cluster <k>
k_expected = regexp(meta_str,'Expected voxels per cluster, <k> = ([\d\.]+)','tokens');
k_expected = str2double(k_expected{1});

% Expected number of clusters <c>
c_expected = regexp(meta_str,'Expected number of clusters, <c> = ([\d\.]+)','tokens');
c_expected = str2double(c_expected{1});




% Degrees of freedom
df = regexp(meta_str,'Degrees of freedom = \[([\d\.]+), ([\d\.]+)\]','tokens');
df1 = str2double(df{1}{1});
df2 = str2double(df{1}{2});

% FWHM
fwhm = regexp(meta_str,'FWHM = ([\d\.]+) ([\d\.]+) ([\d\.]+)','tokens');
fwhm_vals = str2double(fwhm{1});

% Voxel size
voxel = regexp(meta_str,'Voxel size: ([\d\.]+) ([\d\.]+) ([\d\.]+)','tokens');
voxel_vals = str2double(voxel{1});

% Search volume
vol = regexp(meta_str,'Volume: \d+ = (\d+) voxels = ([\d\.]+) resels','tokens');
n_voxels = str2double(vol{1}{1});
n_resels = str2double(vol{1}{2});


try
    spm_version=spm('Ver');
catch
    spm_version   = 'SPM12' ;
end
%% --- Build dynamic publication-ready string
meta_text = sprintf([...
    ['Notes: Voxel-wise two-sample t-test (df = [%.0f, %.0f]) performed using ' spm_version '. '],...
    'Statistical maps were thresholded at p < %.3f uncorrected (T = %.2f), with cluster-level FWE correction at p < %.3f (k ≥ %d voxels). ',...
    'Up to %d local maxima per cluster are reported (minimum distance %.1f mm). ',...
    'Expected voxels per cluster: <k> = %.3f. Expected number of clusters under null: <c> = %.2f (based on random field theory). ',...
    'Voxel size: %.2f × %.2f × %.2f mm. Smoothness: FWHM = %.2f × %.2f × %.2f mm. ',...
    'Search volume: %d voxels (%.1f resels).',...
    'Cluster-level inference is the basis for significance'],...
    df1, df2, p_height, Tval, p_extent, k_thresh, num_max,peak_dist, k_expected, c_expected, ...
    voxel_vals(1), voxel_vals(2), voxel_vals(3), fwhm_vals(1), fwhm_vals(2), fwhm_vals(3), ...
    n_voxels, n_resels);

% disp(meta_text)


%% ===============================================
%% --- Export
switch lower(v.format)
    case 'excel'
        %         fileout=[outfile '.xlsx'];
        %         xlswrite([outfile '.xlsx'], [pub_headers; formattedData]);
        %         disp('Excel export done.');
        
        %% --- Save table + additional info to Excel
        % pub_headers : 1x9 cell, formattedData : Nx9 cell
        head_inCell=repmat( {nan}, [ 1 size(pub_headers,2)]);
        head_inCell{1,1}=head;
        tb=[head_inCell; pub_headers; formattedData];
        xlswrite(fileout, tb);
        
        
        
        %% --- Split into lines (for Excel)
        meta_lines = strsplit(meta_text,'. ');      % split at periods for readability
        meta_lines = meta_lines(~cellfun('isempty',meta_lines)); % remove empty lines
        
        %% --- Convert to Nx9 cell to match table columns
        ncols = size(pub_headers,2);               % number of table columns
        meta_cells = cell(length(meta_lines), ncols);
        for i = 1:length(meta_lines)
            meta_cells{i,1} = [meta_lines{i} '.']; % put text in first column
        end
        
        %% --- Write to Excel below the main table
        start_row = size(tb,1) + 1;     %  +1 blank row
        xlswrite(fileout, meta_cells, 1, ['A' num2str(start_row)]);
        
        disp('Excel export done with additional info.');
        
        %         ####
        % Append below the table
        %         start_row = size(formattedData,1) + 2;  % +1 for header, +1 to leave a blank row
        %         xlswrite([outfile '.xlsx'], meta_cells, 1, ['A' num2str(start_row)]);
        %
        %         disp('Excel export done with additional info.');
        %
        
    case 'word'
        word = actxserver('Word.Application');
        word.Visible = 0;
        doc = word.Documents.Add;
        
        % Set margins (in points; 1 cm ≈ 28.35 points)
%         doc.PageSetup.TopMargin    = 28.35*2;  % 2 cm top margin
%         doc.PageSetup.BottomMargin = 28.35*2;  % 2 cm bottom margin
%         doc.PageSetup.LeftMargin   = 28.35*1.5;  % 1 cm left margin
%         doc.PageSetup.RightMargin  = 28.35*1.5;  % 1 cm right margin
%         
        doc.PageSetup.TopMargin    = v.cm2pointsfac*v.margTB(1);  % 2 cm top margin
        doc.PageSetup.BottomMargin = v.cm2pointsfac*v.margTB(2);  % 2 cm bottom margin
        doc.PageSetup.LeftMargin   = v.cm2pointsfac*v.margLR(1);  % 1 cm left margin
        doc.PageSetup.RightMargin  = v.cm2pointsfac*v.margLR(2);  % 1 cm right margin
        
        
        % ==============================================
        %%   title/..here called 'header'
        % ===============================================

        range = doc.Range;
        if v.addtablenumber==1
            txt = ['Table ' num2str(tableno) ': ' head];
        else
            txt = ['Table: ' head];
        end
        range.InsertAfter(txt);
        startPos = range.End - length(txt)-1;% Get exact title range
        endPos   = range.End;
        titleRange = doc.Range(startPos, endPos);
        
        titleRange.Font.Name                        = v.hfn  ;% 'Arial';% Format title ONLY
        titleRange.Font.Size                        = v.hfs  ;% 10;
        titleRange.Font.Bold                        = v.hfb  ;%  1;
        titleRange.ParagraphFormat.SpaceBefore      = v.hsb  ;%  0;
        titleRange.ParagraphFormat.SpaceAfter       = v.hsa  ;%  0;
        titleRange.ParagraphFormat.LineSpacingRule  = v.hlsr ;%  0; % single spacing
        titleRange.ParagraphFormat.LineSpacing      = v.hls  ;% 10; % small gap, adjust as needed
        

        % --- Insert NEW paragraph (this inherits bold!)
        range = doc.Range(doc.Content.End-1, doc.Content.End-1);
        range.InsertParagraphAfter;
        % --- Move to NEW paragraph explicitly
        range = doc.Paragraphs.Last.Range;
        range.Collapse(0);  % wdCollapseEnd
        % --- CRITICAL: reset BOTH font AND paragraph formatting
        range.Font.Bold = 0;
        range.Font.Name = 'Consolas';
        range.Font.Size = 6;
        range.ParagraphFormat.SpaceBefore = 0;
        range.ParagraphFormat.SpaceAfter  = 0;
        range.ParagraphFormat.LineSpacingRule = 0;
        %% --- ALSO reset style (this is the key fix!)
        range.Style = doc.Styles.Item('Normal');
        
        
        if 1
            % ==============================================
            %%   table
            % ===============================================
            nrows = size(formattedData,1)+1;
            ncols = size(formattedData,2);
            ncols = size(formattedData,2);  % number of data columns
            if exist('pub_headers','var')
                ncols = max(ncols, numel(pub_headers));  % at least as many as headers
            end
            table = doc.Tables.Add(range,nrows,ncols);
            table.Range.Font.Name                         =v.tfn ;% 'Arial'; % --- Set table font & size
            table.Range.Font.Size                         =v.tfs ;% 9;
            
%             disp(table.LeftPadding)
%             disp(table.RightPadding)
%             disp(table.TopPadding)
%             disp(table.BottomPadding)
            for c = 1:ncols % --- Fill headers
                table.Cell(1,c).Range.Text = pub_headers{c};
                table.Cell(1,c).Range.Bold = 1;
            end
            for r = 1:size(formattedData,1) % --- Fill table data
                for c = 1:ncols
                    val = formattedData{r,c};
                    if isnumeric(val)
                        table.Cell(r+1,c).Range.Text = num2str(val);
                    else
                        table.Cell(r+1,c).Range.Text = val;
                    end
                end
            end
            table.AutoFitBehavior(1);  % 1 = wdAutoFitContent
            table.Range.ParagraphFormat.SpaceBefore     =v.tsb  ;% 0;  % remove space before each row
            table.Range.ParagraphFormat.SpaceAfter      =v.tsa  ;% 0;  % remove space after each row
            table.Range.ParagraphFormat.LineSpacingRule =v.tlsr ;% 5;  % wdLineSpaceSingle
            table.Range.ParagraphFormat.LineSpacing     =v.tls  ;%12;  % in points, can reduce further if needed
            table.Range.ParagraphFormat.Alignment       =v.ta   ;% 2;  % 2 = wdAlignParagraphRight
            
 
            table.LeftPadding  =v.tpadLR(1);% table.LeftPadding  - 10;
            table.RightPadding =v.tpadLR(2);% table.RightPadding - 2;
            table.TopPadding   =v.tpadTB(1);% table.TopPadding   + 0;
            table.BottomPadding=v.tpadTB(2);% table.BottomPadding+ 0;
            
            
            
            
             table.AllowAutoFit = true;
%              % Disable AutoFit so column width stays fixed
% table.AllowAutoFit = false;
% % Expand last column
% lastCol = table.Columns.Count;
% table.Columns.Item(lastCol).Width = 150;  % in points
%              
% table.LeftIndent = 28.35;  % 1 cm = 28.35 points


% Freeze AutoFit
% table.AllowAutoFit = false;
% tblRange = table.Range;               % get the Range object for the table
% tblRange.ParagraphFormat.LeftIndent = 2.35;  % 1 cm in points

% lastCol = table.Columns.Count;
% table.Columns.Item(lastCol).Width = 150; % in points, adjust as needed

% Get last column
lastCol = table.Columns.Count;
% Extract longest text in last column
maxLen = 0;
for r = 1:table.Rows.Count
    val = table.Cell(r,lastCol).Range.Text;  
    val = strtrim(val);             % remove end-of-cell marker
    val = val(1:end-2);             % Word appends special chars for end-of-cell
    maxLen = max(maxLen, numel(val));
end

% Convert maxLen to points (adjust factor for font/size)
widthPoints = maxLen * 5 ; % 5 points per character is a rough estimate

% Set last column width
% table.Columns.Item(lastCol).Width = widthPoints;


% table.AutoFitBehavior(1);     % compact numeric columns first
% table.AllowAutoFit = false;   % freeze layout
% lastCol = table.Columns.Count;
% table.Columns.Item(lastCol).Width = 100;

            
%             table.PreferredWidthType = 3;   % wdPreferredWidthPercent
%             table.PreferredWidth = 210;     % 110% of content width
            
% table.PreferredWidthType = 2;  % width in points
% table.PreferredWidth = 400;    % try 550–650 depending on page layout



            %% ==============================================
            %--- Add metadata below table & Format metadata text
            %% ===============================================
            rng = doc.Range(table.Range.End, table.Range.End);
            rng.InsertParagraphAfter;
            rng.Text = meta_str;
            rng.Font.Name                       =v.mfn;%'Arial';
            rng.Font.Size                       =v.mfs;%7;
            rng.ParagraphFormat.SpaceBefore     =v.msb;%0;
            rng.ParagraphFormat.SpaceAfter      =v.msa;% 0;
            rng.ParagraphFormat.LineSpacingRule =v.mlsr;% 0; % single spacing
            rng.ParagraphFormat.LineSpacing     =v.mls;%10; % small gap, adjust as needed
        end
        % --- Save and close
        %fileout=[pwd '\' outfile '.docx'];
        doc.SaveAs2(fileout);
        doc.Close;
        word.Quit;
        disp('Word export done.');
        



        
        
        
        
        
    otherwise
        error('format must be "excel" or "word"');
end

tableno=tableno+1;
showinfo2([' formated table'],fileout);

