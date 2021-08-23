%% SNR Estimation
% see Sijbers et al (Phys. Med. Biol. 52 (2007) 1335–1348)
% using Brummers method
%%
%% output 
% h  : fighandle (otherwise empty)
% s  : struct with fit data


function [snrMap,estStd,h,s] = snrAuto(img,show,fac, imagemsg)



%% Normalize input dataset and plot histogram
maxi = max(img(:));
imgNorm=img(:)./maxi;

% if nargin < 3, fac = 1; end
% if nargin < 2, show =0;end
h=[]; %fig handle
s=struct();

if exist('show')~=1 || isempty(show) ;   show = 0; end
if exist('fac')~=1  || isempty(fac)  ;   fac  = 1; end


bins  = ceil(sqrt(numel(imgNorm)))*fac;

[binCount,binLoc]=hist(imgNorm,bins);

% eliminate bins with no entries (fit won't work without)
index =find(binCount==0);
binLoc(index) = [];
binCount(index) = [];

if show > 3
figure, bar(binLoc,binCount) 
xlabel('Image Intensity [0-1 range]')
ylabel('Counts')
title('Histogram')
end

%% Fit Rayleigh distribution to partial histogram
% Warning: Using global maximum
[maxRayl,estStd] = max(binCount);
cutOff = 2*estStd;
% estStd = estStd/bins;
estStd = estStd/size(binCount,2);

myfun = @(x)rayl_2p(x, binLoc(1:cutOff) , binCount(1:cutOff));
yout=fminsearch(myfun,[maxRayl estStd]);
% yout=fminsearch('rayl_2p',[maxRayl estStd],[],binLoc(1:cutOff),binCount(1:cutOff));
if show > 1
    figure, plot(binLoc,binCount,'k.');hold on;
    x=[0:estStd/100:4*estStd].';
    plot(x,yout(1).*raylpdf(x,yout(2)),'r','LineWidth',1.5);
    xlabel('Image Intensity')
    ylabel('Counts')
    title('Rayleigh Fit')
end
if show > 0
    h=figure; plot(binLoc(1:2*cutOff),binCount(1:2*cutOff),'k.');hold on;
    x=[0:estStd/500:4*estStd].';
    plot(x,yout(1).*raylpdf(x,yout(2)),'r','LineWidth',1.5);
    xlabel('Image Intensity')
    ylabel('Counts')
    if exist('imagemsg')==1
        title({'Rayleigh Fit (Zoom)' ;imagemsg;},'fontsize',8)
    else
        title('Rayleigh Fit (Zoom)')
    end
end





% ==============================================
%%   
% ===============================================

s={};
p={};
p.title     = 'Rayleigh Fit';
p.binLoc   = binLoc;
p.binCount = binCount;
p.x         =[0:estStd/100:4*estStd].';
p.y         =yout(1).*raylpdf(p.x,yout(2));
p.descr     ={'Image Intensity' 'Counts' 'Rayleigh Fit'};
s.p1=p;
% --------------
p={};
p.title     = 'Rayleigh Fit (Zoom)';
p.binLoc    = binLoc(1:2*cutOff);
p.binCount  = binCount(1:2*cutOff);
p.x         = [0:estStd/500:4*estStd].';
p.y         = yout(1).*raylpdf(p.x,yout(2));
p.descr     ={'Image Intensity' 'Counts' 'Rayleigh Fit (Zoom)'};
s.p2=p;

if 0
    px=s.p1;
    figure, plot(px.binLoc,px.binCount,'k.');hold on;
    plot(px.x,px.y,'b','LineWidth',1.5);
    xlabel(px.descr{1});
    ylabel(px.descr{2});
    title(px.descr{3});
    
    px=s.p2;
    figure, plot(px.binLoc,px.binCount,'k.');hold on;
    plot(px.x,px.y,'b','LineWidth',1.5);
    xlabel(px.descr{1});
    ylabel(px.descr{2});
    title(px.descr{3});
    
end
    

% p.space1    ='--------'
% s.title2     = 'Rayleigh Fit (Zoom)';



% s.cutOff   = cutOff;

% ==============================================
%%   
% ===============================================
estStd = yout(2).*maxi;






%% "SNR-Map"
% if show
% disp(['Estimated Standard Deviation (normalized): ' num2str(estStd)])
% end
% Corrected SNR according to 
% Gudbjartsson H, Patz S. The Rician distribution of noisy MRI data. Magn Reson Med. 1995;34(6):910?914.

snrMap=sqrt(abs((img.^2)-(estStd.^2)))./estStd;
dims = size(img);

if show > 2
    if(numel(dims)==2)
        figure,imagesc(snrMap),colorbar
    else
        figure,imagesc(snrMap(:,:,ceil(dims(3)/2))),colorbar   
    end
    title('SNR Map')
    axis off
end
% estStd=estStd/maxi;

end

function err=rayl_2p(fitPar,x,data)

err=sum((fitPar(1)*raylpdf(x,fitPar(2))-data).^2); 
end