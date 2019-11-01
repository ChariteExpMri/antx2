
%%  find best rotation between two images (T2's)
% function [rot id]=findrotation(f1,f2,parafile, cleanup)
% f1         :sourceImage
% f2         :REFimage
% parafile: elastix parafile
% cleanup: 0/1 to delete processing-related Files
% optional: plotter: 0/1 to see  deviation between rots
%% example
% f1=fullfile(pwd,'t2_1.nii')
% f2=fullfile(pwd,'wt2_1.nii');%da solls hinn
% parafile=fullfile(pwd,'paraaffine4rots.txt')
% cleanup=0
%  [rot id]=findrotation(f1,f2,parafile, cleanup)
%% check: use > displaykey2(f1,f2);

function [rot id trafo gtb tb g metrics]=findrotation(f1,f2,parafile, cleanup,plotter)

% rot :rots of best id only
% id: do of best rots
% trafo :trafo of best id
% gtb..table with all possible rots x [id rots optimizeValue]

if exist('plotter')~=1; plotter=0; end
% clear


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% elastix -f FixedImage_i.mhd -m MovingImage_j.mhd -fMask FixedImageMask_i -p par0033<X>.txt -out outputdir
elastix=which('elastix.exe');
if isempty(elastix); error('elastix path not set');end

warning off;

pa    =fileparts(f1);
pat2 =fileparts(f2);
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
outdir    =fullfile(pat2,'outdir');
outimg  =fullfile(outdir,'result.0.nii');
outlog   =fullfile(outdir,'TransformParameters.0.txt');

bestimg =fullfile(pat2,'_bestROT.nii');
bestlog  =fullfile(pat2,'_bestROT.txt');
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
try;  rmdir(outdir,'s')   ;end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
tb=[...
    pi/2 pi pi%berlin-->ALLEN
    0 0 0
    0 pi 0
    0 0 pi
    pi/2 0 pi  ;%FB
    pi/2 0 0  ;%berlin
    pi pi/2 pi
    pi pi pi/2
    ];

if 0
    disp('findRotation ALLEN ONLY-...check metric');
    tb=[...
        pi/2 pi pi%berlin-->ALLEN
        ];
    
    
    %% kritikal rots
    tb=[...
        pi/2 pi pi%berlin-->ALLEN
        %     pi/2 0 pi  ;%FB
        ];
end

% %% full
% tp=[
%  0 0 0
% pi pi pi
% pi pi 0
% 0 pi pi
% pi 0 pi
% pi/2 pi/2 0
% 0 pi/2 pi/2
% pi/2 0 pi/2
% -pi/2 -pi/2 0
% 0 -pi/2 -pi/2
% -pi/2 0 -pi/2
%  pi 0 0
%  0  pi 0
%  0 0 pi
%   pi/2 0 0
%  0    pi/2 0
%  0 0   pi/2
%    -pi/2 0 0
%  0    -pi/2 0
%  0 0   -pi/2]
%



mkdir(outdir);
g=[];
tic
for i=1:size(tb,1)
    
    %     %% OLD
    %     f3=fullfile(pat2,'t2_findrotation.nii');
    %     copyfile(f1,f3);
    %     tb2=tb(i,:);%[pi/2 0 pi]
    %     preorient=[0 0 0 tb2 ];
    %     Bvec=[ [preorient]  1 1 1 0 0 0];  %wenig slices
    %     fsetorigin({f3}, Bvec);  %ANA
    %     v=['!' elastix  ' -f ' f2 ' -m ' f3 ' -out ' outdir ' -p ' parafile ];
    %     evalc(v);
    
    if 1
        f3=fullfile(pat2,'_t2_findrotation.nii');
        copyfile(f1,f3);
        tb2=tb(i,:);%[pi/2 0 pi]
        preorient=[0 0 0 tb2 ];
        Bvec=[ [preorient]  1 1 1 0 0 0];  %wenig slices
        fsetorigin({f3}, Bvec);  %ANA
        
        f222=fullfile(pat2,'_msk.nii');
        v=['!' elastix  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  parafile  ];
        %v=['!' elastix  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  fullfile(pwd,'trafoeuler.txt')   ];
        evalc(v);
        
        paras=get_ix(fullfile(outdir,'TransformParameters.0.txt'), 'TransformParameters');
        signs=[1    -1    -1    -1    -1     1];
        paras= paras.*signs;
        paras=[paras(4:6) paras(1:3) ];
        vvec=[ paras 1 1 1 0 0 0];
        vmat=spm_matrix(vvec);
        
        
        f33=fullfile(pat2,'_t2_findrotation2.nii');
        copyfile(f3,f33);
        v33=spm_vol(f33);
        matn=vmat;
        spm_get_space(f33, inv(matn)*v33.mat  );
        
        h1=spm_vol(f1); h33=spm_vol(f33);
        vector=spm_imatrix(h1.mat/h33.mat);
        newparas=vector(1:6);
        %         disp('neuer vector');
        %         disp(vector)
        
        
        [ht       t]= rreslice2target(f33, f222, [], 1);
        [hm  m ]=rgetnii(f222);
        
        %% MEASURES
        %        e1   =calcsimilarity(f33,f222);
        %        ovl  =(m~=0) & (t~=0); ;ovl=sum(ovl(:))/numel(ovl)  ; %overlap percent
        %        rms =sqrt(mean((t(:)-m(:)).^2));
        %        cor   =         corr(m(:),t(:));
%         [simi ]=calcMI(f33,f222);
     [simi ]=calcMI(f222,f33);
        
       [simi1 ]=calcMI(f33,f222);
     [simi2 ]=calcMI(f222,f33);
     simi=simi1+simi2;
     disp([ simi1 simi2 simi]);
     
        %==================
%         [gridpara ]=calcGridcorr(f33,f222);
%         disp(['grid: ' num2str(gridpara)]);
        
        %==================
        
        %      metrics(i,:) =  [e1 ovl rms cor simi]
        metrics=[];
        
        g(i,1)=simi(1);
        % (TransformParameters 0.064363 -0.091437 -0.149557 -0.100001 -0.200000 0.300002)
        % (TransformParameters 0.064363 -0.091437 -0.149557 -0.100000 -0.200000 0.300000)
        
        %% t2s=transformier: vec=[ .1 .2  .3   .05 .1   .15    1 1 1 0 0 0 ]
        %% [fix=t2 & mov=t2s]-->t2s auf t2 gewarpt
        %%  displaykey3inv(  t2,t2s); wieder aufeinandergebracht mit [ -.1 -.2  -.3   -.05 -.1   -.15 ]
        %% von t2s wieder zu t2 ueber die inverse der paras
        
        
        
        
    end
    
    
    if 0
        
        f00=fullfile(fileparts(f2),'_tpmgrey.nii')
        fm=fullfile(pat2,'_dum.nii');
        copyfile(f00,fm);
        
        tb2=tb(i,:);%[pi/2 0 pi]
        preorient=[0 0 0 tb2 ];
        Bvec=[ [preorient]  1 1 1 0 0 0];  %wenig slices
        fsetorigin({fm}, Bvec);  %ANA
        
        
        mousev=fullfile(fileparts(f2),'_msk.nii')
        tepmlv =fm;%fullfile(fileparts(f2),'_refIMG.nii')
        v=['!' elastix  ' -f ' mousev ' -m ' tepmlv ' -out ' outdir ' -p ' parafile ];
        evalc(v);
    end
    
    
    [ha a]=     rgetnii(f2);
    [hb b]=     rgetnii(outimg);
    %     g(i,1)=     sqrt(mean((a(:)-b(:)).^2));
    
    %     if i==6
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %         tic
    pat2=fileparts(f2);
    %w1=fullfile(pat2,'_b1grey.nii');
    %      w1=fullfile(pat2,'_b2white.nii');
    w1=fullfile(pat2,'_b3csf.nii');
    
    if 0
        w2=fullfile(pat2,'_graymatter.nii');
        copyfile(w1,w2,'f');
        fsetorigin({w2}, Bvec);  %ANA
        
        
        transformix=strrep(elastix,'elastix.exe','transformix.exe');
        tranformfile=dir(fullfile(outdir,'TransformParameters*.txt'));
        tranformfile=fullfile(outdir,tranformfile.name);
        %     fb=fullfile(pa,'_b1grey.nii')
        v2=['!' transformix  ' -in ' w2 ' -out ' outdir ' -tp ' tranformfile ];
        evalc(v2);
        
        
        w3=fullfile(outdir,'result.nii');
        [hc c]=rgetnii(w3);
    end
    
    
    if  0 %%LAST USED
        %         g(i,1)=  sqrt(mean((a(:)-c(:)).^2));
        ac=[a(:) c(:)];
        idx=ac(:,2)>.2;
        %          g(i,1)= sqrt(sum((ac(idx,1)-ac(idx,2)).^2));
        g(i,1)= corr(ac(idx,1),ac(idx,2));
        disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] R=%5.8g  ',[i  tb(i,:)  g(i,1)]));
        %   toc
    end
    
    if  0
        ids=c<.1;
        a2=a; a2(ids)=0;
        b2=b; b2(ids)=0;
        %b2=c; c2(ids)=0;
        
        r=zeros(1,size(a2,3));
        for j=1:size(a2,3)
            r(1,j)=  corr2(a2(:,:,j),b2(:,:,j));
        end
        g(i,1)=nanmedian(r);
        disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] r=%5.8g  ',[i  tb(i,:)  g(i,1)]));
    end
    
    
    %% last approach (worked!: ): correlation2d
    if 0
        [simi ]=calcsimilarity(f2,outimg);%gut
        %     [simi ]=calcsimilarity(f2,w3);
        g(i,1)=simi(1);
        disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] r=%5.8g  ',[i  tb(i,:)  g(i,1)]));
    end
    
    
    %% Mutual information
    if 0
        
        %         wsample=fullfile(fileparts(w2),'_sample.nii');
        %         v22=['!' transformix  ' -in ' wsample ' -out ' outdir ' -tp ' tranformfile ];
        %         evalc(v22);
        %
        %         refIMG='O:\harms1\harmsTest_ANT\dat\s20150505SM01_1_x_x\outdir\result.nii';
        
        %  [simi ]=calcparasovl(f2,outimg);%GUT
        [simi ]=calcMI(f2,outimg);%GUT
        g(i,1)=simi(1);
        %         disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] MI=%5.8g  ',[i  tb(i,:)  g(i,1)]));
    end
    
    
    if 1
        
        %get TRAFO
        %         logf=preadfile2(tranformfile);
        %         itraf=find(cellfun('isempty',strfind(logf,'(TransformParameters'))==0);
        %         trafounsorted=str2num(char(regexprep(logf(itraf),'[A-z()]',' ')));
        %         trafo=[ trafounsorted(4:6)  trafounsorted(1:3) ];
        %         trafo(4:6)=trafo(4:6)+ tb(i,:);
        %         trafo(3)=-trafo(3);
        
        %gtb(i,:)= [i g(i,1) {trafo}];
        
        %% NEW
        trafo=newparas ;
        gtb(i,:)= [i g(i,1) {newparas}];% NEW USING PARAS DIRECTLY FROM PARAFILE
    end
    %%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %     end
    
    if i==1
        gmin=g(i,1);
    end
    %     if g(i,1)<=gmin
    if g(i,1)>=gmin
        gmin=g(i,1);
        copyfile(outimg,bestimg,'f');
        copyfile(outlog,bestlog,'f');
        %         disp(['best image:  '  num2str(i)]);
        %         disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] RMS=%5.5g  ',[i  tb(i,:)  gmin]));
    end
    
