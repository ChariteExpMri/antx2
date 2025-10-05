
%% #m RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%
%
% o=xgetpreorientAuto ; %open GUI
% o=xgetpreorientAuto(0) ; % no GUI & use defaults
% o=xgetpreorientAuto(0,struct('verbose',1));
% o=xgetpreorientAuto(0,struct('verbose',1,'NumberOfResolutions',3,'MaximumNumberOfIterations',50));
%
% OUTPUT: o-struct is a cellarray-table (animals x 4) containing 'animalName' 'rotation' 'rotID' 'metric'
%        example:   '1001_copy2'    'pi/2 pi pi'    [1]    [0.2715]
%      or when 2 animals are tested:
%                         'showknecht_1'    'pi/2 pi pi'    [1]    [0.1650]
%                         'showknecht_2'    'pi/2 pi pi'    [1]    [0.1733]
%




function varargout=xgetpreorientAuto(showgui,x,pa)
warning off;

isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=struct()                ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end
% ==============================================
%%   parameter files
% ===============================================


pa_parameterfiles =(fullfile(fileparts(antpath),'elastix','paramfiles'));
% parameterFile  ={fullfile(pa_parameterfiles ,'parameters_Rigid3Dfast.txt')} ;
parameterFile  ={fullfile(pa_parameterfiles ,'rigid_meansquare_mask.txt')} ;



if nargout==1
    varargout{1}=[];
end


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    
'mode'            1       'mode: [1] use "t2.nii" ;[2] use scullscripped version of "t2.nii"  {1|2}; default: [1]'  {1 2 }
%---------
'parameterFile'   parameterFile 'Elastix-3D-RIGID-paramer-file'  {@getparmfiles }

'rottable'    1    'table with rotations: [1]small table [2] extended table(more rotations)' {1 2}


'verbose'       [1]       'display info in cmd-windows {0|1}'  'b'
'plotMetric'    [1]       'bar-plot, display metric across rotations; [0|1]'   'b'
'plotOvleray'   [1]       'plot overlay of best rotation [0|1|2], [1] and [2] are different visualizations'   {0 1 2}
'targetShrinkFactor'  [3]    'shrink targetsize by this factor (AVGTmask)'  { 0 1 2 3}


'inf4000' '' '' ''
'debug'         [0]       'debugMode: {0|1}, of [1] plot every orientation'  'b'
'cleanup'       [1]       'do cleanup. Remove temporary processing folder, {0|1}; default: [1]'  {0 1}

%     'isParallel'   [0]       'parallel processing  , {0|1}; default: [0]'   'b'


