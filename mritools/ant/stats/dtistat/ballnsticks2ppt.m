% generate ppt-file containing previously saved ballNstick plots (previously saved as 'v*tif')
% ballnsticks2ppt(img_path,pptfile)
% with inputs
% img_path: path to folder containing ballnsticks-images ('v*tifs')
% pptfile
%% example
% img_path='F:\data8\schoenke_2dregistration\panel3_ballNsticks';
% pptfile=fullfile(img_path, 'ballNsticks.pptx');
% ballnsticks2ppt(img_path,pptfile)

function ballnsticks2ppt(img_path,pptfile)

% clear;cf; clc
% img_path='F:\data8\schoenke_2dregistration\panel3_ballNsticks';
% pptfile=fullfile('F:\data8\schoenke_2dregistration', 'ballNsticks.ppt');


pd= img_path;   %fullfile(pabase,[ 'fig_' num2str(nfig)],['panel' num2str(panel) '_ballNsticks'     ] );
title=[pd  ];
    
[fisXLS] = spm_select('List',pd,'^.*.xlsx'); fisXLS=cellstr(fisXLS);
 
 % ======[1st slice]=========================================
%  [fis1] = spm_select('FPList',pd,'^v014.*.tif'); fis1=cellstr(fis1);
%  [fis2] = spm_select('FPList',pd,'^v005.*.tif'); fis2=cellstr(fis2);
%  [fis3] = spm_select('FPList',pd,'colorbar.tif');fis3=cellstr(fis3);
%  fis=[fis1;fis2;fis3];
[fis1] = spm_select('FPList',pd,'^v.*.tif');    fis1=cellstr(fis1);
[fis2] = spm_select('FPList',pd,'colorbar.tif');fis2=cellstr(fis2);
fis=[fis1;fis2];
 [~,fname,fext]=fileparts2(fis); 
 
 l={};
 l(end+1,1)={['path: '  pd ]};
 for i=1:length(fisXLS)
     l(end+1,1)={['file: '  fisXLS{i}       ]};
 end
l(end+1,1)={['images (left-to-right,top-to-down ): '      ]};
l=[l; cellfun(@(a,b){[ '     '    a b ]}, fname,fext)];

 
 fxy=[10 20];
  infofile=fullfile(pd,'node_list.txt');
 img2ppt(pd,fis, pptfile,'size','p','doc','new',...
     'crop',0,'gap',[.8 .8],'columns',4,'xy',[0.5 2 ],'wh',[ 4 nan],...
     'file',infofile,'ffn','Arial','ffs',7,'fxy',fxy,...
     'title',title,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
     'text',l,'tfs',6,'txy',[0 20],'tbgcol',[1 1 1]);
 
 
 
%   % ===[slice-2]============================================ 
% [fis1] = spm_select('FPList',pd,'^v.*.tif');    fis1=cellstr(fis1);
% [fis2] = spm_select('FPList',pd,'colorbar.tif');fis2=cellstr(fis2);
% fis=[fis1;fis2];
% 
% 
% 
% l={};
% l(end+1,1)={['figNO: '  num2str(nfig)  ]};
% l(end+1,1)={['panel: '  num2str(panel) ]};
% l(end+1,1)={['file: '  fisXLS{1}       ]};
% 
% fxy=[12 23];
%  infofile=fullfile(pd,'node_list.txt');
%  img2ppt(pwd,fis, pptfile,'size','p','doc','add',...
%      'crop',0,'gap',[.3 1.6],'columns',4,'xy',[2 3 ],'wh',[ 4 nan],...
%      'file',infofile,'ffn','Arial','ffs',7,'fxy',fxy,...
%      'title',title,'Tha','center','Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
%      'text',l);
 