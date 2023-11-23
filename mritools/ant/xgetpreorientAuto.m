
%% #m RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%
%
% o=xgetpreorientAuto ; %open GUI
% o=xgetpreorientAuto(0) ; % no GUI & use defaults
% o=xgetpreorientAuto(0,struct('verbose',1));
% o=xgetpreorientAuto(0,struct('verbose',1,'NumberOfResolutions',3,'MaximumNumberOfIterations',50));


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
parameterFile  ={fullfile(pa_parameterfiles ,'parameters_Rigid3Dfast.txt')} ;


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

'verbose'       [1]       'display info in cmd-windows {0|1}'  'b'
'plotMetric'    [1]       'plot metric [0|1]'   'b'
'plotOvleray'   [2]       'plot overlay of best rotation [0|1|2], [1] and [2] are different visualizations'   {0 1 2}

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

o={};
for i=1:length(pa)
    
    z2=z;
    z2.mdir=pa{i};
    %[~,animal]=fileparts(z2.mdir);
    cprintf('[0 .5 0]',[['___['   num2str(i) ']'   repmat('_',[1 50]) ]  '\n'] );
    [u ms]=proc(z2);
    if ~isempty(u)
        o(end+1,:)={u.animal u.bestrot  u.ixbest  u.bestmetric} ;
        
        
        %===============================================
        msg=['animal:"' o{i,1} '"'  char(8594) ';ROTATION:[' o{i,2} ']' repmat(' ',[1 12-length(o{i,2})]) ...
            ';idx:[' num2str(o{i,3}) '];best metric:[' num2str(o{i,4}) ']'];
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
isexist=[exist(ft1) exist(ft2)]./2;
ms='';
if sum(isexist)~=2
   o=[];
   [ms1 ms2]=deal('');
   if isexist(1)==0; ms1=[ '"t2.nii" not found']; end
   if isexist(2)==0; ms2=['"templates"-folder does not exist ("AVGT.nii" not found)']; end
   ms3=strjoin({ms1;ms2}, ' | ');
   ms=[ 'error animal:[' animal ']: ' ms3 ];
   
   return
end

if z.mode==1
    f1=fullfile(z.mdir,'t2.nii');
else
    
    f1=fullfile(z.mdir,'_msk.nii');
    if exist(f1)~=2
        xwarp3('batch','mdirs',{z.mdir},'task',[1],'autoreg',1);
    end
end

%% ============[ref-img]===================================
if 0
    f2orig=fullfile(fileparts(fileparts(z.mdir)),'templates','_b1grey.nii');
    %f2orig=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');
    f2=fullfile(z.mdir,'_temp4initialorientation.nii');
    copyfile(f2orig,f2,'f');
end
if 1
    f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','_b1grey.nii');
    %f2orig1=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');
    f2orig2=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGTmask.nii');
    [ha a]=rgetnii(f2orig1);
    [hb b]=rgetnii(f2orig2);
    a=a.*(b==1);
    f2=fullfile(z.mdir,'_temp4initialorientation.nii');
    rsavenii(f2,ha, a,16);
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


%  %% ===============================================
%   [rmovs,tfile] = run_elastix(f1,f2,paout,paramFile,[],[],  [],[],[])
%  rmricron([],f1,rmovs,0)

% ==============================================
%%
% ===============================================

% otc={...
%     'pi/2 pi pi'%berlin-->ALLEN
%     '0 0 0'
%     '0 pi 0'
%     '0 0 pi'
%     'pi/2 0 pi'  ;%FB
%     'pi/2 0 0'  ;%berlin
%     'pi/2 pi 0'  ;%"flip" inferior-superior, "flip" posterior-anterior
%     'pi pi/2 pi'
%     'pi pi pi/2'
%     'pi/2 pi 0'  ;%Wu/salamancha
%     'pi 0 pi/2'
%     '0 0 pi/2'
%     '0 pi/2 -pi'
%     % 'pi  pi/2 0' %8: 'pi pi/2 0'
%     };
[arg,rot]=evalc(['' 'findrotation2' '']);
otc=rot;

%  otc=otc(11);
% %otc=otc(1:3);
%  otc=otc(2);
% otc=otc([1 7]);

tb=cell2mat(cellfun(@(a){str2num(a)},otc));

