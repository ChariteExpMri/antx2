
% merge ppt-files
% mergePPTfiles(pptfilename, pptfiles2merge)
%  windows-OS only !!
%% input
% pptfilename: fullpath name of new ppt-file  (file does not exist before)
%              -this file will contain the merged ppt-files  
% pptfiles2merge:  cellarray of fullpath ppt-files to merge 
%% example
% [fis] = spm_select('FPListRec',pares,'.*.pptx'); fis=cellstr(fis);
% pptfilename=fullfile(pwd,'a1_JD.ppt')
% mergePPTfiles(pptfilename, fis)


function mergePPTfiles(pptfilename, pptfiles2merge)
%% ===============================================

fis=cellstr(pptfiles2merge);
copyfile(fis{1},pptfilename,'f'); %copy 1st ppt


%% ===============================================
addfis=fis(2:end);
for i=1:length(addfis)
    
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