end
toc

%======================
id=find(g==max(g));
% id=find(g==min(g));
rot   =tb(id,:);

%get TRAFO
% logf=preadfile2(bestlog);
% itraf=find(cellfun('isempty',strfind(logf,'(TransformParameters'))==0);
% trafounsorted=str2num(char(regexprep(logf(itraf),'[A-z()]',' ')));
% trafo=[ trafounsorted(4:6)  trafounsorted(1:3) ];
% trafo(4:6)=trafo(4:6)+ tb(id,:);
% trafo(3)=-trafo(3);

%% NEW

trafo=gtb{id,3};
%% OUTDISP
disp('===========================================');
disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] R=%5.5g  ',[id  rot g(id)]));
disp('===========================================');



try;  delete(f3); end



if cleanup==1
    try;  rmdir(outdir,'s')   ;end
    try; delete(w2);end
    
end
if plotter==1
    
    hf=findobj(0,'tag','Interactive2');
    if isempty(hf)
        figure; set(gcf,'units','normalized','color','w');
        set(gcf,'position',[    0.7601    0.5944    0.2330    0.2800]);
    else
        set(0,'currentfigure', hf) ;
    end
    ax1=axes('position',[.06 .05 .72  .9]);
    plot(g,'ob-','linewidth',1.5,'markerfacecolor','b');
    %     set(gca,'fontweight','bold')
    ti=title('Korrelation [T2,sampleAllen]..best TRAFOs [FORWARDTRAFO]');
    set(ti,'verticalalignment','top','fontweight','bold');
    if length(g)>1
        xlim([1 length(g)]);
    end
    hold on;
    pl=[];
    tx={'***TRAFOS {FORWARD}***'};
    tx{end+1,1}=['   * from ALLEN to T2'];
    for i=1:size(tb,1);
        pl(i)=plot(i,g(i),'ob','markerfacecolor','b');
        tx{end+1,1}=sprintf('%2.2d] %5.2f %5.2f %5.2f',[i tb(i,:)]);
    end
    box off; grid on
    
    %     h=legend(pl,tx)
    ax2=axes('position',[.78 .05 .25 1]);
    te=text(0,.5,tx,'fontsize',10);
    uistack(ax2,'bottom'); axis off;
    
    
    try;
        set(0,'currentfigure', findobj(0,'tag','Graphics'));
        figure( findobj(0,'tag','Graphics'));
        
    end
end

disp(metrics);
assignin('base', 'metrics', metrics)

return
