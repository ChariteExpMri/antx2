
%% copy templates with given resolution
% function newfiles=xcopyfiles(rstruct, pa,  voxres)
% INPUT
% struct: with FPfiles of templates (from antpath)
% pa     : current mousepath (only the path)
% voxres: voxelResolution, e.g. : [0.07 0.07 0.07 ]
function newfiles=xcopyfiles2(rstruct, pa,  voxres)



%% MAKE TEMPLATEPATH    ()
[pas fi ext]=fileparts(pa);
if isempty(ext)
    [pas2 fi2 ext2]=fileparts(pas);
end


templatepath=fullfile(pas2,'templates');
mkdir(templatepath);

%STRUCT TO CELL
rcell= struct2cell(rstruct);
isubcell=cellfun(@iscell,rcell);

% FIND CELLS WITHIN CELL
files=[ rcell(find(isubcell==0)) ];
files=[files; rcell{find(isubcell==1)}];

% ANO.nii is the reference FILE -->first IMAGE
iANO=regexpi2(files,'AVGT.nii');
files=[files(iANO)  ;  files(setdiff([1:length(files)],iANO)) ];

kdisp(['       *** CREATE STUDY TEMPLATES *** ' ]);
kdisp(['            this has to be done only once ' ]);

kdisp(['..create Templatefolder: '  templatepath]);
kdisp(['..reslice the following volumes to voxSize : ['  sprintf('%2.2f ', voxres) ']']);

newfiles={};        
for i=1:length(files)
    if exist(files{i})==2
        newfile=replacefilepath(files{i},templatepath);
        [~ ,fis ,ext]=fileparts(newfile);
       kdisp(['     ...       ' fis ext ]);

        if i==1; %REFERENCE IMAGE
            [BB, vox]   = world_bb(files{i});
            resize_img5(files{i},newfile, abs(voxres), BB, [], 1,[]);
            refimage=newfile;
        else %ALL OTHER IMAGES
            interp=1;
            if ~isempty(strfind(files{i},'ANO.nii'))  || ~isempty(strfind(files{i},'FIBT.nii'))
                interp=0;
            end
            rreslice2target(files{i}, refimage, newfile,interp);
        end
        newfiles(end+1,1)={newfile};
    end
    
end
 
function kdisp(msg)
try
% cprintf([0 .5 0],(['warp: ' '['    num2str(i) '/'  num2str(length(files)) ']: '    strrep(files{i},'\','\\')  '\n']  ));    
cprintf([0 .5 0],([  strrep(msg,[filesep],[filesep filesep])  '\n']  ));    
catch
  disp(msg);  
end

    