metvec=[];
ovl={};
tic
for i=1:size(tb,1)
    %cprintf('[0 .5 0]',[ num2str(i) '] [' otc{i,:} '] ' '\n'] );
    f3        = fullfile(pwd,'_temp4initialorientation_rot.nii'); %previous name: '_t2_findrotation'
    copyfile(f2,f3,'f');
    %f3  = f1;
    tb2       = tb(i,:);%[pi/2 0 pi]
    preorient = [0 0 0 tb2 ];
    Bvec      = [ [preorient]  1 1 1 0 0 0];  %wenig slices
    fsetorigin({f3}, Bvec);  %ANA
    
    % ===============================================
    
    %     [rmovs,tfile] = run_elastix(f1,f3,paout,paramFile,[],[],  [],[],[]);
    [arg, rmovs,tfile] =evalc('run_elastix(f1,f3,paout,parameterfile,[],[],  [],[],[])');
    
    
    if 0
        %% ===============================================
        %% —————————————————————————————————————————————————————————————————————————————————————————————————
        %% run Elastix : backWardDirection
        %% —————————————————————————————————————————————————————————————————————————————————————————————————
        %% copy PARAMfiles
        
        % fprintf('calc backward..','%s');
        parafilesinv=char(stradd(parameterfile,'inv',1));
        copyfile(char(parameterfile),parafilesinv,'f');
        pause(.01)
        rm_ix(parafilesinv,'Metric'); pause(.1) ;
        set_ix3(parafilesinv,'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
        
        
        trafofile=tfile;%dir(fullfile(z.outforw,'TransformParameters*.txt')); %get Forward TRAFOfile
        % trafofile=fullfile(z.outforw,trafofile(end).name);
        paoutINV=fullfile(z.mdir,'rigid_getINI','inv');
        if  exist(paoutINV)~=7
            mkdir(paoutINV);
        end
        parafilesinv=cellstr(parafilesinv);
        
        
        % [im3,trfile3] =      run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[]);
        [~,im3,trfile3]=evalc('run_elastix(f3,f3,    paoutINV ,parafilesinv,[], []       ,   trafofile   ,[],[])');
        
        
        trfile3=cellstr(trfile3);
        %set "NoInitialTransform" in TransformParameters.0.txt.
        set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');%% orig
        
        trfile3=char(trfile3);
        
        
        
        [arg,wim,wps] = evalc('run_transformix(f1,[],trfile3,paoutINV,[])');
        % [hx x]=rgetnii(wim);
        wim2=stradd(wim,'reor_',1);
        
        
        %% ===============================================
        copyfile(wim,wim2,'f');
        BvecInv=spm_imatrix(inv(spm_matrix(Bvec)));
        %     fsetorigin({wim2}, BvecInv);
        Bvec2      = [ -[preorient]  1 1 1 0 0 0];  %wenig slices
        fsetorigin({wim2}, BvecInv);  %ANA
        %      [hx x]=rgetnii(wim2);
        %      hx.mat=hx.mat*inv(spm_matrix(Bvec));
        %      rsavenii(wim2,hx, x,64);
        rmricron([],f1,wim2,0)
        %% ===============================================
        
        
        f50=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGThemi.nii');
        % rmricron([],f50,wim2,0)
        
        [hx x]=rgetnii(wim2);
        x2=flipdim(x,1);
        rsavenii(wim2,hx, x2,64);
        
        f70=wim;
        f7=fullfile(paout,'flipped.nii');
        copyfile(f70,f7,'f');
        fsetorigin({f7}, Bvec);  %ANA
        set_ix(tfile, 'FinalBSplineInterpolationOrder',0);
        %[wim,wps] = run_transformix(f5,[],tfile,paout,'');
        [arg,wim,wps] = evalc('run_transformix(f7,[],tfile,paout,[])');
        
        rmricron([],f1,wim,0)
        
        %[hx x]=rgetnii(wim);
        
        
        %met=calcMI(x,x2);
        met=rand(1);%corr(x(:),x2(:));
        met=met*-1;
        metvec(i,1)=met;
    end
    
    
    if 1
        %% ===============================================
        if 0
            f50=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGT.nii');
            f5=fullfile(paout,'AVGT.nii');
            copyfile(f50,f5,'f');
            fsetorigin({f5}, Bvec);  %ANA
            set_ix(tfile, 'FinalBSplineInterpolationOrder',0);
            %[wim,wps] = run_transformix(f5,[],tfile,paout,'');
            [arg,wim,wps] = evalc('run_transformix(f5,[],tfile,paout,[])');
            [hx x]=rgetnii(wim);
            ma=reshape(otsu(x(:),10),[hx.dim]);
            ma=ma~=ma(1,1,1);
            y=imfill(ma,'holes');
        end
        
