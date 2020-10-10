
%%  find best rotation between two images (T2's)
%  [rot id trafo gtb tb g metrics]=findrotation2(f1,f2,params,parafile, cleanup,plotter)
%  rots=findrotation2()  ...calling findrotation2 without inputs   outputs the orientationTable
%
%% INPUTS
% f1         :REFimage  (IMAGE IN ALLEN SPACE)
% f2         :SOURCEImage (IMAGE IN MOUSE SPACE)
% paras      :parameters defined as struct, with following field(s):
%
%    * orientType  specifies the mouse orientation from the orientationTable
%              orientTable=[...                ORIENTATIONTABLE
%                   pi/2 pi pi   % native mouse position BERLIN
%                   0 0 0
%                   0 pi 0
%                   0 0 pi
%                   pi/2 0 pi  ; % native mouse position Freiburg & Munich
%                   pi/2 0 0   ;
%                   pi/2 pi 0  ;%"flip" inferior-superior, "flip" posterior-anterior
%                   pi pi/2 pi ;
%                   pi pi pi/2 ;
%                   ];
%            -orientType is a nuber that refers to the row of the orientTable
%            -example: orientType is set to 1: this refers to the mouse orientation as it is acquired in Berlin
%            -if orientType is an array of indices (example [1 4] or [1:8]) the best orientation is
%                estimatated across index-related orientations of the orientationTable
%            -if  orientType=inf; the best orientation is estimated from all entries in the orientationtable
%            -if orientType is of class char and the string contains 3 rotations (example: 'pi 0 -pi'), this orientation is used
%          examples:
%                 params.orientType =[inf]; %
%                 params.orientType ='pi pi pi';
%                 params.orientType =1;
%                 params.orientType  = 2:5
%
% parafile: elastix PARAMETERFILE
% cleanup: 0/1 to delete processing-related Files
% optional: plotter: 0/1 to see  deviation between rots
%-------------------------------------------------------------------------------------------
%% EXAMPLE
% iref    ='O:\data2\muenchen_importbug\dat\hab2\_sample.nii';
% isource ='O:\data2\muenchen_importbug\dat\hab2\t2.nii'
% params.orientRefimageType  = 2
% parafile='o:\antx\mritools\elastix\paramfiles\trafoeuler.txt'
% params.orientType=inf
% [rot id trafo ]=findrotation2(iref ,isource,params ,parafile, 1,1);
%-------------------------------------------------------------------------------------------
%% check: use > displaykey2(f1,f2);

function [rot id trafo gtb tb g metrics]=findrotation2(f1,f2,params,parafile0, cleanup,plotter)

otc={...
    'pi/2 pi pi'%berlin-->ALLEN
    '0 0 0'
    '0 pi 0'
    '0 0 pi'
    'pi/2 0 pi'  ;%FB
    'pi/2 0 0'  ;%berlin
    'pi/2 pi 0'  ;%"flip" inferior-superior, "flip" posterior-anterior
    'pi pi/2 pi'
    'pi pi pi/2'
    'pi/2 pi 0'  ;%Wu/salamancha
    'pi 0 pi/2'
    '0 0 pi/2'
   % 'pi  pi/2 0' %8: 'pi pi/2 0'
    };

orientTable=cell2mat(cellfun(@(a){str2num(a)},otc));
% orientTable=[...                ORIENTATIONTABLE
%     pi/2 pi pi%berlin-->ALLEN
%     0 0 0
%     0 pi 0
%     0 0 pi
%     pi/2 0 pi  ;%FB
%     pi/2 0  0  ;%berlin
%     pi/2 pi 0  ;%"flip" inferior-superior, "flip" posterior-anterior
%     pi pi/2 pi
%     pi pi pi/2
%     ];

if nargin==0
    rot= otc;
    disp([ num2cell([1:size(rot,1)]')  rot]);
    return
end



% rot :rots of best id only
% id: do of best rots
% trafo :trafo of best id
% gtb..table with all possible rots x [id rots optimizeValue]

if exist('plotter')~=1; plotter=0; end


if exist('params')~=1  %PARAMETER-STRUCT
    % params.orientTable=
    params.orientType=1;
end

elastix=which('elastix.exe');
if isempty(elastix); error('elastix path not set');end

warning off;

pat2    = fileparts(f2);
outdir  = params.outdir;
outimg  = fullfile(outdir,'result.0.nii');
outlog  = fullfile(outdir,'TransformParameters.0.txt');

bestimg = fullfile(outdir,'_bestROT.nii');
bestlog = fullfile(outdir,'_bestROT.txt');





%-----------------------------------------------------------------------------
% orientTable=[...                ORIENTATIONTABLE
%     pi/2 pi pi%berlin-->ALLEN
%     0 0 0
%     0 pi 0
%     0 0 pi
%     pi/2 0 pi  ;%FB
%     pi/2 0  0  ;%berlin
%     pi/2 pi 0  ;%"flip" inferior-superior, "flip" posterior-anterior
%     pi pi/2 pi
%     pi pi pi/2
%     ];

if ischar(params.orientType) % use specific orientation (defined as char)
    q = str2num(params.orientType);
elseif length(params.orientType)==1 && isinf(params.orientType); %use all orientations
    q = orientTable;
else %use one or more orientations
    ivalid = params.orientType>0 & params.orientType<=size(orientTable,1);
    q      = orientTable(params.orientType(ivalid),:);
end
tb = q;  % use this orientationtable



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


% try; rmdir(outdir,'s')   ;end
try; delete(fullfile(outdir,'*.log')); end
try; delete(fullfile(outdir,'*.txt')); end
try; delete(outimg); end
% try; mkdir(outdir);end

[~ ,parafileDum] = fileparts(parafile0);
parafile         = fullfile(outdir,[parafileDum '.txt'] );
copyfile(parafile0,parafile,'f');

g=[];
% tic
for i=1:size(tb,1)
    
    f3        = fullfile(outdir,'_rigidtemplateRotated.nii'); %previous name: '_t2_findrotation'
    copyfile(f1,f3,'f');
    %f3  = f1;
    tb2       = tb(i,:);%[pi/2 0 pi]
    preorient = [0 0 0 tb2 ];
    Bvec      = [ [preorient]  1 1 1 0 0 0];  %wenig slices
    fsetorigin({f3}, Bvec);  %ANA
    
    %f222=fullfile(pat2,'_msk.nii'); % PROBLEM WITH BIAS_FIELD-ERROR
    %f222=fullfile(pat2,'t2.nii' );
    f222 = f2;
    
    % ##########################################################################################
    %% OLD
    if 0 %old
        if ispc==1
            v=['!' elastix  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  parafile  ];
            %v=['!' elastix  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  fullfile(pwd,'trafoeuler.txt')   ];
            evalc(v);
        elseif ismac==1
            ela=elastix4mac;
            %w='/Volumes/O/antx/mritools/elastix/elastix_macosx64_v4.7/elastix_macosx64_v4.7/bin/elastix'
            try
                pathis=pwd;
                cd(ela.pa);
                evalc([ '!' ela.E  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  parafile  ]);
            end
            cd(pathis);
        else
            v=evalc(['!elastix'  ]);
            if~isempty(strfind(v,'Use "elastix --help" for information'));
                
                v=['!elastix -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  parafile  ];
                evalc(v);
            else
                error('ELASTIX for LINUX is not installed --> see /doc/linux_troubleshoot.txt ');
            end
        end
        
        paras = get_ix(fullfile(outdir,'TransformParameters.0.txt'), 'TransformParameters');
        signs = [1    -1    -1    -1    -1     1];
        paras = paras.*signs;
        paras = [paras(4:6) paras(1:3) ];
        vvec  = [ paras 1 1 1 0 0 0];
        vmat  = spm_matrix(vvec);
    end
    
      % ##########################################################################################
    %% new but INVERSE ##############################################
    % =======================================================
    
    
    
    %  set_ix(parafile,'ComputeZYX','false');
    set_ix(parafile,'CenterOfRotationPoint',[0 0 0]);
    set_ix2(parafile,'AutomaticTransformInitializationMethod','CenterOfGravity');
   
    %set_ix2(parafile,'UseDirectionCosines','true')
    % (UseDirectionCosines "true")
    % (AutomaticScalesEstimation "true")
    % (AutomaticTransformInitialization "true")
    
    
    
    if ispc==1
        v=['!' elastix  ' -f ' f3 ' -m ' f222 ' -out ' outdir ' -p '  parafile  ];
        %v=['!' elastix  ' -f ' f222 ' -m ' f3 ' -out ' outdir ' -p '  fullfile(pwd,'trafoeuler.txt')   ];
        evalc(v);
    elseif ismac==1
        ela=elastix4mac;
        %w='/Volumes/O/antx/mritools/elastix/elastix_macosx64_v4.7/elastix_macosx64_v4.7/bin/elastix'
        try
            pathis=pwd;
            cd(ela.pa);
            evalc([ '!' ela.E  ' -f ' f3 ' -m ' f222 ' -out ' outdir ' -p '  parafile  ]);
        end
        cd(pathis);
    else
        v=evalc(['!elastix'  ]);
        if~isempty(strfind(v,'Use "elastix --help" for information'));
            
            v=['!elastix -f ' f3 ' -m ' f222 ' -out ' outdir ' -p '  parafile  ];
            evalc(v);
        else
            error('ELASTIX for LINUX is not installed --> see /doc/linux_troubleshoot.txt ');
        end
    end
    
    %     paras =
    %     0.1097    0.3683   -0.0150   31.6267   -1.5197   22.3233
    
    
    %% [] extract elastix parameter
    %% ============================================
    %rmricron([],fullfile(fileparts(f3),'result.0.nii'),f3,1); % CHECK
    paras  = get_ix(fullfile(outdir,'TransformParameters.0.txt'), 'TransformParameters');
    signs  = [1     -1    -1    -1    -1     1]; %orig
    paras2 = paras.*signs;
    vvec   = [ paras2(4:6) paras2(1:3)  1 1 1 0 0 0];
    vmat   = spm_matrix(vvec);
    
    
    %%  MI-approach  -------- workAround, I previously failed o extract the 'right' parameters
    if strcmp(get_ix(parafile,'Metric'), 'AdvancedMattesMutualInformation')==1
        paras=getorientviadots(f222,f3, parafile,[], 2000,0,1);
        vvec   = [ paras(1:3) paras(4:6)  1 1 1 0 0 0];
        vmat   = spm_matrix(vvec);
    end
    
    
   
    
    
    %% [] overlay images in MOUSESPACE (PREROTATED NORMSPACE transformed to MOUSESPACE)
    %% OVL: rigidmouse.nii + translate+rotate _rigidtemplateRotated.nii
    %% ============================================
    f5 =fullfile(fileparts(f3),'test1.nii');
    try; delete(f5); end
    copyfile(f3,f5,'f');
    v5    = spm_vol(f5);
    matx  = vmat;
    spm_get_space(f5,   (matx)*v5.mat  );
    %rmricron([],f222,f5,1);
    
    %% []  overlay images in PREROTATED NORMSPACE
    %% OVL: translate+rotate rigidmouse.nii &  _rigidtemplateRotated.nii
    %% ============================================
    if 0
        f222test=fullfile(fileparts(f222),'test2.nii');
        try; delete(f222test); end
        copyfile(f222,f222test,'f');
        
        vx  = spm_vol(f222test);
        spm_get_space(f222test,   inv(matx)*vx.mat  );
        rmricron([],f222test,f3,1);
    end
    
    
    matn=inv(matx);
    
    %vector   = spm_imatrix(matx) ;
    %newparas = vector(1:6);
    
    
    %% [] GET MEASURES
    %% ============================================
    if size(tb,1)>1
        [simi ] = calcMI(f222,f5);
        
        [simi1] = calcMI(f5   ,f222);
        [simi2] = calcMI(f222 ,f5);
        simi    = simi1+simi2;
        if plotter==1
            disp([i simi1 simi2 simi]);
        end
    else
        [simi1 simi2 simi] =deal(0);
        
    end
    
    
    %% [] get NEWPARAS without a-priory rotations
    %% ============================================
    f33  = fullfile(outdir,'_rigidtemplateRotated2.nii'); % previous NAme: '_t2_findrotation2.nii');
    copyfile(f3,f33);
    f33  = f3;
    v33  = spm_vol(f33);
    matn = vmat;
    spm_get_space(f33, (matn)*v33.mat  );
    
    h1       = spm_vol(fullfile(fileparts(pat2),'AVGT.nii'));
    h33      = spm_vol(f33);
    vector   = spm_imatrix(h1.mat/h33.mat);
    newparas = vector(1:6);
    
    %% [] create "best_rot.image"
    %% ======================================
    outimg2   = fullfile(outdir,'_bestrotTest.nii') ;
    inp       = fullfile(fileparts(pat2),'_b1grey.nii') ;
    copyfile(inp,outimg2,'f')
    voutimg2  = spm_vol(outimg2);
    
    vec2      =[ [newparas]  1 1 1 0 0 0];
    fsetorigin(outimg2,   spm_imatrix(inv(spm_matrix(vec2)))    );
    %rmricron([],fullfile(fileparts(pat2),'t2.nii'),outimg2,1); %CHECK
    outimg = outimg2;
    
    if 0
        
        %% bla ##############################################
        
        % dont need
        f33  = fullfile(outdir,'_rigidtemplateRotated2.nii'); % previous NAme: '_t2_findrotation2.nii');
        copyfile(f3,f33);
        f33  = f3;
        
        v33  = spm_vol(f33);
        matn = vmat;
        spm_get_space(f33, inv(matn)*v33.mat  );
        
        
        
        
        %h1       = spm_vol(f1);
        h1        =spm_vol(fullfile(fileparts(pat2),'AVGT.nii'));
        h33      = spm_vol(f33);
        vector   = spm_imatrix(h1.mat/h33.mat);
        newparas = vector(1:6);
        
        [ht  t] = rreslice2target(f33, f222, [], 1);
        [hm  m] = rgetnii(f222);
        
        
        %% MEASURES
        %        e1   =calcsimilarity(f33,f222);
        %        ovl  =(m~=0) & (t~=0); ;ovl=sum(ovl(:))/numel(ovl)  ; %overlap percent
        %        rms =sqrt(mean((t(:)-m(:)).^2));
        %        cor   =         corr(m(:),t(:));
        %         [simi ]=calcMI(f33,f222);
        
        if size(tb,1)>1
            [simi ] = calcMI(f222,f33);
            
            [simi1] = calcMI(f33,f222);
            [simi2] = calcMI(f222,f33);
            simi    = simi1+simi2;
            if plotter==1
                disp([i simi1 simi2 simi]);
            end
        else
            [simi1 simi2 simi] =deal(0);
            
        end
    end
    
    %==================
    metrics = [];
    g(i,1)  = simi(1);
    % (TransformParameters 0.064363 -0.091437 -0.149557 -0.100001 -0.200000 0.300002)
    % (TransformParameters 0.064363 -0.091437 -0.149557 -0.100000 -0.200000 0.300000)
    
    %% t2s=transformier: vec=[ .1 .2  .3   .05 .1   .15    1 1 1 0 0 0 ]
    %% [fix=t2 & mov=t2s]-->t2s auf t2 gewarpt
    %%  displaykey3inv(  t2,t2s); wieder aufeinandergebracht mit [ -.1 -.2  -.3   -.05 -.1   -.15 ]
    %% von t2s wieder zu t2 ueber die inverse der paras
    
    %
    %     [ha a] =  rgetnii(f2);
    %     [hb b] =  rgetnii(outimg);
    
    
    %get TRAFO
    %         logf=preadfile2(tranformfile);
    %         itraf=find(cellfun('isempty',strfind(logf,'(TransformParameters'))==0);
    %         trafounsorted=str2num(char(regexprep(logf(itraf),'[A-z()]',' ')));
    %         trafo=[ trafounsorted(4:6)  trafounsorted(1:3) ];
    %         trafo(4:6)=trafo(4:6)+ tb(i,:);
    %         trafo(3)=-trafo(3);
    
    %gtb(i,:)= [i g(i,1) {trafo}];
    
    
    trafo    = newparas ;
    
    
    gtb(i,:) = [i g(i,1) {newparas}];% NEW USING PARAS DIRECTLY FROM PARAFILE
    
    
    
    
    if i==1
        gmin = g(i,1);
    end
    %     if g(i,1)<=gmin
    if g(i,1)>=gmin
        gmin = g(i,1);
        if size(tb,1)==1
            try; movefile(outimg,bestimg,'f');end
            try; movefile(outlog,bestlog,'f');end
        else
            copyfile(outimg,bestimg,'f');
            copyfile(outlog,bestlog,'f');
        end
    end
    
end
% toc

%===================================================================
id    = find(g==max(g));
rot   = tb(id,:);
trafo = gtb{id,3};
%% OUTDISP
if  size(tb,1)>1
    disp('===========================================');
    disp(sprintf('best rotation #%d  [%2.3f  %2.3f  %2.3f ] R=%5.5g  ',[id  rot g(id)]));
    disp('===========================================');
end


try;  delete(f3); end
try; delete(outimg); end



% % % % % % % % % % if cleanup==-1
% % % % % % % % % %     try;  rmdir(outdir,'s')   ;end
% % % % % % % % % %     try; delete(w2);end
% % % % % % % % % %
% % % % % % % % % % end

% % % %
% % % % if plotter==1
% % % %
% % % %     hf=findobj(0,'tag','Interactive2');
% % % %     if isempty(hf)
% % % %         figure; set(gcf,'units','normalized','color','w');
% % % %         set(gcf,'position',[    0.7601    0.5944    0.2330    0.2800]);
% % % %     else
% % % %         set(0,'currentfigure', hf) ;
% % % %     end
% % % %     ax1=axes('position',[.06 .05 .72  .9]);
% % % %     plot(g,'ob-','linewidth',1.5,'markerfacecolor','b');
% % % %     %     set(gca,'fontweight','bold')
% % % %     ti=title('Korrelation [T2,sampleAllen]..best TRAFOs [FORWARDTRAFO]');
% % % %     set(ti,'verticalalignment','top','fontweight','bold');
% % % %     if length(g)>1
% % % %         xlim([1 length(g)]);
% % % %     end
% % % %     hold on;
% % % %     pl=[];
% % % %     tx={'***TRAFOS {FORWARD}***'};
% % % %     tx{end+1,1}=['   * from ALLEN to T2'];
% % % %     for i=1:size(tb,1);
% % % %         pl(i)=plot(i,g(i),'ob','markerfacecolor','b');
% % % %         tx{end+1,1}=sprintf('%2.2d] %5.2f %5.2f %5.2f',[i tb(i,:)]);
% % % %     end
% % % %     box off; grid on
% % % %
% % % %     %     h=legend(pl,tx)
% % % %     ax2=axes('position',[.78 .05 .25 1]);
% % % %     te=text(0,.5,tx,'fontsize',10);
% % % %     uistack(ax2,'bottom'); axis off;
% % % %
% % % %
% % % %     try;
% % % %         set(0,'currentfigure', findobj(0,'tag','Graphics'));
% % % %         figure( findobj(0,'tag','Graphics'));
% % % %
% % % %     end
% % % % end

disp(metrics);
assignin('base', 'metrics', metrics)

return
