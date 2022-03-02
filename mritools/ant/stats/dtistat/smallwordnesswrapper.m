

% - log transform all matrices    : which base (2,10,natural)? (“log.m” is natural); --> natural
% - take mean (entry-wise) across all animals:  how?
% - then do the proportionality threshold with the BCT's threshold_proportional.m script in steps of 0.1 :  steps off ? why not one value (0.1)?
%
% https://github.com/fieldtrip/fieldtrip/blob/master/external/bct/threshold_proportional.m
%
% - calculate small worldness (Paul: which script are you using? There is nothing in BCT, correct?) ? same as TRACY
% - decide qualitatively on a good step (maybe extract the actual threshold in some way by looking at the min in the thresholded matrix?)
% - binarize the matrix (0 where 0 and 1 where nonzero)
% - multiply this threshold entry-wise with individual matrices of animals
% - do the network based stats

% old: function d3=smallwordnesswrapper(d2, task , stepsize, doplot)

function d3=smallwordnesswrapper(d2, z2)


% d2 :3d data  {x*x*Nsubjects}
% --------------z2-input paramter--------------------

stepsize        = z2.stepsize;
task            = z2.swtype;
logarithmize    = z2.logarithmize;
doplot          = z2.doplot;
threshold       = z2.threshold;
% ----------------------------------


stp = stepsize;
dl  = d2;
if logarithmize==1                  %logarithmize data
    dl=log(d2);
end
dl(isinf(dl))=0;
dl(dl<0)     =0;
dm=mean(dl,3);

% w3=threshold_proportional(dm, 0.41);
%
% nsurvived=sum(w3(:)>0);
% survperc=[nsurvived/numel(w3)*100];
% disp(['threshold_proportional: survived: ' ...
%     num2str(nsurvived) '/' num2str(numel(w3))  ' (' num2str(survperc) '%)']);


if ~isempty(strfind(threshold,'max'))
    % ==============================================
    %%   proportional threshold
    % ===============================================
    
    vs=stp:stp:1-stp;
    mp=zeros([size(dm)  length(vs)]);
    surv=[];
    for i=1:length(vs)
        dum=threshold_proportional(dm, vs(i));
        dum=dum>0;
        surv(i,:)=  [sum(dum(:)) sum(dum(:))./numel(dum)*100]; % counts & Percent
        mp(:,:,i) =dum;
    end
    
    % ==============================================
    %%   small wordlness
    % ===============================================
    sw=[];
    for i=1:length(vs)
        atic=tic;
        [swtemp swlabel]=smallworldness_sub(mp(:,:,i),task);
        sw(i,:)=swtemp;
        %disp( [ 't1_(min):' num2str(toc(atic)/60)]);
    end
    % ==============================================
    %%
    % ===============================================
    if doplot==1 && nanmean(nanmean(sw,2),1)~=0
        %hyperlink_plot(sw,swlabel,vs);
        
        temp1.sw     =sw;
        temp1.swlabel=swlabel;
        temp1.vs    =vs;
        assignin('base','temp1',temp1);
        
%         fg;
% hp=plot(temp1.sw,'.-');
% % hl=legend(hp,{'S_ws' 'S_trans' 'S_ws_MC' 'S_trans_MC'},'interpreter','none');
% hl=legend(temp1.hp,temp1.swlabel,'interpreter','none');
% 
% set(hl,'location','southeast');
% 
% xlabel('threshold proportional');
% ylabel('small worldness')
% set(gca,'fontweight','bold','fontsize',9);
% set(gca,'xtick',[1:length(temp1.vs)],'xticklabel',temp1.vs);
% title('prop threshold and small worldness');
% drawnow;
% 
% disp('You should <a href="matlab: plot(magic(10)), disp(''I plotted some stuff'')">my code</a>!')
% 



cod={
    'fg;'
    'hp=plot(temp1.sw,''.-'');'
    'hl=legend(hp,temp1.swlabel,''interpreter'',''none'');'
    'set(hl,''location'',''southeast'');'
    'xlabel(''threshold proportional'');'
    'ylabel(''small worldness'');'
    'set(gca,''fontweight'',''bold'',''fontsize'',9);'
    'set(gca,''xtick'',[1:length(temp1.vs)],''xticklabel'',temp1.vs);'
    'title(''prop threshold and small worldness'');'
    'drawnow;'
    };
cod2=strjoin(cod,'');

disp(['see <a href="matlab:' cod2 '; ">Figure: small worldness</a>!']);

        
%         fg;
%         hp=plot(sw,'.-');
%         % hl=legend(hp,{'S_ws' 'S_trans' 'S_ws_MC' 'S_trans_MC'},'interpreter','none');
%         hl=legend(hp,swlabel,'interpreter','none');
%         
%         set(hl,'location','southeast');
%         
%         xlabel('threshold proportional');
%         ylabel('small worldness')
%         set(gca,'fontweight','bold','fontsize',9);
%         set(gca,'xtick',[1:length(vs)],'xticklabel',vs);
%         title('prop threshold and small worldness');
%         drawnow;
%         figure(    findobj(0,'name','dtistat'))   ;
    end
else
    % explicit threshold value
    threshval=str2num(threshold);
    %threshval=0.2
    
