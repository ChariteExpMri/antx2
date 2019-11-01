
%% manually reorient img1 tp img2 (GUI)
% img1  :sourceIMG (to be transformed)
% img2  : refIMG
% modality: (optional): [0/1] no wait/wait to until button is pressed 


function varargout=displaykey2(img1,img2,modality,params)
varargout{1}=[];

% reorient 1st Image to 2nd image
% img1='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c1s20150908_FK_C1M02_1_3_1.nii,1';
% img2='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c3s20150908_FK_C1M02_1_3_1.nii'
% displaykey2(img1,img2)
% img1='C:\spm8_30apr15\spm8\canonical\single_subj_T1.nii'
% img2='C:\spm8_30apr15\spm8\tpm\grey.nii'
% displaykey2(img1,img2)

if exist('modality')~=1; modality=0; end   %[0/1] no wait/wait to finish

try; clear global aux ; end
global aux; aux=[];
aux.pwd =pwd;

if strcmp(spm('Ver'),'SPM12')% use old function
    cd(fullfile(fileparts(which('ant.m')),'spm8functions','private'));
end

matlabbatch={};
matlabbatch{1}.spm.util.disp.data = {img1};
[msg00 arg]=evalc('spm_jobman(''run'',matlabbatch)');
delete(findobj(gcf,'tag','Menu'));delete(findobj(gcf,'tag','Interactive'));
displaykey(2);%without SPMhook


% v='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1\c3s20150908_FK_C1M02_1_3_1.nii'
%% keyboard
if ~isempty(img2)
    keyb('ovl',img2)
end

%% add reortientIMages-TxtFile

   hfigg    =findobj(0,'tag','Graphics');
hbut =findobj(hfigg,'string','Reorient images...');
iptaddcallback(hbut, 'Callback', @writeTXTfile);
  
set(hfigg, 'CloseRequestFcn', @go2oldpath); %spm12

