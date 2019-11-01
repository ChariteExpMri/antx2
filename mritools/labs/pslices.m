% pslices(img,CLIM,slices,cMAP, direction)
%IMAGE
%[A] either as img-struct  
% required PARAMS:
%  ....get the volume of IMAGE (spmT_0001.img') use SPM..SPM_vol/spm_read_vols  or use this function (mask=getvol( x.maskVentStr));
% img.mat    =hdr.mat;   %SPM-file:  hdr.mat    [53 63 46]
% img.dim    =hdr.dim;   %SPM-file:  hdr.dim    [4x4 double]
% img.imgdata=vol;       %3D volume              [53x63x46 double]
% or
% [B] from file
% img='spmT_0001.img'
%
% • OPTIONAL
% CLIM       : colorange defined from volume-values 
% slices     : slices to plot in MNI space  [example  -15:3:30  or [2 10 -15] ]  
% cMAP       : colormap to us ..see help colormap
% direction  : sagittal, axial, coronal
% 
% •••  examples % ••• 
% pslices(img)
% pslices(img,[1.5 4],[-1:5:90],'hot','axial')
% pslices('spmT_0002.img',[1.5 4],[-1:5:90],'jet','axial');
% • draw additional BOUNDARY
% requested PARAMS:
%  ....get the volume i.e from SPM..SPM_vols or use this function (mask=getvol( x.maskVentStr));
% img2.boundary.mat    =mask.hdr.mat;   %SPM-file:  hdr.mat 
% img2.boundary.dim    =mask.hdr.dim;   %SPM-file:  hdr.dim 
% img2.boundary.imgdata=mask.vol;     %3D volume
% optional PARAMS:
% img2.boundary.color=[1 1 1];   %color of boundary
% img2.boundary.linewidth= 1.5; %linewidth of boundary
% pslices(img,[60 90],[-35:5:45],'jet','axial',img2)%
% • transparency
% img.transparency=.7
% pslices('swua_1.nii',[],[-14:2:3],'jet','sagittal',img)
% • use MASK
% add.mask='E:\svm\ROI_MID\vs_bil_2std.nii';%mask of ventralStriatum
% pslices(fileout ,[.05 .7],[-15],'jet','axial',add);
% %• SAVE OPTION : open fig and save as *fig and *.jpg from shell
% adds.savename: 'muell77' %filename for jpg and fig files
% pslices(img,[60 90],[-14:2:3],'jet','axial',adds)%
% -----------------------
% %• POSTHOC  
% -----------------------
%  • POSTHOC SAVING
% pslices(img,[60 90],[-14:2:3],'jet','axial'); %creates plot
% pslices('save','muell99');   %save plot a figure and jpg
%  • POSTHOC CLIPBOARD
% pslices(img,[60 90],[-14:2:3],'jet','axial'); %creates plot
% slices('clipboard');%copy image as enhanced metafile(EMF)format to clipboard
%
% -----------------------
% %• CHECK OVERLAY 
% -----------------------
%#### [1] map functional image onto (default) structural MNI-template
% add=[];
% add.transparency=.5  %overlay transparency
% file='C:\Dokumente und Einstellungen\skoch\Desktop\test\swua_1.nii' %functional data
% pslices(file,[],[-20:5:20],'jet','sagittal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
% 
% %OPTIONAL AFTERWARDS: save figure
% % pslices('save','muell99');   %save plot as figure and jpg with title 'muell99'
% 
% %#### [2] map functional image onto specified(e.g. the subjects) structural brain
% add=[];
% add.transparency=.5  %overlay transparency
% add.anatomicalImg='C:\Dokumente und Einstellungen\skoch\Desktop\test\T1.nii' %structural data
% file='C:\Dokumente und Einstellungen\skoch\Desktop\test\swua_1.nii' %functional data
% pslices(file,[],[-20:5:20],'jet','sagittal',add)  %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
% 
% % % slice_overlay2('getpos')
%%
% EXAMPLE
% f1=fullfile(pwd,'con_0010.hdr')
% f2=fullfile(pwd,'avg152T1.img')
%    add=[];
%   add.transparency=.5  %overlay transparency
%   file='C:\Dokumente und Einstellungen\skoch\Desktop\test\swua_1.nii' %functional data
%   pslices(f1,[],[-20:5:20],'actc','sagittal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
%   
%   pslices(f1,[],[],'actc','sagittal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
%
% special colormap
% mymap=jet
% pslices(f1,[],[-8:1:8],'mymap','axial',add) ;

function pslices(varargin)
warning off;

if nargin~=0
    if ischar(varargin{1})
        proc=varargin{1};
        if strcmp(proc,'save');
            filename=varargin{2};
            saveJPGandMAT(filename);
            return
        elseif strcmp(proc,'clipboard');
            clipboardcopy;
            return
        end
    end
end
% ----------------------------------------------------------------
% isstruct(varargin{1})
us=[];
us.boundary=[];
us.savename   =[]; %us.saver.filename
us.transform ='axial';
us.functionalCmap='hot';
us.tstart=tic;
if 0

    fi='avg152PD.nii'
    pslices(fi)


    str=spm_vol(fi)
    [dx g]=spm_read_vols(str);
    img.imgdata=dx;
    img.mat=str.mat;
    img.dim=str.dim(:)';
    pslices(img)

end


if nargin==0 %SPM
    xSPM=evalin('base','xSPM');
    img=zeros(xSPM.DIM(:)');
    for i=1:length(xSPM.Z)
        img(xSPM.XYZ(1,i),xSPM.XYZ(2,i),xSPM.XYZ(3,i))= xSPM.Z(i);
    end
    if isstruct(img);
        img= img;
    else
        img2 = slice_overlay2('matrix2vol',img);
        img2.imgdata=img;
        img2.mat=xSPM.M;
        img2.dim=xSPM.DIM(:)';
        img=img2;
    end
else
    im0=varargin{1};
    if isstruct(im0)
        img=varargin{1};                      %DATA
    else%read data
%         img=spm_vol(varargin{1});
        hdr=spm_vol(varargin{1});
        
        img.mat    =hdr.mat;
        img.dim    =hdr.dim;
        img.imgdata=spm_read_vols(hdr);
    end
    if nargin>=2                               %cbar-limits
        us.functionalrange  =varargin{2};
    end
    if nargin>=3                               %slices
        us.slices  =varargin{3};
    end
    if nargin>=4                           %cMAP
        if ~isempty(varargin{4})
            us.functionalCmap  =varargin{4};
        end
    end
    if nargin>=5                           %SLICE
        if ~isempty(varargin{5})
           us.transform  =varargin{5};       
        end
    end
    
    if nargin>=6                           %struct
        adds=varargin{6};
        if isfield(adds,'boundary')==1
            us.boundary=adds.boundary;
        end
        if isfield(adds,'mask')==1 %maskDATA

            hdrm=spm_vol(adds.mask);

            imgm.mat    =hdrm.mat;
            imgm.dim    =hdrm.dim;
            imgm.imgdata=spm_read_vols(hdrm);

            img.imgdata( imgm.imgdata<=0)=0;

        end
        if isfield(adds,'savename')==1 %postho
            us.savename=adds.savename;
        end
        if isfield(adds,'anatomicalImg')==1 %postho
            us.anatomicalImg=adds.anatomicalImg;
        end
        if isfield(adds,'transparency')==1 %postho
            us.transparency=adds.transparency;
        end
        
    end
%     if nargin>=7  %ANATOMICAL
%         
%     end

end



% us.cmap =cool;
us.range=[];

anatImg1=strrep(which('SPM.m'),'spm.m','canonical\single_subj_T1.nii');
anatImg2=strrep(which('pslices.m'),'pslices.m','mni_icbm152_t1_tal_nlin_sym_09a.nii');
if isfield(us,'anatomicalImg')
    if isnumeric(us.anatomicalImg)
        if us.anatomicalImg==1
            us.anatomicalImg=anatImg1;
        elseif us.anatomicalImg==2
            us.anatomicalImg=anatImg2;          
        else
            disp(['us.anatomicalImg: 1 (single_subj_T1) ,2 (icbm15) or filenname' ]);
        end
        
    end
    
else
   us.anatomicalImg= anatImg2;
end
% us.anatomicalImg   =strrep(which('SPM.m'),'spm.m','canonical\single_subj_T1.nii');
% us.anatomicalImg   =strrep(which('pslices.m'),'pslices.m','mni_icbm152_t1_tal_nlin_sym_09a.nii');

us.anatomicalCmap  ='gray';

us.functionalImg   =img;
if isfield(us,'functionalCmap') ==0;   us.functionalCmap  ='hot';   end
if isfield(us,'functionalrange')==0;   us.functionalrange =[3 5];   end

% us.transform = 'axial';
% us.slices = [];%UPDATE BELOW

% us.slicelabelFontSize =  %txtxslice
us.labelcolor=[ 1 0 0];
us.labelsize = .09;
us.labelShow =1;
if ~isfield(us,'transparency')
    us.transparency = 0;
end

figure;set(gcf,'color','w','tag','pslices');
set(gcf,'menubar','none','toolbar','none');
set(gcf,'units','normalized');
set(gcf,'toolbar','figure');
set(gcf,'KeyPressFcn',@keyboardx);
set(gcf,'WindowScrollWheelFcn',{@mousewheel,1}); 
set(gcf,'ButtonDownFcn',@figbuttondown); 
% set(gcf,'resizefcn',@resizegcn2); 

 


try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end

us.curpos=  1  ; %[1]closed
us.butpos=[.98 .7];
us.butlab={'<' '>'};
butwid=.02;
us.layer=[us.butpos(2)+butwid  0 1-us.butpos(2)-butwid 1];
h = uicontrol('Style', 'pushbutton', 'String', us.butlab(us.curpos),...
    'units','normalized','tag','but1',...
    'Position', [us.butpos(us.curpos) .5 .02 .2], 'Callback', @shiftbutton,...
    'userdata',us);

lb1 = uicontrol('Style', 'listbox', 'String',  '',...
    'units','normalized',...
    'Position', us.layer , 'Callback', @changevalue,...
    'userdata',us,'tag','lb1');

ed1 = uicontrol('Style', 'edit', 'String',  '',...
    'units','normalized',...
    'Position', [us.layer(1) .5 us.layer(3)  .05 ], 'Callback', @lbupdate ,...
    'userdata',us,'tag','ed1','visible','off');


if us.curpos==1 ; set(lb1,'visible','off'); else;  set(lb1,'visible','on');end


set(lb1,'KeyPressFcn',@keyboardx);

lblist={};
% ---------------------label---NUmereic value=1
% lblist(end+1,:)={'anatomicalImgType'  0 };
lblist(end+1,:)={'anatomicalImg'   0 };
lblist(end+1,:)={'anatomicalCmap'  0 } ;
% lblist(end+1,:)={'functionalImg'   0};
lblist(end+1,:)={'functionalCmap'  0};
lblist(end+1,:)={'functionalrange' 1 };
lblist(end+1,:)={ 'transform'      0};
lblist(end+1,:)={ 'slices'  1 };
lblist(end+1,:)={ 'labelcolor'  1};
lblist(end+1,:)={'labelsize'    1};
lblist(end+1,:)={'transparency' 1'};
% lblist(end+1,:)={ 'labelShow' 1};

us.lblist=lblist;
% lblist(end+1,1)={ };
% lblist(end+1,1)={ };
entryadd={};
entryadd(end+1,1)={['<HTML><b><FONT SIZE=3><font color="#FF0000">' 'PLOT ' '</b><']};

direct={'sagittal [LIMS]' 'coronal [LIMS]' 'axial [LIMS]'};
for i=1:3
    %     ss=[1:us.functionalImg.dim(3)*us.functionalImg.mat(3,3)]+us.functionalImg.mat(3,4)+1
    ss=[1:abs(us.functionalImg.dim(i)*us.functionalImg.mat(i,i))]-...
        abs(us.functionalImg.mat(i,4))+1;
    sm(i,:)=[ss(1) ss(end)];
    bla=[ direct{i} '[' regexprep(num2str(sm(i,:)),'  ',' ') ']'];
    entryadd(end+1,1)={['<HTML><b><FONT SIZE=2><font color="#0000FF">' bla ' ' '</b><']};
end

us.entryadd=entryadd;
if isfield(us,'transform')==0;     us.transform = 'axial';   end

ix=find(cellfun('isempty',strfind(direct,us.transform))==0);
if isfield(us,'slices')==0
    us.slices = [sm(ix,1):5:sm(ix,2)];%UPDATE BELOW
end
us.direct=direct;
us.slicelim=sm;



%% GET SPM INFO
figspm=findobj(0,	'Tag','Graphics');
if ~isempty(figspm)
    try
%     htx=sort(findobj(figspm,'type','text'));
    htx=findobj(findobj(figspm,'tag','PermRes'),'type','text');
    htx=sort(htx);
    txSPM=get(htx,'string');
%     txSPM(cellfun(@iscell,txSPM))=[];
%     del=find(~cellfun('isempty',regexpi(txSPM,'^<$')));
%     txSPM(del(2:end))=[];
%     txSPM(del)=[];
    txSPM=['__________________' ;upper('Info from SPM'); xSPM.title; txSPM];
    
   us.functionalrange =[min(xSPM.Z) max(xSPM.Z)]; %FUNCTIONAL RANGE FOR SPM 
    us.infoImport=txSPM;
    catch
       us.infoImport={};  
    end
else
    us.infoImport={};
end
for i=1:length(us.infoImport)
    if i<=2; 
        fonts=3; 
        us.entryadd(end+1,1)=  {['<HTML><b><FONT SIZE=' num2str(fonts) '><font color="#00cc33">' us.infoImport{i} ' ' '</b><']};
    else fonts=2;
          us.entryadd(end+1,1)=  { us.infoImport{i}  };
    end

end




% ---------------------------------
set(gcf,'userdata',us);
usupdate('toLB');

% ---------------------------------
plotter(1);

function figbuttondown(ra,ro)
set(findobj(gcf,'tag','ed1'),'visible','off');


function mousewheel(src,event,type)

try
    dirs=event.VerticalScrollCount;
    us=get(gcf,'userdata');
    if isempty(us.slices)
        return
    end
    
 

% if strcmp(get(gcf,'CurrentKey'),'shift')
%     [a c]=view;
%     view(a,c+r.VerticalScrollCount)
% if strcmp(get(gcf,'CurrentKey'),'control')
% %     [a c]=view;
% %     view(a+r.VerticalScrollCount,c);
% % elseif  strcmp(get(gcf,'CurrentKey'),'space')
%   type=2;
% else
%  type=1   
% end



if type==1
    len=length(us.slices);
    if dirs<0
        len=len/2;
    else
        len=len*2;
    end
    step=(us.slices(end)-us.slices(1))/(len-1);
    if step==0
        step=1;
        slice=[min(us.slices)-1  us.slices max(us.slices)+1];
    else
        slice=unique(round(us.slices(1):step:us.slices(end)));
    end
elseif type==2
    nplot   =length(us.slices);
    nplot=nplot+dirs;
    slice=unique(round(linspace(us.slices(1),us.slices(end),nplot)));
end
% slicegap=median(diff(us.slices));
% slicegap= slicegap+dirs;
% allslices= round(us.slices(1):slicegap:120);
% slice=unique([ allslices( [1:max(find(allslices<=us.slices(end))) ])  us.slices(end)]);
%  
if length(unique(slice))==1
    %     slice=[ us.slices(1) us.slices(end) ];
end
if length(unique(slice))>1
    us.slices=slice;
    set(gcf,'userdata',us);
    usupdate('toLB');
    plotter(1);

end
set(gcf,'WindowScrollWheelFcn',{@mousewheel,1});

end

%  dirs=event.VerticalScrollCount;
% us=get(gcf,'userdata');
%  slicegap=median(diff(us.slices));
%   slicegap= slicegap+dirs;
%   
% allslices= round(-120:slicegap:120);
% allslices=allslices( [max(find(allslices<=us.slices(1))):min(find(allslices>=us.slices(end)))])
%  
%  
% % nslice=round(linspace(us.slices(1),us.slices(end),len ))
% if length(allslices)>=2
%     us.slices=[ allslices ];
%     set(gcf,'userdata',us);
%   usupdate('toLB');
%    plotter; 
%     
% end

% dirs=event.VerticalScrollCount
% us=get(gcf,'userdata');
% slicegap=median(diff(us.slices))
%  slicegap= slicegap+dirs
% if slicegap>=1
%     us.slices=[ us.slices(1):slicegap :us.slices(end)  ];
%     set(gcf,'userdata',us);
%   usupdate('toLB');
%    plotter; 
%     
% end


function keyboardx(src,event)
if strcmp(event.Key,'space')
    shiftbutton([],[]);
elseif strcmp(event.Key,'return')    
    co=slice_overlay2('getpos');
    co=round(co);
    

    %%MAKE BACKUP of multislice-pannel
     us=get(gcf,'userdata');
    para={'transform' 'functionalCmap' 'functionalrange' 'slices' 'transparency' };
    if length(us.slices)>1
        us=get(gcf,'userdata');
        us.backup=[];
        for i=1:length(para)
            us.backup=setfield(us.backup,para{i},  getfield(us,para{i}) );
        end
        us.count_viewswitch=1;
        set(gcf,'userdata',us);
    end

    if ~isfield(us,'count_viewswitch')
        us.count_viewswitch=1;
        set(gcf,'userdata',us);
    end
%   -------------------------------
      
    us=get(gcf,'userdata');
    if isempty(co)
        co=us.curMNIposition;
    end
        
   if isempty(co)
       disp('click voxel first to get MNI coordinate');
       return;
   end
   global SO
    
   if mod( us.count_viewswitch,4)==0
    %% LOAD BACKUP-PARAMS
        us=get(gcf,'userdata');
        para=fieldnames(us.backup);
        for i=1:length(para)
            us=setfield(us,para{i},  getfield(us.backup,para{i}) );
        end
        
        us.count_viewswitch = us.count_viewswitch +1 ;
        set(gcf,'userdata',us);
        usupdate('toLB');
        plotter(1);
       
   else
       transform={'sagittal' ;
           'coronal'  ;
           'axial'    };

       us.curMNIposition=co;
       trafo_now=find(strcmp(transform,us.transform));
       trafo_next=mod(trafo_now,3)+1;
       trafo =  transform{trafo_next};
       sliceNo= co(trafo_next);

       usupdate('toUS'); %%us=get(gcf,'userdata');
       us.transform=trafo ;%'coronal';
       us.slices=[sliceNo];
       us.count_viewswitch = us.count_viewswitch +1 ;
       set(gcf,'userdata',us);
       usupdate('toLB');
       plotter(1);
   end
    

    
    

    
    
elseif length(event.Modifier) == 1 & strcmp(event.Modifier{:}, 'control')
 
    switch event.Key
%         case {'home'}
%             axis(ax,'auto');
%             view(3)
        case 'c'
            
             clipboardcopy([],[]);
            
    end
    
 elseif strcmp(event.Key,'control')
  set(gcf,'WindowScrollWheelFcn',{@mousewheel,2}); 
    
% %     fig=findobj(0,'Tag','Graphics')
% elseif strcmp(event.Key,'t')
%   batab;% showtable;
% % elseif strcmp(event.Key,'h')
% %   batab(0);% showtable;
% elseif strcmp(event.Key,'s')   
%    fun2_sections;
% elseif strcmp(event.Key,'e')
%     pslices;
% elseif strcmp(event.Key,'b')
%     fun2_showbrain;
% % elseif strcmp(event.Key,'q');%quit
% %     batab('close');
end


function lbupdate(ro,ri)

lb=findobj(gcf,'tag','lb1');
li=get(lb,'string');
va=get(lb,'value');
this=[regexprep(li{va},'\[=].*','') '[=]' char(get(ro,'string')) ];
li(va)={this};
set(lb,'string',li);
set(ro,'visible','off');

function usupdate(direc)
us=get(gcf,'userdata');
lblist=us.lblist;
entry={};
if strcmp(direc,'toLB')
    for i=1:size(lblist,1)
        dum=getfield(us,lblist{i,1});
        if lblist{i,2}==0 %##CHAR ischar(dum)
            entry(end+1,1)={[lblist{i,1} '[=]' dum]};
        elseif lblist{i,2}==1 %%## isnumeric(dum) & size(dum,1)==1
            entry(end+1,1)={[lblist{i,1} '[=]  [' regexprep(num2str(dum),'  ',' ')  ']']};
        end
        %         eval([ 'lbs.lblist{' num2str(i) '}=us.' 'lblist{' num2str(i) '}'])
    end
    entry=[entry;us.entryadd];

    lb1=findobj(gcf,'tag','lb1');
    set(lb1,'string',entry);
end
if strcmp(direc,'toUS')
    lb1=findobj(gcf,'tag','lb1');
    lblistnew=get(lb1,'string');

    for i=1:length(lblist)
        dum=lblistnew{i,1};
        dum=regexprep(dum,'.*\[=]','');
        if lblist{i,2}==0 %CHAR ischar(dum)
            us= setfield(us,lblist{i,1}, dum);
        elseif lblist{i,2}==1% isnumeric(dum) & size(dum,1)==1
            if strcmp(lblist{i,1},'slices')
                us=setfield(us,lblist{i,1}, str2num(dum));
            else
                us=setfield(us,lblist{i,1}, str2num(dum));
            end
            %             ['ss--' lblist{i,1}]
            %             entry(end+1,1)={[lblist{i} '[=]  [' regexprep(num2str(dum),'  ',' ')  ']']}
        end
        %         eval([ 'lbs.lblist{' num2str(i) '}=us.' 'lblist{' num2str(i) '}'])
    end
    set(gcf,'userdata',us);

end





function changevalue(ro,ri)
li=get(ro,'string');
va=get(ro,'value');
this=regexprep(li(va),'.*=]','');
if ~isempty(strfind(char(this),'>PLOT'));
    usupdate('toUS');
    set(findobj(gcf,'tag','ed1'),'visible','off');
    plotter(1);

elseif ~isempty(strfind(char(this),'sagittal [LIMS]'));
    usupdate('toUS');   us=get(gcf,'userdata');
    us.transform='sagittal';
    us.slices=[];
    set(gcf,'userdata',us);
    usupdate('toLB');

    plotter(1);
elseif ~isempty(strfind(char(this),'coronal [LIMS]'));
    usupdate('toUS'); us=get(gcf,'userdata');
    us.transform='coronal';
    us.slices=[];
    set(gcf,'userdata',us);
    usupdate('toLB');
    plotter(1);
elseif ~isempty(strfind(char(this),'axial [LIMS]'))
    usupdate('toUS'); us=get(gcf,'userdata');
    us.transform='axial';
    us.slices=[];
    set(gcf,'userdata',us);
    usupdate('toLB');
    plotter(1);
elseif ~isempty(strfind(char(this),'LABELS'))    
getlabels;
    
else
    if va<find(cellfun('isempty',regexpi(li,'PLOT'))==0);
        set(findobj(gcf,'tag','ed1'),'visible','on','string','');
    else
        set(findobj(gcf,'tag','ed1'),'visible','off');
    end
end

function getlabels
us=get(gcf,'userdata');
dim=us.functionalImg.dim;

%from spm_read_vols (line: 53)
[R,C,P]  = ndgrid(1:dim(1),1:dim(2),1:dim(3));
RCP      = [R(:)';C(:)';P(:)'];
XYZ   =RCP;
clear R C P
RCP(4,:) = 1;
XYZmm      = us.functionalImg.mat(1:3,:)*RCP;

vol=us.functionalImg.imgdata;
ts =vol(:)';

tr_magnitude  =0.1;
tr_nvoxClust  =1;
tr_npeakClust =3;
tr_clustDist  =8;

ist= [tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist];
% is=find(ts>tr_magnitude);

% tresh=input('select MAGNITUDE threshold (select a number or let it empty): ','s')
% tresh=input('MAGNITUDE threshold and clustersize (2 values or empty (default), or nan): ','s')
% tresh=input('4 values: [1]HeightTResh,[2]clustersize,[3]Npeaks/Cluster,[4]distance between clusters (2 values or empty (default), or nan): ','s')

disp('_____INPUTS_________________');
disp('press enter for default, otherwise specify...');
disp('4 values (separated with space) or use nans for specific default parameter, or viewer values if only the first ordered values have to be specified : [4 5 nan nan] equals[4 5] ');
disp('[1]HeightTResh,[2]nvox/cluster,[3]Npeaks/Cluster,[4]distance between Clusters');
disp('example: "4 10 4 5 ";MEANING:statistical Threshold >=[4];each cluster must have >=[10] adjacent voxels; give me [4] peakLabebels for each cluster; clusters must be separated by at least[5]mm '  ); 
disp('example: "4 10 nan nan ";MEANING:same with SPM default settings [3]peaks per cluster, [8]mm cluster-separation'  ); 
disp('example: "4 10 ";MEANING:same as previous example'  ); 
disp('example: "4 nan 4 5 ";MEANING: as as 1st.example but report all clusters (no contraints regarding the size of cluster)'  ); 
tresh=input('4 values: ' ,'s');


if ~isempty(tresh)
    val=str2num(tresh);
    soll=[tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist] ;
%     val=[4 0 8 ]
    val(size(val,2)+1:size(soll,2))=nan;
    val(isnan(val))= soll(isnan(val));

    tr_magnitude   =val(1);
    tr_nvoxClust   =val(2);
    tr_npeakClust  =val(3);
    tr_clustDist   =val(4);
    
   ist= [tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist];
%    val(isnan(val))=0     
%     if size(val==1,2)==1
%         tr_nvoxClust=nan;
%     elseif length(val==2)
%         tr_magnitude  =val(1);
%         tr_nvoxClust=val(2);
%     end
%     if ~isnan(tr_magnitude)
%     
%     end
%     if isnan(tr_nvoxClust)
%         tr_nvoxClust=0;
%     end
   
end
is=find(ts>=tr_magnitude);

%% tester idx Values match with XYZ-VOLUME
if 0
    itest=252;
    ts(is(itest));
    % XYZ(:,is(itest))
    vol(XYZ(1,is(itest)),XYZ(2,is(itest)),XYZ(3,is(itest)));
end

Z=ts(is);
XYZsurv=XYZ(:,is);
hdr.mat=us.functionalImg.mat;
hdr.dim=us.functionalImg.dim;
[sm]=pclustermaxima(Z,XYZsurv,hdr) ; %get MAX of clusters
try
 [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,tr_npeakClust,tr_clustDist);
catch
 [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8);
 disp('use SPM-defaults for NpeaksPerCluster[3] and distance between clusters[8mm]-->there was an error in parameter specification');
end
%[sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,10,4);

% hdr.mat=us.functionalImg.mat;
% hdr.dim=us.functionalImg.dim;
% [ st ]=pclustertreshIMG('Accuracies', ts, tr_magnitude,tr_nvoxClust, XYZ,hdr,1 )
% [ st ]=pclustertreshIMG('Accuracies', ts, 3,30, XYZ,hdr,1 )
% 
% [ st ]=pclustertreshIMG('Accuracies',Z, 0, 0, XYZsurv,hdr,1 )

if 0
    %sm.Z
%     [ st ]=pclustertreshIMG('Accuracies', sm.Z,70,30,c.XYZ,c.hdr,0 )
    a.hdr.mat=us.functionalImg.mat;
    a.hdr.dim=dim;
    [ st ]=pclustertreshIMG('Accuracies', ts, 70,40, XYZ,a.hdr,1 )
    
%     acc3=acc2;
%     acc3(acc3<50)=50;
    x.mask='D:\relapse_TWU\mask.nii'
    x.pa_out='D:\relapse_TWU\results'
    strct=spm_vol(x.mask);
    vol3=makevol( st.Z,  st.XYZ,  strct,nan);
    pwritevol2vol(fullfile(x.pa_out, 'acc_tr70_tr40voxClst'),vol3,strct,'acc_tr');
    
    Z=st.Z;
    XYZsurv=st.XYZ;
    hdr.mat=us.functionalImg.mat;
    hdr.dim=us.functionalImg.dim;
    [sm]=pclustermaxima(Z,XYZsurv,hdr) ; %get MAX of clusters
    [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8);

    
end
% if 0 % magnitude and clustersize treshold
% end

clustsize=sm.nvox(sv.idx);
% if tr_nvoxClust==0
%     labs(sv.XYZmm,{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
%         [sv.A  sv.Z    sm.nvox(sv.idx)  ]});
% else %cklustertreshold
  ix_surv=find(clustsize>=tr_nvoxClust) ;
 labs(sv.XYZmm(:,ix_surv),{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
        [sv.A(ix_surv)  sv.Z(ix_surv)    sm.nvox(sv.idx(ix_surv))  ]});

%   labs(sv.XYZmm(:,ix_surv),{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
%         [sv.A(ix_surv)  sv.Z(ix_surv)    sm.nvox(sv.idx(ix_surv))  ]});
    
% end
%ADDON
% us=get(gcf,'userdata');
% us.addlab=



set(gcf,'tag','');
disp('params');
disp(num2str(ist));

function shiftbutton(ro,ri);
ro=findobj(gcf,'tag','but1');
ed1=findobj(gcf,'tag','ed1');
us=get(ro,'userdata');
us.curpos=mod([us.curpos],2)+1;
pos=get(ro,'position');
lb1=findobj(gcf,'tag','lb1');
set(ro,'position',  [ us.butpos(us.curpos)  pos(2:4)  ],...
    'string',us.butlab(us.curpos)   );
if us.curpos==1 ; 
    set(lb1,'visible','off'); 
        set(ed1,'visible','off'); 
else;     set(lb1,'visible','on');
end
set(ro,'userdata',us);


function plotter(doplot)
us=get(gcf,'userdata');
clear global SO;
global SO;
% fig=max(findobj(0,'tag','pslices'));
fig=gcf;
set(0,'currentfigure',fig);
delete(findobj(fig,'type','axes'));
SO.clf=0 ;%do not clear figure
SO.fignum=gcf;


SO.img(1).vol =spm_vol(us.anatomicalImg);% spm_vol('avg152T1.img');
% SO.img(1).vol = spm_vol('C:\spm8\canonical\single_subj_T1.nii')
SO.img(1).prop = 1;
eval(['dum=' us.anatomicalCmap ';']);
SO.img(1).cmap =dum;% gray;

SO.img(2).vol = us.functionalImg ;%spm_vol('con_0010.img');
SO.img(2).range =us.functionalrange; [ ];
SO.img(2).prop = Inf;

cmaperstr=us.functionalCmap;
cmapSpecialMap=0;

if ~isempty(strfind(cmaperstr,'red2'));
%     map_red2=    [1 1 0;1 0.967741906642914 0;1 0.935483872890472 0;1 0.903225779533386 0;1 0.870967745780945 0;1 0.838709652423859 0;1 0.806451618671417 0;1 0.774193525314331 0;1 0.74193549156189 0;1 0.709677398204803 0;1 0.677419364452362 0;1 0.645161271095276 0;1 0.612903237342834 0;1 0.580645143985748 0;1 0.548387110233307 0;1 0.516129016876221 0;1 0.483870953321457 0;1 0.451612889766693 0;1 0.419354826211929 0;1 0.387096762657166 0;1 0.354838699102402 0;1 0.322580635547638 0;1 0.290322571992874 0;1 0.25806450843811 0;1 0.225806444883347 0;1 0.193548381328583 0;1 0.161290317773819 0;1 0.129032254219055 0;1 0.0967741906642914 0;1 0.0645161271095276 0;1 0.0322580635547638 0;1 0 0;0.976771175861359 0 0;0.953542411327362 0 0;0.930313587188721 0 0;0.907084763050079 0 0;0.883855998516083 0 0;0.860627174377441 0 0;0.8373983502388 0 0;0.814169585704803 0 0;0.790940761566162 0 0;0.767711937427521 0 0;0.744483172893524 0 0;0.721254348754883 0 0;0.698025524616241 0 0;0.674796760082245 0 0;0.651567935943604 0 0;0.628339111804962 0 0;0.605110347270966 0 0;0.581881523132324 0 0;0.558652698993683 0 0;0.535423934459686 0 0;0.512195110321045 0 0;0.50199556350708 0 0;0.491795986890793 0 0;0.481596440076828 0 0;0.471396893262863 0 0;0.461197346448898 0 0;0.450997769832611 0 0;0.440798223018646 0 0;0.430598676204681 0 0;0.420399129390717 0 0;0.410199552774429 0 0;0.400000005960464 0 0];
    map_red2=  [1 1 0;1 0.987468659877777 0;1 0.974937319755554 0;1 0.962406039237976 0;1 0.949874699115753 0;1 0.93734335899353 0;1 0.924812018871307 0;1 0.912280678749084 0;1 0.899749398231506 0;1 0.887218058109283 0;1 0.874686717987061 0;1 0.862155377864838 0;1 0.849624037742615 0;1 0.837092697620392 0;1 0.824561417102814 0;1 0.812030076980591 0;1 0.799498736858368 0;1 0.786967396736145 0;1 0.774436056613922 0;1 0.761904776096344 0;1 0.749373435974121 0;1 0.736842095851898 0;1 0.698060929775238 0;1 0.659279763698578 0;1 0.620498597621918 0;1 0.581717431545258 0;1 0.542936265468597 0;1 0.504155099391937 0;1 0.465373963117599 0;1 0.426592797040939 0;1 0.387811630964279 0;1 0.349030464887619 0;1 0.310249298810959 0;1 0.271468132734299 0;1 0.237534612417221 0;1 0.203601092100143 0;1 0.169667586684227 0;1 0.135734066367149 0;1 0.101800546050072 0;1 0.0678670331835747 0;1 0.0339335165917873 0;1 0 0;0.959349572658539 0 0;0.918699204921722 0 0;0.878048777580261 0 0;0.8373983502388 0 0;0.796747982501984 0 0;0.756097555160522 0 0;0.715447127819061 0 0;0.674796760082245 0 0;0.634146332740784 0 0;0.593495905399323 0 0;0.552845537662506 0 0;0.512195110321045 0 0;0.500975608825684 0 0;0.489756077528 0 0;0.478536576032639 0 0;0.467317074537277 0 0;0.456097543239594 0 0;0.444878041744232 0 0;0.433658540248871 0 0;0.42243903875351 0 0;0.411219507455826 0 0;0.400000005960464 0 0];
    cmapSpecialMap=1;
     dum= map_red2 ;
end

if ~isempty(strfind(cmaperstr,'Inverted'));
    %cmaperstr=us.functionalCmap;
    try
    cmaperstr=strrep(cmaperstr,'Inverted','');
    eval(['dum=' cmaperstr  ';']);
    dum=flipud(dum);
    catch
     dum=flipud(dum);  
        
    end

    
elseif cmapSpecialMap==0
    try
    eval(['dum=' cmaperstr  ';']);
    catch
    dum=evalin('base',cmaperstr)  ;  
    end
end


SO.img(2).cmap =dum;% hot;

% SO.img(3).vol = spm_vol('con_0010.img');
% SO.img(3).range = [-2 -4.8];
% SO.img(3).prop = Inf;
% SO.img(3).cmap = winter;

% SO.img(4).vol = spm_vol('con_0010.img');
% SO.img(4).range = [-3 -4] ;
% SO.img(4).prop = Inf;
% SO.img(4).cmap = jet;

SO.cbar =2:length(SO.img);% [2 3 4];
SO.transform =us.transform; %'axial';
% SO.transform = 'coronal';
% if isempty()

if isempty(us.slices)
    ix= find(cellfun('isempty',strfind(us.direct,us.transform))==0);
    lims=us.slicelim(ix,:);
    SO.slices =[lims(1) :10: lims(end)];%;[];%[-12:6:72];% -12:6:72;
else
    SO.slices =us.slices;%;[];%[-12:6:72];% -12:6:72;
end



if  us.labelShow==1
    %     SO.labels = struct('colour',[0 0 1],'size',0.075,'format', '%+3.0f');
    SO.labels.colour = us.labelcolor;
    SO.labels.size  = us.labelsize;
    SO.labels.format= '%+3.0f';
    % SO.labels = struct('colour',[0 0 1],'size',0.075,'format', '%+3.0f');
else
    SO.labels=[];
end

SO.boundary=us.boundary;

if doplot==1
    slice_overlay2;


    % function getMNI
    ax=findobj(gcf,'type','image');
    set(ax,'ButtonDownFcn', @getMNI);
    % slice_overlay2('getpos')
    cbar=findobj(gcf,'tag','cbar');
    set(cbar,'fontsize',.11);
    po=get(cbar,'position');
    set(cbar,'position',[po(1:2)   po(3)/2  po(4)]);
    set(cbar,'color',[0 0 0]);
    set(gcf,'menubar','none','toolbar','none');

    % f = uimenu('Label','LABS','tag','menu_brodm');
    % uimenu(f,'Label','update LABS  [u]','Callback', @saver );
    cmenu = uicontextmenu;
    set(  findobj(gcf,'type','image') ,'UIContextMenu', cmenu);
    item1 = uimenu(cmenu, 'Label','replot', 'Callback', {@gcontext, 'replot'});%ws
    item1 = uimenu(cmenu, 'Label','save as JPG-file', 'Callback', {@gcontext, 'saver'});%ws
    item1 = uimenu(cmenu, 'Label','save as FIG-file to reload', 'Callback', {@gcontext, 'saverFig'});%ws
    item1 = uimenu(cmenu, 'Label','save JPG and FIG-file', 'Callback', {@gcontext, 'saverFigNmat'});%ws
    item1 = uimenu(cmenu, 'Label','copy to clipboard', 'Callback', @clipboardcopy);%ws
    item1 = uimenu(cmenu, 'Label','change BackgroundImage', 'Callback', @changeBackgroundImage,'Separator','on');%ws

    cmenu2 = uicontextmenu;
    set(get(findobj(gcf,'tag','cbar'),'children'),'UIContextMenu',cmenu2);
    item1 = uimenu(cmenu2, 'Label','hot', 'Callback', {@cmap, 'hot'});%ws
    item1 = uimenu(cmenu2, 'Label','cool', 'Callback', {@cmap, 'cool'});%ws
    item1 = uimenu(cmenu2, 'Label','winter', 'Callback', {@cmap, 'winter'});%ws
    item1 = uimenu(cmenu2, 'Label','jet', 'Callback', {@cmap, 'jet'});%ws
    item1 = uimenu(cmenu2, 'Label','spring', 'Callback', {@cmap, 'spring'});%ws
    item1 = uimenu(cmenu2, 'Label','summer', 'Callback', {@cmap, 'summer'});%ws
    item1 = uimenu(cmenu2, 'Label','autumn', 'Callback', {@cmap, 'autumn'});%ws
    item1 = uimenu(cmenu2, 'Label','copper', 'Callback', {@cmap, 'copper'});%ws
    
    item1 = uimenu(cmenu2, 'Label','hotInverted', 'Callback', {@cmap, 'hotInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','coolInverted', 'Callback', {@cmap, 'coolInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','winterInverted', 'Callback', {@cmap, 'winterInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','jetInverted', 'Callback', {@cmap, 'jetInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','springInverted', 'Callback', {@cmap, 'springInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','summerInverted', 'Callback', {@cmap, 'summerInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','autumnInverted', 'Callback', {@cmap, 'autumnInverted'});%ws
    item1 = uimenu(cmenu2, 'Label','copperInverted', 'Callback', {@cmap, 'copperInverted'});%ws
    
    item1 = uimenu(cmenu2, 'Label','red2', 'Callback', {@cmap, 'red2'});%ws
    item1 = uimenu(cmenu2, 'Label','red2Inverted', 'Callback', {@cmap, 'red2Inverted'});%ws

    set(get(findobj(gcf,'tag','cbar'),'children'),'ButtonDownFcn',[]);

    if ~isempty(us.savename)%SAVE from outside
        saveJPGandMAT;
        us.savename=[];
        set(gcf,'userdata',us);

    end
    updater;
end %doplot


function updater
us=get(gcf,'userdata');
lb=findobj(gcf,'tag','lb1');
str=get(lb,'string');
ex=find(cellfun('isempty',strfind(str,'LABELS'))==0);
explot=find(cellfun('isempty',strfind(str,'PLOT'))==0);
if isempty(ex);
    tag={'LABELS'};
    try
       str= [str(1:explot+3); tag ;str(explot+4:end)];
    catch
       str=  [str(1:explot+3);tag];
    end
end
set(lb,'string',str)
set(gcf,'resizefcn',@resizegcn2);


function cmap(ri,ru,task)%colormap

  usupdate('toUS'); 
  us=get(gcf,'userdata');
    us.functionalCmap=task;
    set(gcf,'userdata',us);
    usupdate('toLB');
    plotter(1);

function gcontext(ri,ru,task,filename)
if strcmp(task,'saver')
    if exist('filename')==0
        [fi pa]=uiputfile('*.jpg','save image as jpg');
    else
        [pa fi]=fileparts(filename);
    end
    if fi~=0
        
        b(1)=findobj(gcf,'tag','but1');
        b(2)=findobj(gcf,'tag','lb1');
        state=get(b,'visible');
%         b(3)=findobj(gcf,'tag','lb1');
       
        set(gcf,'InvertHardcopy','off');
         set(b,'visible','off');
         
        ax=findobj(gcf,'type','axes');set(ax,'units','centimeter') ;
        rb=cell2mat(get(ax,'position')) ;
        mx=[max(rb(:,1)+rb(:,3)) max(rb(:,2)+rb(:,4))] ;
        set(gcf,'PaperPosition',[min(rb(:,1)) min(rb(:,2))  (mx(1))   (mx(2))]);
        
        cbar=findobj(gcf,'tag','cbar');
        fontunits=get(cbar,'fontunits');
        fontsize =get(cbar,'fontsize');
        
        set(cbar,'fontsize',fontsize*1.5);
        set(cbar,'fontunits','pixels');
        
        drawnow;
        
         print(gcf,'-djpeg','-r300',fullfile(pa,fi));
         
        set(cbar,'fontunits',fontunits); 
        set(cbar,'fontsize',fontsize);
         
        set(b(1),'visible',state{1});
        set(b(2),'visible',state{2});
        
        set(ax,'units','pixels') ;
    end
elseif strcmp(task,'saverFig')   
     if exist('filename')==0
         [fi pa]=uiputfile('*.fig','save image as figFile');
     else
         [pa fi]=fileparts(filename);
     end
     
    if fi~=0
         saveas(gcf,fullfile(pa,fi));
    end
elseif strcmp(task,'saverFigNmat')%save both
    saveJPGandMAT
     
elseif strcmp(task,'replot')   
      plotter(1);
end

function  changeBackgroundImage(ra,ru)  
%     changeBackgroundImage
  us=get(gcf,'userdata');   
 this=us.anatomicalImg ;
 
r1{1,1}   =strrep(which('SPM.m'),'spm.m','canonical\single_subj_T1.nii');
r1{2,1}   =strrep(which('pslices.m'),'pslices.m','mni_icbm152_t1_tal_nlin_sym_09a.nii');

this= mod(find(strcmp(r1,this)==1 ) ,2)+1 ;
if    isempty(this)
  this   =1 ; 
end
if ~isempty(this)
   us.anatomicalImg   =r1{this,1};
   set(gcf,'userdata',us);
   plotter(1);  
end
  
    plotter(1);   

function clipboardcopy(ra,ru)
b(1)=findobj(gcf,'tag','but1');
b(2)=findobj(gcf,'tag','lb1');
state=get(b,'visible');
set(b,'visible','off');
drawnow;pause(.1);
print -dmeta;
set(b(1),'visible',state{1});
set(b(2),'visible',state{2});
        
        
function saveJPGandMAT(filename)
if exist('filename')==0
    us=get(gcf,'userdata');
    if isempty(us.savename)
        [fi pa]=uiputfile('','save image as JPG and FIG files');
        filename=fullfile(pa,fi);
    else
        filename=us.savename;
    end
    us.savename=[];
    set(gcf,'userdata',us); 
end

gcontext(0,0,'saverFig',filename);
gcontext(0,0,'saver',filename);




function getMNI(ro,ri)
global SO;
if ~isempty(SO)
    if isfield(SO,'fignum')==0
        plotter(1);return
    else
        if SO.fignum~=gcf
            plotter(1);;return
        end
    end
else
   plotter(1);;return
end

co=[slice_overlay2('getpos')]';
%  disp(co);
% labs(co);
try
    [labelx header labelcell]=pick_wrapper(co, 'Noshow');
%     showtable2([0 0 1 1],[header(2:end);labelx(2:end)]','fontsize',8);

    %%SO.img(2).vol.imgdata
%     value=slice_overlay2('pointvals', co');
    
    value=slice_overlay2('pointvals', co');
    val2head='#[1 0.1608 0] Value';
    val2val =[  '#[1 0.1608 0] '       num2str(value(2))    ];
    val2={val2head val2val }';
    tab=[header(2:end);labelx(2:end)];
    tab=[tab(:,1) val2 tab(:,2:end)];
    showtable2([0 0 1 1],tab','fontsize',8);

    
    
% % % % % % % % % % % % % % % % % % % %     value=value(2)
% % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % %    val2head=[ '<b><u><font color="red"   bgcolor="'   'FFFFCC' 'VALUE' '">' '</b>' '</font>'  ];
% % % % % % % % % % % % % % % % % % % % %    val2head=[ '  rr #color=[1 0 1]LAMBER'     ];
% % % % % % % % % % % % % % % % % % % % %   val2head='#color=[1 0 1]VALUE';
% % % % % % % % % % % % % % % % % % % %  val2head='VALUE';
% % % % % % % % % % % % % % % % % % % %     val2={val2head num2str(value) }';
% % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % %     tab=[header(2:end);labelx(2:end)];
% % % % % % % % % % % % % % % % % % % %     tab=[tab(:,1) val2 tab(:,2:end)];
% % % % % % % % % % % % % % % % % % % %      showtable2([0 0 1 1],tab','fontsize',8);
    
    
    try
        fig=max(findobj(0,'tag','pslices'));
        set(0,'currentfigure',findobj(0,'tag','Graphics'));
        spm_mip_ui('SetCoords',co) ;
        set(0,'currentfigure',fig);
    end
end
set(findobj(gcf,'tag','ed1'),'visible','off');
% #############################################################
%
% if 0
%     delete(findobj(gcf,'type','axes'))
%     SO.clf=0 %do not clear figure
%     SO.img(1).vol = spm_vol('avg152T1.img');
%     SO.img(1).vol = spm_vol('C:\spm8\canonical\single_subj_T1.nii')
%     SO.img(1).prop = 1;
%     SO.img(1).cmap = gray;
%     SO.img(2).vol = spm_vol('con_0010.img');
%     SO.img(2).range = [3 7.5];
%     SO.img(2).prop = Inf;
%     SO.img(2).cmap = hot;
%     SO.img(3).vol = spm_vol('con_0010.img');
%     SO.img(3).range = [-2 -4.8];
%     SO.img(3).prop = Inf;
%     SO.img(3).cmap = winter;
%
%     % SO.img(4).vol = spm_vol('con_0010.img');
%     % SO.img(4).range = [-3 -4] ;
%     % SO.img(4).prop = Inf;
%     % SO.img(4).cmap = jet;
%
%     SO.cbar = [2 3 4];
%     SO.transform = 'axial';
%     % SO.transform = 'coronal';
%     SO.slices = [];%-12:6:72;
%
%     slice_overlay2
% end


% function layout(tb,layer)
%
% % cf
% for i=1:size(tb,1)
%     control=tb{1,1}
%     if control==2
%        controltype='radiobutton'
%     end
%
%     g = uicontrol('Style', controltype, 'String', tb{1,4},...
%     'units','normalized',...
%     'Position', us.layer,...%% , 'Callback', '1'
%     'userdata',us,'tag','lb1');
%
%
%
% end


function resizegcn2(ha,he)
% us=get(gcf,'userdata')
% timex=toc()
% try
%     pause(4)
%     drawnow;
plotter(1);
% end






