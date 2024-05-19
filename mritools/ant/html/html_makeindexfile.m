
%% input
% inpath       : path with html-files for indexing
% index_fname  : index-filename (shortname , with extension 'html') 
%                example 'index.html'
%                file will be stored in the inpath-directory
% index_title  : index title (string)
% optional: pairwise inputs 
%   'verbose': [0,1]; default: 0
%   'exclude': cellstr with words. HTMLfiles containing those words will be
%              excluded; default: 'index'
%% example-1
% inpath        = fullfile(fileparts(v.sourceDir),'checks');
% index_fname   =fullfile(inpath, 'index_3.html');
% index_title   ='blob';
%% example-2 (show hyperlink)
% html_makeindexfile(inpath,index_fname,index_title,'verbose',1);
%% example-3 (remove html-fiels from index via 'exclude') 
% html_makeindexfile(inpath,index_fname,index_title,'verbose',1,'exclude',{'index','DTIreg' 'reorient'  } );
  

function outfile=html_makeindexfile(inpath,index_fname,index_title,varargin)



if 0
    %% ===============================================
    
   inpath        = 'H:\Daten-2\Imaging\AG_Paul_Brandt\paul_TESTS_2022_exvivo_MPM_DTI\checks';
   index_fname   ='index.html';
   index_title   ='blob';
   html_makeindexfile(inpath,index_fname,index_title,'verbose',0);
   
   html_makeindexfile(inpath,index_fname,index_title,'verbose',0,'exclude',{'index','DTIreg' 'reorient'  } );
    %% =============================================== 
end

outfile='';
%% ====inputs===========================================
p.verbose=0;
p.exclude='index';
if ~isempty(varargin)
   pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end


% return
%% ======indexhtmlfilename ==================
[pax, name, ext]=fileparts(index_fname);
if isempty(ext); ext='.html'; end
index_fname=fullfile( inpath,[ name ext] );
%% ======get list of html-files ==================

[filesfp] = spm_select('FPList',inpath,'.*.html');
filesfp=cellstr(filesfp);
filesfp(regexpi2(filesfp,index_fname))=[];
%% ===remove specific files containing words such as "index"=======
[ ~, namex]=fileparts2(filesfp);
str=strjoin(cellstr(p.exclude),'|');
idel=regexpi2(namex,str);
filesfp(idel)=[];
%% ===============================================

s2={'<html><br><br>'};
s2{end+1,1}=[[ '<font color=blue>'  '<h2>' index_title '</h2>'  '<font color=black>' ];];
s2{end+1,1}=[[ '<font color=green>' '<h4>' ['Path: ' inpath ] '</h4>'  '<font color=black>' ];];

if ~isempty(char(filesfp))
    for i=1:length(filesfp)
        [~ ,file,ext]=fileparts(filesfp{i});
        k=dir(filesfp{i});
        s2{end+1,1}=[...
            ' &#9864;  <a href="' [file ext] '"target="_blank">' [file ext]  '</a>' ...
            [    ' <p style="color:blue;display:inline;font-family=''Courier New''; font-size:10px;">' ...
            [ 'Created: '  k(1).date ]   '</p>'] ...
            '<br>'];
        %     <a href="url">link text</a>
    end
    % <p style="display:inline">...</p>
end

s2{end+1,1}=['<pre><p style="color:blue;font-family=''Courier New''; font-size:10px;">' [ 'Created: '  datestr(now)]   '</p></pre>'];
%% ====[save]===========================================
pwrite2file(index_fname, s2);
outfile=index_fname;
if p.verbose==1;
    showinfo2('INDEXfile',index_fname);
end