%     km=dm+dm';
%     ihor=find(sum(km,1)==0); ihorkeep=find(sum(km,1)~=0);
%     iver=find(sum(km,2)==0); iverkeep=find(sum(km,2)~=0);
%     km(:,ihor)=[];
%     km(iver,:)=[];
%     
%     %spars=threshold_proportional(km, .9  );
%     spars=threshold_proportional(km, threshval   );
%    %dum=zeros(size(dm));
%    %dum2(iverkeep, ihorkeep )=km;
%   % dum(iverkeep, ihorkeep )=spars;
%    dum=spars>0;
%    surv=  [sum(dum(:)) sum(dum(:))./numel(dum)*100]; % counts & Percent
%    mp =double(dum);
%    [swtemp swlabel]=smallworldness_sub(mp,task);
%     sw=swtemp;
   
   if 1
       
       dum=threshold_proportional(dm, threshval   );
       dum=dum>0;
       surv=  [sum(dum(:)) sum(dum(:))./numel(dum)*100]; % counts & Percent
       mp =double(dum);
       [swtemp swlabel]=smallworldness_sub(mp,task);
       disp(swtemp);
       %error('ss');
       sw=swtemp;
       vs=threshval;
   end
  

   
%     
%     mp_bk=mp;
%     mp=zeros(size(dm));
%     mp(iverkeep, ihorkeep )=mp_bk;
    
    
end
% ==============================================
%%
% ===============================================
swm     =mean(sw,2);
imax    =find(swm==max(swm));  %max small worldness over average
if length(imax)>1
  imax= floor(length(imax)/2) ; 
end
% imax=4;
q.maxSW =swm(imax);
q.tresh =vs(imax);

if isempty((q.maxSW) ) || max(q.maxSW)==0
    %msgbox('small worldness does not work: presumably not enough connections'); 
    cprintf([1   0 1],['..could not calculate small worldness for data sparsening. Presumably not enough connections.' '\n' ]);
%     d3=d2;
%     return
end

cprintf([0 .5 0],['..calculation small worldness for data sparsening successfull.' '\n' ]);
try
    disp(['small worldness: '   num2str(q.maxSW)    '   (threshold (keep data %): '   num2str(q.tresh)   ')']);
end
% ==============================================
%%   mask matrizces
% ===============================================
M=double(mp(:,:,imax)); %use this matrix
d3= repmat(M,[1 1 size(d2,3)]).*double(dl)   ; %  OUTPUT


%% test another kind of-threshold
if 0
%         cprintf([1 0 1],['..TEST: SD-threshold' '\n' ]);
%         sd=std(d2,[],3);
%         M=otsu(sd,4)>=2;
    
        cprintf([1 0 1],['..TEST: min-threshold' '\n' ]);
%         sd=median(d2,3);
        sd=max(d2,[],3);
        M=otsu(sd,2)>=2;
        %fg,imagesc(M)
        d3= repmat(M,[1 1 size(d2,3)]).*double(dl)   ; %  OUTPUT
    
%     cprintf([1 0 1],['..TEST: min-threshold' '\n' ]);
%     sd=mean(squeeze(mean(d2,1)),2);
%     [so isort]=sort(sd,'descend');
%     perc=5;
%     idx=round(length(isort)*(5/100));
%     M=zeros(size(mp,1),size(mp,2));
%     M(isort(1:idx),:)=1;
%     M(:,isort(1:idx))=1;
%     d3= repmat(M,[1 1 size(d2,3)]).*double(dl)   ; %  OUTPUT
    
    %     %fg,imagesc(M)
    %     d3= repmat(M,[1 1 size(d2,3)]).*double(dl)   ; %  OUTPUT
    
    
end


% ==============================================
%%   plot Matrix
% ===============================================
%% plot sparseMatrix
temp1.M    =M;
temp1.tresh=q.tresh;
cod={
'fg;'
'imagesc(temp1.M);'
'title([''proportional threshold: '' num2str(temp1.tresh) ''% (n='' num2str(sum(temp1.M(:))) '')'' ]);'
};

assignin('base','temp1',temp1);
cod4=strjoin(cod,'');
disp(['see <a href="matlab:' cod4 '; ">Figure: proportional threshold</a>!']);


% ==============================================
%%   other
% ===============================================
% error

function hyperlink_plot()



fg;
hp=plot(temp1.sw,'.-');
% hl=legend(hp,{'S_ws' 'S_trans' 'S_ws_MC' 'S_trans_MC'},'interpreter','none');
hl=legend(temp1.hp,temp1.swlabel,'interpreter','none');

set(hl,'location','southeast');

xlabel('threshold proportional');
ylabel('small worldness')
set(gca,'fontweight','bold','fontsize',9);
set(gca,'xtick',[1:length(temp1.vs)],'xticklabel',temp1.vs);
title('prop threshold and small worldness');
drawnow;

disp('You should <a href="matlab: plot(magic(10)), disp(''I plotted some stuff'')">my code</a>!')




cod={
'fg;'
'hp=plot(temp1.sw,''.-'');'
'hl=legend(hp,temp1.swlabel,''interpreter'',''none'');'
'set(hl,''location'',''southeast'');'
'xlabel(''threshold proportional'');'
'ylabel(''small worldness'');'
'set(gca,''fontweight'',''bold'',''fontsize'',9);'
'set(gca,''xtick'',[1:length(temp1.vs)],''xticklabel'',temp1.vs);'
'title(''prop threshold and small worldness'');'
'drawnow;'
};
cod2=strjoin(cod,'');








