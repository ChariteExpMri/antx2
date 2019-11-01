
%% simple check overlay  
function gifoverlay(t1,t2,outname,resol, interpx ,strtag)

 
% pathdata='C:\Dokumente und Einstellungen\skoch\Desktop\allenAtlas\MBAT_WHS_atlas_v0.6.2\MBAT_WHS_atlas_v0.6.2\Data'
pathdata=pwd;

% [t,sts] = spm_select(inf,'dir','SEGMENTATION select Directories','',pathdata,'.*');
% if isempty(t);
%     disp('no folders selected'); 
%     return
% end
% paths=cellstr(t);
% 
% %% loop through
%  

 
    
%     [t1] = spm_select('FPList',[paths{i}  ],'^s.*nii$') ; %t1   =cellstr(t);
% %     [t2] = spm_select('FPList',[paths{i}  ],'W*.*nii$') ;% t2   =cellstr(t);
% [t2]=spm_select
    ls={t1; t2  };
     
    
    paout= (pathdata );
 
    if ~exist('interpx')
        interpx=1;
    end
     if ~exist('strtag')
        strtag='';
    end
    [h ad]=ovlAtlas(ls,interpx,strtag);
    figure(gcf);
    if 1
%        resol='-r300'
 
       print(gcf,'-djpeg',resol,fullfile(paout, 'vv1.jpg'));
        
       delete(h);
%        ad(ad~=0)=0;
%        ad(ad==0)=0;
%        set(h, 'AlphaData', ad);
         figure(gcf);
       drawnow;pause(.1);
       print(gcf,'-djpeg',resol,fullfile(paout, 'vv2.jpg'));
   end
   %%*****************************************

   if 1
       [pa fi]= fileparts(t1);
       ls2={
           fullfile(paout,  'vv1.jpg');
           fullfile(paout,  'vv2.jpg');
           };
       %        makegif(fullfile(paout, [outname '.gif'])  ,ls2,.3);
       %        makegif(fullfile(paout, [outname '.gif'])  ,ls2,.3);
       %
       [pa fi]=fileparts(outname);
       makegif(fullfile(pa, [fi '.gif'])  ,ls2,.3);
       
       delete(paout,  'vv1.jpg');
       delete(paout,  'vv2.jpg');
   end
   %      close all


   
 