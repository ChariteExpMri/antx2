

warning off
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
parafiles={'V:\mritools\elastix\paramfiles\Par0025affine.txt'
                 'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'}
pa=pwd

z.fixim    =fullfile(pa,'templateGMWM.nii')
z.movim =fullfile(pa,'mouseGMWM.nii')

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% 1st copy parameterFiles
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
parafiles2=replacefilepath(stradd(parafiles,'x',1),pa);
for i=1:length(parafiles2)
    copyfile(parafiles{i},parafiles2{i},'f');
end
parafiles=parafiles2;


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% run Elastix : forwardDirection
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
z.outforw=fullfile(pa,'elastixForward'); mkdir(z.outforw);
[im,trfile] = run_elastix(z.fixim,z.movim,    z.outforw  ,parafiles,[], []       ,[],[],[]);
   
%% example TEST-forward
trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt'))
trafofile=fullfile(z.outforw,trafofile(end).name);

z.im2warp=fullfile(pa,'t2.nii')
 [im2,tr2] = run_transformix(z.im2warp,[],trafofile,[],'');     


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% run Elastix : backWardDirection
%•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 
 %% copy PARAMfiles
 parafilesinv=stradd(parafiles,'inv',1)
 for i=1:length(parafilesinv)
    copyfile(parafiles{i},parafilesinv{i},'f');
    pause(.01)
    rm_ix(parafilesinv{i},'Metric'); pause(.1) 
    set_ix(parafilesinv{i},'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
 end
 
 trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt'))
trafofile=fullfile(z.outforw,trafofile(end).name)
 
z.outbackw=fullfile(pa,'elastixBackward'); mkdir(z.outbackw);
[im3,trfile3] = run_elastix(z.movim,z.movim,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[]);
 trfile3=cellstr(trfile3)
%set "NoInitialTransform" in TransformParameters.0.txt.
set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');


%% example TEST-backward
trafofile=dir(fullfile(z.outbackw,'TransformParameters*.txt'))
trafofile=fullfile(z.outbackw,trafofile(end).name);

z.im2warpinv=fullfile(pa,'sAVGT.nii')
 [im4,tr4] = run_transformix(z.im2warpinv,[],trafofile,[],'');    
im4=cellstr(im4)
 

%% example TEST-backward
z.im2warpinv={  fullfile(pa,'sAVGT.nii')  fullfile(pa,'_b1grey.nii') }
z.im2warpinvInterp=[3 -1]


trafofile=dir(fullfile(z.outbackw,'TransformParameters*.txt'))
trafofile=fullfile(z.outbackw,trafofile(end).name);


for i=1:length(z.im2warpinv)
    
    if z.im2warpinvInterp(i)==-1 %TPMs -->between 0 and 1
        [ha  a]=rgetnii( z.im2warpinv{i});
        range1=[min(a(:))  max(a(:))]
        dt=ha.dt;
        pinfo=ha.pinfo;
        
        
        ha.dt=[16 0];
        
        a=a.*10000;
        tempfile=fullfile(fileparts(z.im2warpinv{i}),['_elxTemp.nii'])
        rsavenii(tempfile,  ha,a )
        set_ix(trafofile,'FinalBSplineInterpolationOrder',    3);
        [im4,tr4] = run_transformix(  tempfile ,[],trafofile,[],'');
        
        %% set original range
          [hb  b]=rgetnii( im4);
          b2=b./10000;
          newfile=stradd(z.im2warpinv{i},'ix' ,1 );
          rsavenii(newfile,  hb,b2 );
          if 0
              hb.dt=dt;
              hb.pinfo=pinfo
              %           b2=b./10000;
              b2=b;
              b2=b2-min(b2(:));
              b2=b2./max(b2(:));
              b2=(b2.*(range1(2)-range1(1)))+range1(1);
              range2=[min(b2(:))  max(b2(:))] ;%check range
          newfile=stradd(z.im2warpinv{i},'ix' ,1 );
          rsavenii(newfile,  hb,b2 )
          end
          try; delete(tempfile);end
          try; delete(im4);end
    else
    
     set_ix(trafofile,'FinalBSplineInterpolationOrder',    z.im2warpinvInterp(i));
     [im4,tr4] = run_transformix(  z.im2warpinv{i} ,[],trafofile,[],'');    
     
     [pas fis ext]=fileparts(im4); %RENAME FILE
     fis=strrep(fis,'elx_','ix_');
     movefile(im4,  fullfile(pas, [fis ext])  );
    end
end







 
%             [im,trfile] = run_elastix(z.ir,z.iw,outfold,pfiles,[], z.lesioninv       ,[],[],[]);
%             set_ix(trfile,'FinalBSplineInterpolationOrder',0);
%                     [im2,tr2] = run_transformix(trafi,[],trfile,[],'');
%               set_ix(trfile,'FinalBSplineInterpolationOrder',3);
%                     [im2,tr2] = run_transformix(trafi,[],trfile,[],'');         