'inf3000'        ''                           '' ''
'inf3'  '___ELASTIX_PARAMETER_SPECS___'  ' ' ' '
'MaximumNumberOfIterations'   []    'number of iterations (if empty use number of iterations as specified in parameter-file)'   {100 1000 1500 2000}
'NumberOfResolutions'         []    'number of resolutions (if empty use number of resolutions as specified in parameter-file)'   {1:6}
};


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .6 .25 ],...
        'title',['***get orientation of study''s "t2.nii"***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end



% ==============================================
%%   run
% ===============================================


% return

pa=cellstr(pa);

% z.dirs          =antcb('getsubjects');
% z.parameterfile =fullfile('F:\data7\automaticCoreg','parameters_Rigid3Dfast.txt')
% z.mode=2;
%% ===============================================
disp([ '..running: ' mfilename '.m']);
o={};
for i=1:length(pa)
    
    z2=z;
    z2.mdir=pa{i};
    [~,animal]=fileparts(z2.mdir);
    cprintf('*[0 .5 0]',[['___['   num2str(i) '] '    ' "' animal '" ' repmat('_',[1 10]) ]  '\n'] );
    [u ms]=proc(z2);
    if ~isempty(u)
        o(end+1,:)={u.animal u.bestrot  u.ixbest  u.bestmetric} ;
        
        
        %===============================================
        disp([ 'animal:"' o{i,1} '"'  char(8594)   ]);
        msg=[char(8594) ' best metric:[' num2str(o{i,4}) '],'  ...
            ' IDX:[' num2str(o{i,3}) '],' ...
            ' ROT:[' o{i,2} ']' repmat(' ',[1 12-length(o{i,2})]) ...
            ];
        cprintf('*[0 .5 0]',[msg  '\n'] );
    else
        disp(ms);
    end
    
    %===============================================
end
%% ===============================================


if nargout==1
    varargout{1}=o;
end


function [o ms]=proc(z)
%  o.dumm1=1;
[~,animal]=fileparts(z.mdir);
o.animal=animal;
% ==============================================
%%   intial
% ===============================================

ft1=fullfile(z.mdir,'t2.nii');
ft2=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');




if 0
    ft1=fullfile(z.mdir,'06_1_MPM_3D_0p15_pd_exvivo_23.nii');
    ft2=fullfile(z.mdir,'06_2_MPM_3D_0p15_t1_exvivo_24.nii');
end
% if 0
%     ft1=fullfile(z.mdir,'02_T2_TurboRARE_12.nii');
%     ft2=fullfile(z.mdir,'06_2_MPM_3D_0p15_t1_exvivo_24.nii');
% end
if 0
    
    
    ft1=fullfile(z.mdir,'02_T2_TurboRARE_12.nii');
    ft2=fullfile(z.mdir,'06_2_MPM_3D_0p15_t1_exvivo_24.nii');
end


[~,source]=fileparts(ft1);
[~,target]=fileparts(ft2);
isexist=[exist(ft1) exist(ft2)]./2;
ms='';
if sum(isexist)~=2
    o=[];
    [ms1 ms2]=deal('');
    if isexist(1)==0; ms1=[ '"'  source '.nii" not found']; end
    if isexist(2)==0; ms2=[ '"' target '".nii" not found']; end
    ms3=strjoin({ms1;ms2}, ' | ');
    ms=[ 'error animal:[' animal ']: ' ms3 ];
    disp(ms);
    return
end

if z.mode==1
    f1=ft1;
    %f1=fullfile(z.mdir,'t2.nii');
else
    
    f1=fullfile(z.mdir,'_msk.nii');
    if exist(f1)~=2
        xwarp3('batch','mdirs',{z.mdir},'task',[1],'autoreg',1);
    end
end

%% ============[ref-img/TARGET ]===================================
if 0
    f2orig=fullfile(fileparts(fileparts(z.mdir)),'templates','_b1grey.nii');
    %f2orig=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');
    f2=fullfile(z.mdir,'_temp4initialorientation.nii');
    copyfile(f2orig,f2,'f');
end
useAVGT=0;
if strcmp(target,'AVGT') || strcmp(target,'AVGTmask')
    useAVGT=1;
end
% useAVGT=0;


if 1
    if useAVGT==1
        %  f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','_b1grey.nii');
        %      f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','_b3csf.nii');
        %f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');
        f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGTmask.nii');
        [ha a]=rgetnii(f2orig1);
        %[hb b]=rgetnii(f2orig2);
        %a=a.*(b==1);
        %     a(a>0)=1000;
        %     a(a==0)=0;
        
        %     a=double(a>0); %###
        f2=fullfile(z.mdir,'_temp4initialorientation.nii');
        rsavenii(f2,ha, a,16);
    else
        f2=fullfile(z.mdir,'_temp4initialorientation.nii');
        [ha a]=rgetnii(ft2,1);
        rsavenii(f2,ha, a);
        %         showbrain=1; if z.debug==1; showbrain=1; end
        %         [  m ]=fsegbrain({ha a},'show',showbrain);
        %          rsavenii(f2,ha, m);
        
    end
    
end

%% ===============================================


paout=fullfile(z.mdir,'rigid_getINI');
try; rmdir(paout,'s'); end
if exist(paout)~=7
    mkdir(paout) ;
end
paout_parameter=fullfile(paout,'parameter');
try; rmdir(paout_parameter,'s'); end
if exist(paout_parameter)~=7
    mkdir(paout_parameter) ;
end

parameterFile0=cellstr(z.parameterFile);
for i=1:length(parameterFile0)
    [~,parname ext]=fileparts(parameterFile0{i});
    parameterfile{i}=fullfile(paout_parameter,[parname ext]);
    copyfile(parameterFile0{i},parameterfile{i},'f');
    
    if ~isempty(z.MaximumNumberOfIterations)
        set_ix(parameterfile{i}, 'MaximumNumberOfIterations',z.MaximumNumberOfIterations);
        get_ix(parameterfile{i}, 'MaximumNumberOfIterations');
    end
    if ~isempty(z.NumberOfResolutions)
        set_ix(parameterfile{i}, 'NumberOfResolutions',z.NumberOfResolutions);
        get_ix(parameterfile{i}, 'NumberOfResolutions');
    end
end

if useAVGT==0
    set_ix2(parameterfile{1}, 'Metric','AdvancedNormalizedCorrelation'); %2048
    set_ix(parameterfile{1},'FinalBSplineInterpolationOrder',3);
    set_ix(parameterfile{1},'FixedInternalImagePixelType','float');
    set_ix(parameterfile{1},'MovingInternalImagePixelType','float');
    
    
end

%  set_ix(parameterfile{1}, 'NewSamplesEveryIteration','true'); %2048
% set_ix(parameterfile{1}, 'MovingInternalImagePixelType','short'); %2048
% set_ix(parameterfile{1}, 'NumberOfSpatialSamples',2048*5); %2048
% (ResultImagePixelType "short")
% set_ix(parameterfile{1}, 'NumberOfSpatialSamples',2048*1); %2048
% set_ix(parameterfile{1}, 'NewSamplesEveryIteration','true'); %2048
% set_ix(parameterfile{1}, 'NumberOfResolutions',2); %2048
% (NewSamplesEveryIteration "true")
% (NumberOfSpatialSamples 2024)
%  %% ===============================================
%   [rmovs,tfile] = run_elastix(f1,f2,paout,paramFile,[],[],  [],[],[])
%  rmricron([],f1,rmovs,0)

if z.rottable==1
    global rottable; rottable=1;
elseif z.rottable==2
    global rottable; rottable=2;
end


[arg,rot]=evalc(['' 'findrotation2' '']);
otc=rot;


% otc=otc(1:3);
%  otc=otc(2);

tb=cell2mat(cellfun(@(a){str2num(a)},otc));
metvec=[];
ovl={};
tic
% f3        = fullfile(pwd,'_temp4initialorientation_rot.nii'); %previous name: '_t2_findrotation'
% copyfile(f2,f3,'f');

%% ========[resize moving image: TEMPLATE]=======================================
%% ==============================================
%%   sourcevol: avgt.nii
%% ===============================================
if useAVGT==1
    fac=z.targetShrinkFactor; %3; %5
else
    fac=0;
end
% if fac==0; fac=1; end
f2=fullfile(z.mdir,'_temp4initialorientation.nii');
f22=fullfile(z.mdir,'_temp4initialorientation2.nii');
if useAVGT==1
    rsavenii(f2,ha, a,16);
    if fac>1
        [bb vox]=world_bb(f2);
        vox2=vox*fac;
        resize_img5(f2,f22, vox2, bb, [], 1, 16);
        try; delete(f2); end
        movefile(f22,f2,'f');
    end
    [hb b]=rgetnii(f2);
    b(b>0)=1;
    b(b==0)=0;
    rsavenii(f2,hb,b);
else
    if fac>1
        [bb vox]=world_bb(f2);
        vox2=vox*fac;
        resize_img5(f2,f22, vox2, bb, [], 1, 16);
        try; delete(f2); end
        movefile(f22,f2,'f');
    end
    
    
end




%% ==============================================
%%   targetvol: t2.nii
%% ===============================================
f111=fullfile(z.mdir,'_targetSmall.nii');
try; delete(f111); end
hp=spm_vol(f1);
if length(hp)==1
    copyfile(f1,f111,'f');
else  %4D--take 1st volume
    [hg g]=rgetnii(f1,1);
    rsavenii(f111, hg, g);
end

if useAVGT==0
    fac=0;
    if fac>1
        f112=fullfile(z.mdir,'_targetSmall2.nii');
        [bb vox]=world_bb(f111);
        vox2=vox*fac;
        resize_img5(f111,f112, vox2, bb, [], 1, 16);
        try; delete(f111); end
        movefile(f112,f111,'f');
    end
    
    
end


%% ===============================================
% [hc c]=rgetnii(f2);
% c=c>0;
% fm=fullfile(z.mdir,'_temp4initialorientation2mask.nii')
% rsavenii(fm,hc,c);

% [hx x]=rgetnii(f2);
% y=x>0; %msk
if useAVGT==1
    [ht t]=rgetnii(f111);
    
    % x=reshape(otsu(x(:),6),[hx.dim]);
    % t=reshape(otsu(t(:),6+2),[ht.dim]);
    % tm=reshape(otsu(t(:),10),[ht.dim])>3;
    %% ===============================================
    % [hd dd dx]=biasfieldcor(f111);
    % rsavenii(f111,ht,dd);
    % [ht t]=rgetnii(f111);
    %% ===============================================
    % if strcmp(target, 'AVGTmask')==1
    showbrain=0; if z.debug==1; showbrain=1; end
    [  m ]=fsegbrain({ht t},'show',showbrain);
    
    % rsavenii(f111,ht,t.*m);
    rsavenii(f111,ht,double(double(t>0).*1.*double(m)));
    % end
end
%% ===============================================

%% ===============================================

% copyfile(f2,f3,'f');
% hdr=spm_vol(f2)

bestnum=0;

for i=1:size(tb,1)
    %cprintf('[0 .5 0]',[ num2str(i) '] [' otc{i,:} '] ' '\n'] );
    f3        = fullfile(z.mdir,'_temp4initialorientation_rot.nii'); %previous name: '_t2_findrotation'
    copyfile(f2,f3,'f');
    %f3  = f1;
    tb2       = tb(i,:);%[pi/2 0 pi]
    preorient = [0 0 0 tb2 ];
    Bvec      = [ [preorient]  1 1 1 0 0 0];  %wenig slices
    fsetorigin({f3}, Bvec);  %ANA
    %% ===============================================
    if 0
        [hc c]=rgetnii(f3);
        c=c>0;
        %c=double(reshape(otsu(c(:),2),[hc.dim])>1);
        mm=fullfile(z.mdir,'_temp4initialorientation2mask.nii');
        rsavenii(mm,hc,c);
    end
    if useAVGT==1
        fm=fullfile(z.mdir,'_fixmask.nii');
        rsavenii(fm,ht,m);
    end
    % ===============================================
    % function [out_ims,out_trns] =    fix_ims,mov_ims,outfold,pfiles,fix_mask,mov_mask,t0file,threads,priority)
    %[arg, rmovs,tfile] =evalc('run_elastix(f111,f3,paout,parameterfile,[fm],[mm],  [],[],[])');
    
    if useAVGT==1
        [arg, rmovs,tfile] =evalc('run_elastix(f111,f3,paout,parameterfile,[fm],[],  [],[],[])');
    else
        [arg, rmovs,tfile] =evalc('run_elastix(f111,f3,paout,parameterfile,[],[],  [],[],[])');
    end
    
    %   [rmovs,tfile] = run_elastix(f1,f3,paout,paramFile,[],[],  [],[],[]);
    %[arg, rmovs,tfile] =evalc('run_elastix(f111,f3,paout,parameterfile,[],[],  [],[],[])');
    %rmovs: AVGT in t2-space
    %f111: t2-small
    %f3:avgt-small
    
    
    %[out_im,out_trans] = run_transformix(im,points,tfile,outfold,opt)
    %[arg2, rmovs2,out_trans] =evalc('run_transformix(ft2,[],tfile,paout,[])');
    %% ===============================================
    [hd d]=rgetnii(rmovs);
    [hv v]=rgetnii(f111);
    if useAVGT==1
        v=imfill(v,'holes');
        d=imdilate(d,ones(2));
        d=imfill(d,'holes');
        %ml= sum(sum(d(:) & v(:))) / sum(sum(d(:) | v(:)));
        %ml=corr(v(:),d(:));
        %met=1-ml;
        %based how much AVGT is filled with t2
        ml= sum(v(d==1))./sum(d(:));
    else
        %ml=corr(v(:),d(:));
        fltfac=0.5;
        %         fltfac=1.5;
        v2=imgaussfilt3(d,fltfac);
        d2=imgaussfilt3(v,fltfac);
        %ml=corr(v2(:),d2(:));
        [~,ml]=mutual_information_3d(v2,d2,32);
        %         if i==14
        %             'a'
        %         end
        %    ml= sum(d(v==1))./sum(v(:));
    end
    
    %     if 0
    %         % based on largest slice
    %         rb=zeros(size(d,3),1);
    %         len=rb;
    %         for j=1:size(d,3)
    %             dv=d(:,:,j); vv=v(:,:,j);
    %             rb(j,1)=corr(dv(:),vv(:));
    %             len(j,1)=sum(dv(:));
    %         end
    %         ml=median(rb(find(len>round(prctile(len,70)))));
    %
    %         %-----
    %
    %     end
    met=1-ml;
    
    %% ===============================================
    %     if 0
    %         fit=fullfile(fileparts(tfile),'IterationInfo.0.R0.txt');
    %         w=preadfile(fit);w=w.all;
    %         tt=str2num(char(w(2:end)));
    %         met=min(tt(:,2));
    %     end
    %
    %
    %     % get 10th percentile threshold
    %     if 0
    %         v=tt(:,2);
    %         thr = prctile(v,10);
    %         % take all values at or below the 10th percentile
    %         met = mean(v(v <= thr));
    %     end
    %     if 0
    %         v=sort(tt(:,2));
    %         met = mean(v(1:end));
    %     end
    
    
    metvec(i,1)=met;
    %% ====[gray matter  as contour ]===========================================
    %     if z.debug==1
    %         slice2png({f111,rmovs},'alpha',[1 .5 ],'sb',[ 2 nan],'dim',1,'nslices',10,'showonly',1,...
    %             'cbarvisible',[0 0],...
    %             'contour',{1,{'color','r','linewidth',.1,'levels',10}},'brighter',1,...
    %             'title',['rot-ID [' num2str(i) ']:    ['  otc{i} ']   ']);
    %     end
    %% ===============================================
    
    % store stuff------------
    %     if 0
    %         ftemp=fullfile(fileparts(rmovs), ['_trot' pnum(i,3)  '.nii' ]);
    %         if isempty(min(metvec(1:i-1))) ||  min(metvec(1:i-1))>met
    %             copyfile(rmovs,ftemp    , 'f');
    %         end
    %         ovl{i}=ftemp;
    %     end
    if 1 % store trafo-file
        ftemp=fullfile(fileparts(rmovs), ['_trot' pnum(i,3)  '.txt' ]);
        if isempty(min(metvec(1:i-1))) ||  min(metvec(1:i-1))>met
            copyfile(tfile,ftemp    , 'f');
            bestnum(i,1)=max(bestnum)+1;
        else
            bestnum(i,1)=0;
        end
        ovl{i}=ftemp;
    end
    
    %% ===============================================
    %% ===============================================
    if z.verbose==1
        cprintf('[0 .5 0]',['rotID:[' num2str(i) '], rot:[' otc{i,:} '];'  repmat(' ',[1 12-length(otc{i,:})]) ...
            ' M:[' num2str(met) ']' repmat('*',[1 bestnum(i,1)])   '\n'] );
    end
    
    
    