% set(hfigg,'WindowButtonUpFcn','12000')
% iptaddcallback(hfigg, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
% iptaddcallback(hfigg, 'Callback', 'spm_orthviews2(''Redraw'')');

for i=1:9
hed= findobj(gcf,'callback',['spm_image(''repos'','   num2str(i) ')']);
set(hed,'keypressfcn', @key4editfield);
% iptaddcallback(hed, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
% iptaddcallback(hed, 'Callback', 'spm_orthviews2(''Redraw'')');
end
%spm_orthviews('context_menu','orientation',3);
%  spm_orthviews2('Redraw')

hreorintbutt=findobj(gcf,'string','Reorient images...');
iptaddcallback(hreorintbutt, 'Callback', @addinfo);

addok;
addcancel;

addinfo;

% addautoregister;
addsetzero;
% addreorientTPM;
       
% if modality==1
%     addmodality
%     iptaddcallback(hreorintbutt, 'Callback', @addmodality);
% end

if exist('params')
    if isfield(params,'mat')
       mv= spm_imatrix(params.mat);
        
       for i=1:9
           hed= findobj(gcf,'callback',['spm_image(''repos'','   num2str(i) ')']);
           set(hed,'string',num2str(mv(i)));
           
        set(gcf,'CurrentObject',hed  );
        hgfeval(get(hed,'callback'));
       end
        spm_orthviews2('Redraw');
    end
    if  isfield(params,'msg')
        
         [mpa mfi mext ]=fileparts(img1);
        try [spa sfi sext ]=fileparts(img2); catch;  [spa sfi sext ]=deal('');end
        
        msg0={'====================================='};
        msg0(end+1,1)={['I1: ' [mfi mext]]};
        msg0(end+1,1)={['   path: ' [mpa]]};
        msg0(end+1,1)={['I2 (green): ' [sfi sext]]};
        msg0(end+1,1)={['   path: ' [spa]]};
        msg0(end+1,1)=msg0(1);
        
        msg1=params.msg;
        if ischar(msg1)
            msg1=cellstr(msg1);
        end
        msg2={'# hit "h"-key to inspect shortcut list'};
        msg=[msg1;msg0; msg2];
        
        
        set(findobj(gcf,'tag','infos'),'string',msg);
        set(findobj(gcf,'tag','infos'),'backgroundcolor','w','position',[.5 .45 .5 .25],...
            'fontsize',8,'foregroundcolor','k','fontweight','bold');
    end
end

iconpannel4spm; %iconbanner
drawnow;

if modality==1
    uiwait(gcf);
end


varargout{1}=get(findobj(gcf,'tag','ok'),'userdata');
global aux;
cd(aux.pwd);
 set(gcf,  'CloseRequestFcn', 'closereq');
close(gcf);




%%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function go2oldpath(e,e2)
global aux;
cd(aux.pwd);
 set(gcf,  'CloseRequestFcn', 'closereq');


function addmodality(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',     'String', 'END','units','normalized');
set(pb,'position',  [.85 .6 .1 .05],'backgroundcolor',[0 .8 0],'callback','close(gcf)');
set(hfigg,'units',units);

    
function addinfo(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
infos={};
infos{end+1,1}=['*** INFOS ***'];
infos{end+1,1}=['- type [h]: hor HOTKEYS help menu'];
infos{end+1,1}=['- use [Reorient Images] Button to apply transformation to images (GUI) '];
ed=uicontrol('Style', 'text',...
           'String', infos,'units','normalized',...
           'Position',[.65 .45 .3 .15],'max',100,'tag','infos'); 
set(ed,'fontsize',14,'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(hfigg,'units',units);

function addreorientTPM
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'popup',...
           'String', 'Reorient TPM | reorient other images (GUI)',...
           'units','normalized','callback',@reorientTPM,...
           'Position',[.8 .41 .14 .03],'fontweight','bold','fontsize',14,...
           'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
   set(pb,'TooltipString','reorient TPMs');    
set(hfigg,'units',units);


function addautoregister(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
           'String', 'AUTOREG','units','normalized','callback',@runautoreg,...
           'Position',[.7 .41 .1 .03],'fontweight','bold','fontsize',14,...
           'foregroundcolor',[1 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
   set(pb,'TooltipString','get rough orientation');    
set(hfigg,'units',units);


function addok(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
           'String', 'OK','units','normalized','callback',@setok,'tag','ok',...
           'Position',[.6 .41 .1 .03],'fontweight','bold','fontsize',14,...
           'foregroundcolor',[ 0.4667    0.6745    0.1882],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','ok');
set(hfigg,'units',units,'userdata',[]);
set(pb,'position',[.4 .41 .1 .03])

function addcancel(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
           'String', 'Cancel','units','normalized','callback',@setcancel,...
           'Position',[.6 .41 .1 .03],'fontweight','bold','fontsize',14,...
           'foregroundcolor',[ 0.4667    0.6745    0.1882],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','cancel');
set(hfigg,'units',units);
set(pb,'position',[.5 .41 .1 .03])

function addsetzero(ra,ro)
hfigg=gcf;
units=get(hfigg,'units');
set(hfigg,'units','normalized');
pb=uicontrol('Style', 'pushbutton',...
           'String', 'Reset','units','normalized','callback',@setzero,...
           'Position',[.6 .41 .1 .03],'fontweight','bold','fontsize',10,...
           'foregroundcolor',[0 0 0],'backgroundcolor',[1 1 1],'horizontalalignment','left');
set(pb,'TooltipString','set all Transition and Rotation Paras to Zero');
set(hfigg,'units',units);

function reorientTPM(h,e)
global st;
gm=st.vols{1}.fname;
t2=st.overlay.fname;
[pa fi ext]=fileparts(t2);

if get(h,'value')==1
    files={fullfile(pa, '_b1grey.nii') ; fullfile(pa, '_b2white.nii') ; fullfile(pa, '_b3csf.nii')};
elseif get(h,'value')==2;
    prefdir=pa;
    [files,sts] = cfg_getfile2(inf,'any',{'TASK:  select all images to reorient' ...
        'NOTE:- ALL 3 TPMS (gray/white/CSF) MUST BE SELECTED !!!!! ',...
        '    -the correct path is determined automatically'},[],prefdir,'img|nii');
end

if isempty(files)     return          ;end



hfig=findobj(0,'tag','Graphics');
Bvec=[];
for i=1:9
hed= findobj(hfig,'callback',['spm_image(''repos'','   num2str(i) ')']);
Bvec(1,i)=str2num(get(hed,'string'));
% iptaddcallback(hed, 'Callback', 'spm_orthviews(''context_menu'',''orientation'',3)');
% iptaddcallback(hed, 'Callback', 'spm_orthviews2(''Redraw'')');
end
predef=[Bvec [0 0 0]];
fsetorigin(files, predef);  %ANA

%  displaykey2(gm,t2)






function runautoreg(h,b)
lab=get(h,'string'); col=get(h,'backgroundcolor');
set(h,'string','..wait..'); set(h,'backgroundcolor',[1 1 0]);
drawnow;

% V:\mritools\ant\paraaffine4rots.txt
parafile=which('paraaffine4rots.txt');
global st
f1=st.vols{1}.fname;  f2=st.overlay.fname;
 [rot id trafo]=findrotation(f1,f2,parafile, 1,0);
  for i=1:6
        hfig=findobj(0,'tag','Graphics');
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
        set(hfig,'CurrentObject',ex  );
        set(ex,'string',num2str(trafo(i)) );
        hgfeval(get(ex,'callback'));
    end
    spm_orthviews2('Redraw');
    set(h,'string',lab); set(h,'backgroundcolor',col);


function setzero(h,b)
global st
f1=st.vols{1}.fname;    f2=st.overlay.fname;
trafo=zeros(1,6);
  for i=1:6
        hfig=findobj(0,'tag','Graphics');
        ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
        set(hfig,'CurrentObject',ex  );
        set(ex,'string',num2str(trafo(i)) );
        hgfeval(get(ex,'callback'));
    end
    spm_orthviews2('Redraw');






% spm_orthviews('context_menu','orientation',3);
% spm_orthviews2('Redraw');



 

% 
function key4editfield(src,evnt)

tdel=.01;
if strcmp(evnt.Key,'return')
    pause(tdel);
    spm_orthviews('context_menu','orientation',3);
%      pause(tdel);
    spm_orthviews2('Redraw');
%      pause(tdel);
elseif strcmp(evnt.Key,'tab')  %% UPDATE
    pause(tdel);
    spm_orthviews('context_menu','orientation',3);
    spm_orthviews2('Redraw');
end



function writeTXTfile(h1,h2)
global st;

vector= (st.B);
fileout=regexprep(st.vols{1}.fname, '.nii|.hdr|.img', '_REORIENT.txt');
dlmwrite(fileout,  vector,'delimiter','\t','delimiter','\t');

function setcancel(e1,e2)
uiresume(gcf);

function setok(e1,e2)


% findobj(gcf,'tag','ok')

m=[];
for i=1:9
    hed= findobj(gcf,'callback',['spm_image(''repos'','   num2str(i) ')']);
    m(1,i)=str2num(get(hed,'string'));
end
set(e1,'userdata',m);
uiresume(gcf);



