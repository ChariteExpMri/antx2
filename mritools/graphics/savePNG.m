
function savePNG(filename, varargin)


    
 %% ===============================================
 

% filename=fullfile(pwd,'__dum.png');
p.bgtransp =1;
p.crop     =1;
p.saveres  =300;
p.hf       =gcf;
p.info     =1;

if ~isempty(varargin)
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end


hf=p.hf;

%% ===============================================


% p=u.p;
if exist('filename')==0
    [fi pa]=uiputfile(fullfile(pwd,'*.png'),'save as png');
    filename=fullfile(pa,fi);
end
%% ===============================================
if p.bgtransp==1; set(gcf,'InvertHardcopy','on' );
else ;            set(gcf,'InvertHardcopy','off');
end
% set(gcf,'color',[1 0 1]); 
% set(findobj(gcf,'type','axes'),'color','none');

q=filename;
% set(hf,'InvertHardcopy','off');
% print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ]);


if p.bgtransp==1 || p.crop==1;
    [im hv]=imread(filename);
    if p.crop==1;
        v=mean(double(im),3);
        v=v==v(1,1);
        v1=mean(v,1);  mima1=find(v1~=1);
        v2=mean(v,2);  mima2=find(v2~=1);
        do=[mima2(1)-1 mima2(end)+1];
        ri=[mima1(1)-1 mima1(end)+1];
        if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
        if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
        im=im(do(1):do(2),ri(1):ri(2),:);
    end
    if p.bgtransp==1
        imwrite(im,filename,'png','transparency',[1 1  1],'xresolution',p.saveres,'yresolution',p.saveres);
        if 0
            imd=double(im);
            pix=squeeze(imd(1,1,:));
            m(:,:,1)=imd(:,:,1)==pix(1);
            m(:,:,2)=imd(:,:,2)==pix(2);
            m(:,:,3)=imd(:,:,3)==pix(3);
            m2=sum(m,3)~=3;
            imwrite(im,filename,'png','alpha',double(m2));
        end
%         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
        
%             
    else
        imwrite(im,filename,'png');
    end
end


if p.info==1
    showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
end