end
toc
%% ======[output]=========================================
o.rot    =otc;
o.metric =metvec;
o.ixbest= min(find(metvec==min(metvec))) ;
o.bestrot=otc{o.ixbest };
o.bestmetric=o.metric(o.ixbest );

%% ======[barplot:metric]=========================================

if z.plotMetric==1
    % fg,plot(metvec,'-r.')
    fg;barh(metvec,'k')
    ytick=cellfun(@(a,b){[ num2str(a) '] ' b ]}, num2cell([1:size(otc,1)]') ,otc);
    set(gca,'ytick',[1:size(otc,1)],'yticklabels',ytick);
    set(gca,'ydir','reverse');
    set(gca,'fontsize',8,'fontweight','bold')
    title({['Final metric value (lower is better)']...
        ['animal: '  o.animal]},'interpreter','none');
    hold on;
    hp=plot(o.bestmetric,o.ixbest,'o','markerfacecolor','m','markersize',10);
    ylim([0.5 length(ytick)+0.5]);
    set(gca,'fontsize',6)
end


%% ======[OVERLAY]=========================================
% if z.plotOvleray==1
%     %% ===============================================
%     hg=imoverlay2(ovl{o.ixbest}{1}, ovl{o.ixbest}{2});
%     hf=get(get(hg,'parent'),'parent');
%     ht=uicontrol(hf,'style','text','units','norm');
%     set(ht,'string',[ '"' animal '"' ]);
%     set(ht,'position',[0 0.95 1 .05]);
%     set(ht,'string',[ 'animal: "' animal '"'  '; ROT: [' o.bestrot ']; idx:[' num2str(o.ixbest) '];' ...
%         ' metric: [' num2str(o.bestmetric)  ']'],'fontsize',7);
%     set(ht,'backgroundcolor','w');
%     set(hf,'menubar','none');
%     %% ===============================================
% elseif z.plotOvleray==22
%     %% ===============================================
%     fg; hf=gcf;
%     image(ovl{o.ixbest});
%     axis off
%     set(gca,'position',[0 0 1 1]);
%     ht=uicontrol(hf,'style','text','units','norm');
%     set(ht,'string',[ '"' animal '"' ]);
%     set(ht,'position',[0 0.95 1 .05]);
%     set(ht,'string',[ 'animal: "' animal '"'  '; ROT: [' o.bestrot ']; idx:[' num2str(o.ixbest) '];' ...
%         ' metric: [' num2str(o.bestmetric)  ']'],'fontsize',7);
%     set(ht,'backgroundcolor','w');
%     set(hf,'menubar','none');
% ==============================================
%%   overlay
% ===============================================

if ~isempty(z.plotOvleray)
    
    %% ===============================================
    f33        = fullfile(paout,'_movtest.nii'); %previous name: '_t2_findrotation'
    if length(spm_vol(ft2))==1
        copyfile(ft2,[f33],'f');
    else
        try; delete(f33); end
        [ha a]=rgetnii(ft2,1);
        rsavenii(f33,ha,a);
    end
    %f3  = f1;
    tb2       = tb(o.ixbest,:);%[pi/2 0 pi]
    preorient = [0 0 0 tb2 ];
    Bvec      = [ [preorient]  1 1 1 0 0 0];  %wenig slices
    fsetorigin({f33}, Bvec);  %ANA
    
    %ftemp=fullfile(fileparts(rmovs), ['_trot' pnum(o.ixbest,3)  '.nii' ]);
    trafofile=fullfile(fileparts(rmovs), ['_trot' pnum(o.ixbest,3)  '.txt' ]);
    
    %[out_im,out_trans] = run_transformix(im,points,tfile,outfold,opt)
    set_ix(trafofile, 'FinalBSplineInterpolationOrder',0);
    [arg2, ftemp,out_trans] =evalc('run_transformix(f33,[],trafofile,z.mdir,[])');
    
    if useAVGT==1
        [ha a]=rgetnii(ftemp);
        %a2=a.*double(reshape(otsu(a(:),[10]),size(a))>1); %remove outside border
        a2=double(reshape(otsu(a(:),[10]),size(a))>1); %remove outside border
        rsavenii(ftemp,ha, a2,16);
    end
    %% ===============================================
    % get coronal dim
    angles =tb(o.ixbest,:);
    initial_coronal_dim = 2;  % this dim was coronal initially
    % Rotation matrices
    Rx = @(a)[1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
    Ry = @(a)[cos(a) 0 sin(a); 0 1 0; -sin(a) 0 cos(a)];
    Rz = @(a)[cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];
    % Combined rotation (Z-Y-X order)
    R = Rz(angles(1)) * Ry(angles(2)) * Rx(angles(3));
    % Original axes
    orig_axes = eye(3);
    % Coronal axis before rotation
    coronal_axis = orig_axes(:, initial_coronal_dim);
    % Rotate coronal axis
    new_coronal = R * coronal_axis;
    % Find which dimension aligns best
    [~, coronal_dim] = max(abs(new_coronal));
    
    %% ===============================================
    if z.plotOvleray==1
        %% ===============================================
        slice2png({f1,ftemp},'alpha',[1 0 ],'sb',[ 3 nan],'dim',coronal_dim,'nslices',12,'showonly',1,...
            'cbarvisible',[0 0],...
            'contour',{2,{'color','r','linewidth',.1,'levels',3}},'brighter',1,...
            'title',['rot-ID [' num2str(o.ixbest) ']:    ['  o.bestrot ']   ']);%,...
        %'usemask',0,'usemaskotsu',0,'bgcol','w');
        %% ===============================================
    elseif z.plotOvleray==2
        %% ===============================================
        slice2png({f1,ftemp},'alpha',[1 .3 ],'sb',[ 3 nan],'dim',coronal_dim,'nslices',12,'showonly',1,...
            'cbarvisible',[0 0],...
            'contour',{2,{'color','r','linewidth',.1,'levels',3}},'brighter',1,...
            'title',['rot-ID [' num2str(o.ixbest) ']:    ['  o.bestrot ']   ']);
        %% ===============================================
    elseif z.plotOvleray==3
        %% ===============================================
        q=orthoslice({[f1,',1'], ftemp},'ce','max','mode','ovl','cmap',{'grayFLIP' 'jet.lut'},...
            'alpha',[1 0.3],'cursorcol','w','fs',16,'cbarvisible',[0 0]);
        %% ===============================================
    end
end

%% ===============================================

% ==============================================
%%
% ===============================================

if z.cleanup==1
    try; rmdir(paout,'s'); end
    try; delete(f2); end
    try; delete(f3); end
    try; delete(fullfile(fileparts(rmovs),'_trot*.nii')); end
    if ~isempty(strfind(f111,'_targetSmall.nii'))
        delete(f111);
    end
    try; delete(fm); end
    try; delete(fullfile(z.mdir,'transformix.log')); end
    if  z.plotOvleray~=3
        % try; delete(ftemp); end
    end
end




function [MI, NMI] = mutual_information_3d(vol1, vol2, numBins)
% MUTUAL_INFORMATION_3D Compute mutual information and normalized MI
%   [MI, NMI] = mutual_information_3d(vol1, vol2, numBins)
%
%   vol1, vol2 : 3D volumes (same size)
%   numBins    : number of histogram bins (default = 64)
%
%   MI  = mutual information (bits)
%   NMI = normalized mutual information

if nargin < 3
    numBins = 64;
end

% Ensure volumes are same size
if ~isequal(size(vol1), size(vol2))
    error('Volumes must have the same size.');
end

% Flatten and normalize intensities into [0,1]
v1 = double(vol1(:));
v2 = double(vol2(:));

v1 = (v1 - min(v1)) / (max(v1) - min(v1) + eps);
v2 = (v2 - min(v2)) / (max(v2) - min(v2) + eps);

% Scale to bins
v1 = floor(v1 * (numBins-1)) + 1;
v2 = floor(v2 * (numBins-1)) + 1;

% Joint histogram
jointHist = accumarray([v1 v2], 1, [numBins numBins]);

% Normalize to joint probability
jointProb = jointHist / sum(jointHist(:));

% Marginal probabilities
p1 = sum(jointProb, 2); % along rows
p2 = sum(jointProb, 1); % along cols

% Entropies
Hx  = -sum(p1(p1>0) .* log2(p1(p1>0)));
Hy  = -sum(p2(p2>0) .* log2(p2(p2>0)));
Hxy = -sum(jointProb(jointProb>0) .* log2(jointProb(jointProb>0)));

% Mutual Information
MI = Hx + Hy - Hxy;

% Normalized Mutual Information
NMI = (Hx + Hy) / Hxy;