%         f60=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGTmask.nii');
%         f6=fullfile(paout,'AVGTmask.nii');
%         copyfile(f60,f6,'f');
%         fsetorigin({f6}, Bvec);  %ANA
%         set_ix(tfile, 'FinalBSplineInterpolationOrder',0);
%         [arg,wim,wps] = evalc('run_transformix(f6,[],tfile,paout,[])');
%         [hy y]=rgetnii(wim); 

        [hx x]=rgetnii(rmovs);
        y=x>0; %msk
         [ht t]=rgetnii(f1);
        %% ===============================================
        x=x.*(y>0);
        t=t.*(y>0);   
        
%         x=reshape(otsu(x(:),4),[hx.dim]);
%         t=reshape(otsu(t(:),4),[ht.dim]);
%         sd_trs=1.5;
%         x=imgaussfilt3(x,sd_trs);
%         t=imgaussfilt3(t,sd_trs);
        met=corr(x(:),t(:));
        
        
%    met=calcMI(x,t);
%          met=([sum((x(:)-t(:)).^2)]./length(x(:)));
         
        met=met*-1;
        metvec(i,1)=met;
        
    end
    
    
    if 0
        %% ===============================================
        f50=fullfile(fileparts(fileparts(z.mdir)),'templates','AVGThemi.nii');
        f5=fullfile(paout,'AVGThemi.nii');
        copyfile(f50,f5,'f');
        fsetorigin({f5}, Bvec);  %ANA
        set_ix(tfile, 'FinalBSplineInterpolationOrder',0);
        %[wim,wps] = run_transformix(f5,[],tfile,paout,'');
        [arg,wim,wps] = evalc('run_transformix(f5,[],tfile,paout,[])');
        [hx x]=rgetnii(wim);
        
        f60=fullfile(fileparts(fileparts(z.mdir)),'templates','ANO.nii');
        f6=fullfile(paout,'ANO.nii');
        copyfile(f60,f6,'f');
        fsetorigin({f6}, Bvec);  %ANA
        set_ix(tfile, 'FinalBSplineInterpolationOrder',0);
        [arg,wim,wps] = evalc('run_transformix(f6,[],tfile,paout,[])');
        [hy y]=rgetnii(wim);
        
        % ===============================================
        uniid=unique(y); uniid(uniid==0)=[];
        co= histcounts(y(:), uniid);
        co=co(:);
        minx=min([length(co) length(uniid)]);
        uniid=uniid(1:minx);
        co=co(1:minx);
        tw=flipud(sortrows([uniid,co],2));
        perc=10;
        tw=tw(1:round(size(tw,1)*perc/100),:);
        
        yl=y(:).*(x(:)==1);
        yr=y(:).*(x(:)==2);
        [ha a]=rgetnii(f1);
        
        tab=zeros(size(tw,1),2);
        for j=1:size(tw,1)
            is1=find(yl==tw(j,1));
            is2=find(yr==tw(j,1));
            v1=a(is1);
            v2=a(is2);
            %         tab(j,:)=[median(v1) median(v2)];
            tab(j,:)=[mean(v1) mean(v2)];
            % tab(j,:)=[std(v1) std(v2)];
        end
        %met=corr(tab(:,1),tab(:,2));
        %     met=sum(abs(tab(:,1)-tab(:,2)));
        met=std(tab(:,1)-tab(:,2));
        met=met*-1;
        metvec(i,1)=met;
        
    end
    %% ===============================================
    if 0
        %     rmricron([],f1,rmovs,0)
        
        fl=fullfile(paout,'elastix.log');
        l=preadfile(fl);
        l=l.all;
        ix=regexpi2(l,'Final metric value');
        metstr=l{max(ix)};
        [ ~,met]=strtok(metstr,'='); met=str2num(strrep(met,'=',''));
        %disp(['metric: ' num2str(met)]);
        
        metvec(i,1)=met;
    end
    %% ===============================================
    if 0
        f10=f1;%fullfile(pwd,'AVGT.nii')
        f11=rmovs ;%fullfile(pwd,'x_t2.nii');
        hb=spm_vol(f10);
        slic=[1:2:hb.dim(3)];
        [g1 g1s]=getslices(f10      ,3,slic ); %backgroundImage
        [g2 g2s]=getslices({f10 f11},3,slic ); %overlayedImage in reference to bgImage
        
        g1=imgaussfilt3(g1,1);
        g2=imgaussfilt3(g2,1);
        
        met=corr(g1(:),g2(:));  %not working
        %met=calcMI(g1(:),g2(:)); %works
        
        
        if 0
            msk=g2>0;
            
            v1=g1(msk==1);
            v2=g2(msk==1);
            %met=corr(v1,v2);
            met=calcMI(v1,v2); %works
        end
        
        
        met=met*-1;
        metvec(i,1)=met;
    end
    %% ===============================================
    
    
    if z.verbose==1
        cprintf('[0 .5 0]',['animal:"' animal '";IDX:[' num2str(i) '];ROT:[' otc{i,:} '];'  repmat(' ',[1 12-length(otc{i,:})]) 'metric:[' num2str(met) ']\n'] );
    end
    
    
    %% ===========[ovl-plot-1]====================================
    
    if z.plotOvleray==2
        f10=f1;%fullfile(pwd,'AVGT.nii')
        f11=rmovs ;%fullfile(pwd,'x_t2.nii');
        %slic='2'  ; %get each 2nd slice within slice range  10 to end-10
        q2=[];
        for j=1:3
            % dim=3
            hb=spm_vol(f10);
            slic=round(min(hb.dim)/2);
            [g1 g1s]=getslices(f10      ,j,slic ); %backgroundImage
            [g2 g2s]=getslices({f10 f11},j,slic ); %overlayedImage in reference to bgImage
            q=imfuse(g1,g2);
            q=padarray(q, [max(hb.dim)-size(q,1)  max(hb.dim)-size(q,2)   0],0,'pre');
            if j<3  ; q2=[q2 q ];
            else;   ; q2=[q2; [q zeros(size(q))] ];
            end
            
        end
        
        ovl{i}=q2;
        if z.debug==1
            fg,imagesc(q2); title([ num2str(i) '] ROT:[' otc{i,:} ']']);drawnow;
        end
    end
    %% ===========[ovl-plot-2]====================================
    if z.plotOvleray==1
        f10=f1;%fullfile(pwd,'AVGT.nii')
        f11=rmovs ;%fullfile(pwd,'x_t2.nii');
        q2=[];
        hb=spm_vol(f10);
        slic=round(linspace(1,hb.dim(3),8));
        [g1 g1s]=getslices(f10      ,3,slic ); %backgroundImage
        [g2 g2s]=getslices({f10 f11},3,slic ); %overlayedImage in reference to bgImage
        g1=montageout(permute(g1,[1 2 4 3]));
        g2=montageout(permute(g2,[1 2 4 3]));
        q=imfuse(g1,g2);
        % imoverlay2(g1,g2)
        ovl{i}={g1 g2};
    end
    
    %% ===============================================
    
    
    
    
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
        ['animal: '  o.animal]});
    hold on;
    hp=plot(o.bestmetric,o.ixbest,'o','markerfacecolor','m','markersize',10);
    
