



% merge powerpoint files% pppt-files
% fisoutname: resulting ppt-filename
% fis: fullpath list of pwerpoints to merge (in that order)
%% exampl:
% [fis] = spm_select('FPList',pwd,'^sum.*.pptx'); fis=cellstr(fis);
%     fisoutname=fullfile(pwd,'test.pptx')
%     pptmerge(fisoutname,fis)
    
    
function pptmerge(fisoutname,fis)

% ==============================================
%%   example
% ===============================================

if 0
    [fis] = spm_select('FPList',pwd,'^sum.*.pptx'); fis=cellstr(fis);
    fisoutname=fullfile(pwd,'test.pptx')
    pptmerge(fisoutname,fis)
    
end

% ==============================================
%%   copy first pptfile
% ===============================================
fclose('all');
copyfile(fis{1},fisoutname,'f');


for i=2:length(fis)
    
    mergefile(fisoutname,fis{i})
    
end
% ==============================================
%%
% ===============================================
function mergefile(filespec2,filespec1)

% filespec1 = 'D:\Copy_ppt.pptx';
% filespec2 = 'D:\Paste_ppt.pptx';

ppt = actxserver('PowerPoint.Application');
op1 = invoke(ppt.Presentations,'Open',filespec1,[],[],0);
op2 = invoke(ppt.Presentations,'Open',filespec2,[],[],0);

slide_count1 = get(op1.Slides,'Count');
slide_count2 = get(op2.Slides,'Count');

k =slide_count2+1;
for i = 1 : slide_count1
    invoke(op1.Slides.Item(i),'Copy');
    invoke(op2.Slides,'Paste');
    
 
    % copy background
    col=get(op1.Slides.Item(i).Background.Fill.ForeColor,'RGB');
    %sol=get(op1.Slides.Item(i).Background,'Fill')
    
    sn=get(op2.Slides,'Count');
    set(op2.Slides.Item(sn),'FollowMasterBackground', 'msoFalse');
    %set(op2.Slides.Item(sn).Background,'Fill',sol)
    set(op2.Slides.Item(sn).Background.Fill.ForeColor,'RGB',col);
    
 
    k = k+1;
end
invoke(op2,'Save');
% invoke(op2,'SaveAs',filespec2,1);
invoke(op1,'Close');
invoke(op2,'Close');
invoke(ppt,'Quit');


