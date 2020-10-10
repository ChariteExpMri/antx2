
% ==============================================
%%   
% ===============================================

% paras:  x,y,z,pitch,roll,yaw
function paras=getorientviadots(f222,f3, parafile, trafofile, ndots,show,cleanup)


if 0
    clear
    f222 ='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_3\rigid\rigidmouse.nii'
    f3 ='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_3\rigid\_rigidtemplateRotated.nii'
    parafile ='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_3\rigid\trafoeuler5_MutualInfo.txt'
    ndots=2000;
    show=0;
    
    paras=getorientviadots(f222,f3, parafile,[], ndots,show);
    %1.2292    0.0292    0.0292   -2.3959   -0.5050  -80.6535
end

% ==============================================
%%   
% ===============================================


paras       =[];
outdir      =fileparts(f222);

if isempty(trafofile)
    trafofile=fullfile(outdir,'TransformParameters.0.txt');
    if exist(trafofile)~=2
        error(['trafofile expected, but does not exist: ' trafofile]);
    end
end

% ==============================================
%%   make dots in native space  
% ===============================================
[ha a mm ic]=rgetnii(f222);

a2=a(:);
% ndot=round(size(a2,1)/1000);
idot=round(linspace(1,size(a2,1),ndots));
d=zeros(size(a2));
d(idot)=1:length(idot);

d2 =reshape(d,ha.dim);
% d2b=imdilate(d2,strel('disk',5));
dotfi=fullfile(outdir,'dot.nii');
rsavenii(dotfi,ha,d2);

% dotfi2=fullfile(outdir,'dotlarge.nii');
% rsavenii(dotfi2,ha,d2l);

if show==2
    rmricron([],f222,dotfi,13);
