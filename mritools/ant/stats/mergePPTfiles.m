
% merge ppt-files
% mergePPTfiles(pptfilename, pptfiles2merge)
% mergePPTfiles(pptfilename, pptfiles2merge, varargin) ...varargin in pairwise args
%  windows-OS only !!
%% input
% pptfilename: fullpath name of new ppt-file  (file does not exist before)
%              -this file will contain the merged ppt-files  
% pptfiles2merge:  cellarray of fullpath ppt-files to merge 
%% example
% [fis] = spm_select('FPListRec',pares,'.*.pptx'); fis=cellstr(fis);
% pptfilename=fullfile(pwd,'a1_JD.ppt')
% mergePPTfiles(pptfilename, fis)
% ==============================================
%%   example-1:  merge ppt-files
% ===============================================
%     pax=fullfile('F:\data8\test_merge_ppt_andxlsx','data');
%     [pptfiles] = spm_select('FPListRec',pax,'^circ.*.pptx'); pptfiles=cellstr(pptfiles);
%     Fout=fullfile(pwd,'SUMMARY_ex1.pptx');
%     [~,pptfileNames]=fileparts2(pptfiles);
%     mergePPTfiles(Fout, pptfiles);
%     showinfo2(['pptmain'],Fout);
% ======================================================================================
%%   example-2: insert slice with name of the ppt-file before appending ppt-file
% =======================================================================================
%     pax=fullfile('F:\data8\test_merge_ppt_andxlsx','data')
%     [pptfiles] = spm_select('FPListRec',pax,'^circ.*.pptx'); pptfiles=cellstr(pptfiles);
%     Fout=fullfile(pwd,'SUMMARY_ex2.pptx');
%     [~,pptfileNames]=fileparts2(pptfiles);
%     mergePPTfiles(Fout, pptfiles,'insertslide',pptfileNames);
%     showinfo2(['pptmain'],Fout);
% =======================================================================================
%%   example-3: same as above, now with paras for the inserted slice (see: img2ppt.m)
% =======================================================================================
%     pax=fullfile('F:\data8\test_merge_ppt_andxlsx','data')
%     [pptfiles] = spm_select('FPListRec',pax,'^circ.*.pptx'); pptfiles=cellstr(pptfiles);
%     Fout=fullfile(pwd,'SUMMARY_ex3.pptx');
%     [~,pptfileNames]=fileparts2(pptfiles);
%     mergePPTfiles(Fout, pptfiles,'insertslide',pptfileNames,...
%         'insertslideparas',struct('Tbgcol',[1 .84 0],'Tcol',[0 0 0], 'Tfs',30));
%     showinfo2(['pptmain'],Fout);
% 
% 
% 




function mergePPTfiles2(pptfilename, pptfiles2merge,varargin)
%% ===============================================
warning off;
p.insertslide=[];
insertsliceparas=[];
if ~isempty(varargin)
  pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
  p=catstruct(p,pin);
  
  try
  fn=fieldnames(p.insertslideparas);
  va=  struct2cell(p.insertslideparas);
  insertsliceparas=[fn va]';
  end
  
end
    
fis=cellstr(pptfiles2merge);
if isempty(p.insertslide)
    copyfile(fis{1},pptfilename,'f'); %copy 1st ppt
    addfis=fis(2:end);
else
    if isempty(insertsliceparas)
    img2ppt(fileparts(pptfilename),[], pptfilename,'doc','new',...
        'title',p.insertslide{1},'Tfs',15,'disp',0 );
    else
      img2ppt(fileparts(pptfilename),[], pptfilename,'doc','new',...
        'title',p.insertslide{1},insertsliceparas{:} ,'disp',0);
    end
        
    
    addfis=fis(1:end);
end

%% ===============================================

for i=1:length(addfis)
    if ~isempty(p.insertslide) && i>1
      if isempty(insertsliceparas)  
      img2ppt(fileparts(pptfilename),[], pptfilename,'doc','add',...
        'title',p.insertslide{i},'Tfs',15,'disp',0 );  
      else
         img2ppt(fileparts(pptfilename),[], pptfilename,'doc','add',...
        'title',p.insertslide{i},insertsliceparas{:} );  
      end
    
    end
    
    filespec1 =addfis{i} ;%'D:\Copy_ppt.pptx';
    filespec2 =pptfilename ;% 'D:\Paste_ppt.pptx';
    ppt = actxserver('PowerPoint.Application');
    op1 = invoke(ppt.Presentations,'Open',filespec1,[],[],0);
    op2 = invoke(ppt.Presentations,'Open',filespec2,[],[],0);
    slide_count1 = get(op1.Slides,'Count');
    slide_count2 = get(op2.Slides,'Count');
    k =slide_count2+1;
    for i = 1 : slide_count1
        invoke(op1.Slides.Item(i),'Copy');
        invoke(op2.Slides,'Paste');
        % invoke(op2.Item(k).Slides,'Paste)
        k = k+1;
    end
    invoke(op2,'Save');
    % invoke(op2,'SaveAs',filespec2,1);
    invoke(op1,'Close');
    invoke(op2,'Close');
    invoke(ppt,'Quit');
    
    
end

showinfo2(['newPPT'],pptfilename);