end


%% ======[OVERLAY]=========================================
if z.plotOvleray==1
    %% ===============================================
    hg=imoverlay2(ovl{o.ixbest}{1}, ovl{o.ixbest}{2});
    hf=get(get(hg,'parent'),'parent');
    ht=uicontrol(hf,'style','text','units','norm');
    set(ht,'string',[ '"' animal '"' ]);
    set(ht,'position',[0 0.95 1 .05]);
    set(ht,'string',[ 'animal: "' animal '"'  '; ROT: [' o.bestrot ']; idx:[' num2str(o.ixbest) '];' ...
        ' metric: [' num2str(o.bestmetric)  ']'],'fontsize',7);
    set(ht,'backgroundcolor','w');
    set(hf,'menubar','none');
    %% ===============================================
elseif z.plotOvleray==2
    %% ===============================================
    fg; hf=gcf;
    image(ovl{o.ixbest});
    axis off
    set(gca,'position',[0 0 1 1]);
    ht=uicontrol(hf,'style','text','units','norm');
    set(ht,'string',[ '"' animal '"' ]);
    set(ht,'position',[0 0.95 1 .05]);
    set(ht,'string',[ 'animal: "' animal '"'  '; ROT: [' o.bestrot ']; idx:[' num2str(o.ixbest) '];' ...
        ' metric: [' num2str(o.bestmetric)  ']'],'fontsize',7);
    set(ht,'backgroundcolor','w');
    set(hf,'menubar','none');
    %% ===============================================
end

%% ===============================================

% ==============================================
%%
% ===============================================

if z.cleanup==1
    try; rmdir(paout,'s'); end
    try; delete(f2); end
    try; delete(f3); end
end