end
% ==============================================
%%   transform  dots to Standard-space
% ===============================================
interp_orig=get_ix(trafofile,'FinalBSplineInterpolationOrder');
set_ix(trafofile,'FinalBSplineInterpolationOrder',    0);
% [dotfiN,wps] = run_transformix(dotfi,[],trafofile,outdir,'');
[arg,dotfiN,wps] =evalc('run_transformix(dotfi,[],trafofile,outdir,'''')');
% [dotfi2N,wps] = run_transformix(dotfi2,[],trafofile,outdir,'')

if show==2
    rmricron([],f3,dotfiN,13);
end
set_ix(trafofile,'FinalBSplineInterpolationOrder',    interp_orig);
% ==============================================
%%   read dots from Norm space
% ===============================================
% if 0 example
%     clear;clc;
%     f1='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\dot.nii'
%     f2='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\elx_dot.nii'
%     
%     g1='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\rigidmouse.nii'
%     g2='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\_rigidtemplateRotated.nii'
% end
% ---------------------------------------------------------------

f1=dotfi;   % dots native space
f2=dotfiN;  % dots standard space
g1=f222;    % t2-masked == "_msk.nii" (native space)
g2=f3;      % rotated template based on orient-type


[ha a am ai]=rgetnii(f1); %native
a2=a(:);
[hb b bm bi]=rgetnii(f2); %standard
b2=b(:);


ixa=find(a2>0);
ta=a2(ixa);
nb=histc(b2,ta);
ta(nb==0)=[];   ixa(nb==0)=[];

% mm and idx
[va mma vb mmb]= deal(zeros(size(ta,1),3));
for i=1:size(ta,1)
    is=find(a2==ta(i));
    mma(i,:)=mean(am(:,is),2)';
    va(i,:) =round(mean(ai(:,is),2)');
end
for i=1:size(ta,1)
    is=find(b2==ta(i));
    mmb(i,:)=mean(bm(:,is),2)';
    vb(i,:) =round(mean(bi(:,is),2)');
end

% ==============================================
%%
% ===============================================

% ==============================================
%%   rottable
% ===============================================
if 0
    r={'0' 'pi/2' '-pi/2' 'pi' '-pi'};
    cs=allcomb(r,r,r);
    rotall=cellfun(@(a,b,c){[a ' ' b ' ' c ]}, cs(:,1),cs(:,2),cs(:,3) );
end
if 0 % ------pos2
    r={'0' 'pi/2' '-pi/2' 'pi' '-pi'};
    r=cell2mat(cellfun(@(a){[str2num(a) ]} , r )')
    rotall=allcomb(r,r,r);
end

if 1
    % rotm=[-pi:.1:pi]'
    rotm=[-pi/2:.1:pi/2];  % ~32000 anlges
    rotall=allcomb(rotm,rotm,rotm); 
    %size(rotall)
end
% ==============================================
%%   calc loop
% ===============================================

m    =spm_get_space(g2);
tb   =zeros(size(rotall,1),     5   );
rota =rotall;
% tic
for j=1:length(rotall)
    %pdisp(j,1000);
    %     if iscell(rota)
    %         rotvec=str2num(rota{j});
    %     else
    rotvec=       rota(j,:);
    %     end
    %----------------------
    %     % slower
    %     if 0
    %         vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotvec 1 1 1 0 0 0])));
    %         rotinv = vecinv(4:6);
    %         vec=[0 0 0 rotinv];
    %         B=[zeros(1,6) 1 1 1 0 0 0];
    %         B(1:length(vec))=vec;
    %         m2=spm_matrix(B);
    %         ms=(m2*m);
    %     end
    %----------------------
    
    %m2=inv(spm_matrix([0 0 0 rotvec 1 1 1 0 0 0]));
    ms=inv(spm_matrix([0 0 0 rotvec 1 1 1 0 0 0]))*m;
    
    %----------------------
    %     % slower 
    %     mmd=[];
    %     for i=1:3
    %         mmd(i,:)=[ms*[vb(i,:) 1]']';
    %     end
    %----------------------
    mmd0=(ms*[vb ones(size(vb,1),1)  ]')';
    mmd=mmd0(:,1:3);
    
    
    
        tr=mean(mma-mmd,1);%old
        %tr=mean(mmd-mma,1);
        ss=mmd+repmat(tr,[size(mma,1) 1])-mma;
        %qr=sqrt(sum(sum(ss.^2,2)));
        qr= (sum(sum(ss.^2,2)));

    %     qr= sum(sum(sqrt((mmd-mma).^2),1),2);
    tb(j,:)=[j qr tr];
end
% toc
% ==============================================
%%   GER ROTATIONS ANS TRANLATIONS   ..check
% ===============================================
% f2 ='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\_rigidtemplateRotated.nii'
% f1 ='F:\data2\Malo_tubesplit\dat\DICOM_PA1_ST1_SE1_2\rigid\rigidmouse.nii'


ir=find(tb(:,2)==min(tb(:,2)));
ir=ir(1);
% disp(['best match: (#' num2str(ir) ') '  '[' rota{ir}  ']']);
% [id rotstring]=myrottest('ref',g1,'img',g2,'rot',rota(ir),'wait',0);
% keyboard
if show==2
    rotstr=cellstr(sprintf('%2.2f ',rota(ir,:)))
    [id rotstring]=getorientation('ref',g1,'img',g2,'info', 'best match','mode',1,...
        'wait',0,'rot',rotstr,'disp',1);
    
end

rot    = rota(ir,:) ;%  str2num(rota{ir});
trans  =(tb(ir,3:5));
% paras=[rot trans];

% ==============================================
%%  bring rotated template to  native space
% ===============================================
m=spm_get_space(g2);
vecinv = spm_imatrix(inv(spm_matrix([-trans rot 1 1 1 0 0 0],'R*Z*S*T')));
rotinv = vecinv(1:6);
vec=[rotinv];
B=[zeros(1,6) 1 1 1 0 0 0];
B(1:length(vec))=vec;
m2=spm_matrix(B);

paras=spm_imatrix(m2);
paras=paras(1:6);

mx=[m2*m];
% mx(1:3,4)=mx(1:3,4)+trans';

% g3=stradd(g2,[strrep(p.prefix,'','') ''],1); % landet im template-folder
if show>0
    g3=stradd(g1,[ 'i'],1); % landet im g1-folder ("t2.nii"-dir)
    copyfile(g2,g3,'f');
    spm_get_space(g3,mx);
    [pa,name, ext]=fileparts(g3);
    rmricron([],g1,g3,1);
end

% %% --backtrafo  -----------------------------------------
% %  clc;mz=(m2*m); m, mb=inv(m2)*mz, m-mb
% mb=inv(m2)*mx;
% if 1 % TEST
%     g4=stradd(g3,'i',1);
%     copyfile(g3,g4,'f');
%     spm_get_space(g4,mb);
%     rmricron([],g2,g4,1);
% end

% ==============================================
%%   bring image to rotated Normspace
% ===============================================
M1=spm_get_space(g1);
mb=inv(m2)*M1;

if show>0
    g5=stradd(g1,'i',1);
    copyfile(g1,g5,'f');
    spm_get_space(g5,mb);
    rmricron([],g2,g5,1);
end

% ==============================================
%%   bring dotImage to rotated Normspace
% ===============================================
if show>0
    M1=spm_get_space(f1);
    mb=inv(m2)*M1;
    
   
    g5=stradd(f1,'i',1);
    copyfile(f1,g5,'f');
    spm_get_space(g5,mb);
    rmricron([],f2,g5,1);
end

% ==============================================
%%   
% ===============================================

if cleanup==1
   try; delete(f1); end 
   try; delete(f2); end 
   
   try; delete(stradd(f1,'i',1)); end
   try; delete(stradd(g1,'i',1)); end
end


