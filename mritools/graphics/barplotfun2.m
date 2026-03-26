
%% make barplots
% barplotfun2(t, saveas,v0,p0)

%INPUT.

% t-< 1x8 CELL> WITH
% t={[1]ME, [2]SD, [3]DP, [4]title,[5]legend, [6]xlabel, [7]ylabel, [8]color, [9]ylimits };
% 1: vector with m-means  
% 2: vector with m-standard deviations
% 3:[1 x m] cell with datapoints 
% 4: title <string>
% 5: legend with m-stringcells
% 6: xlabel <string> or empty
% 7: ylabel <string> or empty
% 8: colors  m x 3 color-array
% 9: ylimits [lower upper]
% 
% EXAMPLE
% me=[0.000606551330708005 0.000625463618171644];
% sd=[1.09487834333493e-05 8.2300956205499e-06];
% dp={[0.00061629;0.00058645;0.00061812;0.00060494;0.00061124;0.00060683;0.00062124;0.000614;0.00059895;0.00061896;0.00060816;0.00059206;0.00061767;0.00059196;0.00058786;0.00061041;0.00061508;0.0006122;0.00059663;0.00060198] [0.00061736;0.00063278;0.00062255;0.00063445;0.00063127;0.00063498;0.00063706;0.00061314;0.00062441;0.00062442;0.00062157;0.00062484;0.0006122]};
% tit='ki<wt';
% leg={'ki' 'wt'};
% xlab='xlab';
% ylab='ylab';
% col=[1 0 0;0 0.517241379310345 0.96551724137931];
% t2={me ,sd,dp, tit ,leg , xlab , ylab , col };
% barplotfun2(t2,'',struct('ha',1,'legend',0,'save',0));
%
% with yllimits
% dpall=[dp{1}; dp{2};];
% mima=[min(dpall) max(dpall)];
% add=(mima(2)-mima(1)).*0.1;
% ylims=[mima(1)-add mima(2)+add];
%  t2={me ,sd,dp, tit ,leg , xlab , ylab , col ylims };
%  barplotfun2(t2,'',struct('ha',1,'legend',0,'save',0));
% 
% 
%% ====input paramete [v-struct]===========================================
% v.legend       =1;   %make legend [0.1]
% v.legendsuffix ='_legend'; %suffix-string for png-filename for legend, default: '_legend' 
% v.save        =1;    %save plot [0,1]
% v.hide        =0;    %hide plot during creation [0,1]
% v.csize       =[7 10]; %canvas size [width height] in cm, default [7 10 ]
% v.bgap        =0.15;  %bordergap: gap between bars and left right border of coanvas
% 
% v.font='Arial';%fontname
% v.ti_fs = 8;   %title fontsize, default: 8
% v.ax_fs =12;   %axis fontsize, default: 12
% v.ax_lw =1.5;  %axis linewidth, default: 1.5
% v.la_fs =12;   %x/y label fontsize, default: 12
% v.le_fs =12;   %legend fontsize, default: 12
% 
% v.verbose     =1; % display messages, [0,1]; default: 1
% %% ====input plot-paramter [p-struct]===========================================
% p=struct();
% p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
% p.sdalpha =[.5] ; %bar-transparency [0-1]
% p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
% p.mewidth =2;       % mean-linewidth; default: 2
% p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
% p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
% p.smarkersize=3;  %single dots , markersize, default: 3
% p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
% p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]



function barplotfun2(t, saveas,v0,p0)
warning off;

%% ====input paramete [v-struct]===========================================
v.legend       =1;   %make legend [0.1]
v.legendsuffix ='_legend'; %suffix-string for png-filename for legend, default: '_legend' 
v.save        =1;    %save plot [0,1]
v.hide        =0;    %hide plot during creation [0,1]
v.csize       =[7 10]; %canvas size [width height] in cm, default [7 10 ]
v.bgap        =0.15;  %bordergap: gap between bars and left right border of coanvas

v.font='Arial';%fontname
v.ti_fs = 8;   %title fontsize, default: 8
v.ax_fs =12;   %axis fontsize, default: 12
v.ax_lw =1.5;  %axis linewidth, default: 1.5
v.la_fs =12;   %x/y label fontsize, default: 12
v.le_fs =12;   %legend fontsize, default: 12

v.res       =600; %image resolution : default: 600
v.verbose     =1; % display messages, [0,1]; default: 1
%% ====input plot-paramter [p-struct]===========================================
p=struct();
p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
p.sdalpha =[.5] ; %bar-transparency [0-1]
p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
p.mewidth =2;       % mean-linewidth; default: 2
p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
p.smarkersize=3;  %single dots , markersize, default: 3
p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]






if exist('v0')==1;     v=catstruct(v,v0); end
if exist('p0')==1;     p=catstruct(p,p0); end


%% ===============================================

%% ===============================================
%% MAKE PLOT
%% ===============================================
%  for j=1:size(tt,1)
%     t=tt(j,:);
% cols=[ [128,0,128]/255 ;
%     repmat(.7,[1 3])
%     ];
% cols=[];for i=1:6; cols(i,:)=uisetcolor; end
% cols=[
%     0.7294    0.8314    0.9569
%     0.8706    0.9216    0.9804
%     0.7569    0.8667    0.7765
%     0.8941    0.9412    0.9020
%     0.9255    0.8392    0.8392
%     0.9608    0.9216    0.9216];

% cols=[
%     0 0 1
%     0.7294    0.8314    0.9569
%     0.4667    0.6745    0.1882
%     0.7569    0.8667    0.7765
%     0.9490    0.4392    0.4392
%     0.9255    0.8392    0.8392
%     1.0000    0.8431         0
%     0.9451    0.8784    0.5176
%     ];
%
% if length(t)>=9  ;%COLOR
% cols=t{9};
% end


%% ===============================================
if v.hide==1;     hf=fg('visible','off'); else;    hf= fg;end

set(hf,'units','centimeters');
% wh=[7 10];
wh=v.csize;
% cprintf('*[0 0 1]', [['imageSize(cm): '  '[' sprintf('%2.2f x %2.2f',wh) ']']   '\n']);

if v.verbose ==1
    disp(['   imageSize(cm): '  '[' sprintf('%2.2f x %2.2f',wh) ']']);
end

set(hf,'position',[[10 2]  wh ]);
hold on;
% ===============================================
n=1;
vec=n;
nbar=length(t{3});
hp=[];hhp=[];
for i=1:nbar
    plotDatapoints=1;
    w.me=t{1}(i);
    w.sd=t{2}(i);
    w.dp=t{3}{i};
    
    colx=t{8}(i,:);
    p.sdcol   =colx;
    
%     p=struct();
%     p.xs      =.48 ; %extend in x-direction
%     p.sdalpha =[.5];
%     p.mecol   =[0 0 0];
%     p.mewidth =2;
%     sfacecol=repmat([0.3],[1 3]);
%     p.sedgecol=repmat([0],[1 3]);
%     p.smarkersize=3;
%     p.sstackbottom=0;
%     p.sjitter=1;%0.5;
     
    o1=plot_mesdsc( n   ,w.me(1),w.sd(1), w.dp,p  );
    %     p.sdcol   =cols(2,:); %[0 0 1];
    %     o1=plot_mesdsc( n ,w.me(2),w.sd(2), dp,p  );
    uistack(o1.hh,'top');
    n=n+1;
    hp(end+1,1)=o1.hp;
    hhp{i}=o1;
    vec(1,end+1)=n;
end

if length(t)==9
    ylim(t{9})
end
% ===============================================
vec=vec(1:nbar);
% xbord=0.15;
xbord=v.bgap ;%bordergap
xlim([vec(1)-p.xs-xbord vec(end)+p.xs+xbord]);
% ===============================================

% v.font='Arial';%fontname
% v.ti_fs = 8;   %title fontsize, default: 8
% v.ax_fs =12;   %axis fontsize, default: 12
% v.ax_lw =1.5;  %axis linewidth, default: 1.5
% v.la_fs =12;   %x/y label fontsize, default: 12
% v.le_fs =12;   %legend fontsize, default: 12


fontName=v.font;%'Arial';
fs_ti   =v.ti_fs;% 8;
fs_ax   =v.ax_fs;%12;
lw_ax   =v.ax_lw;%1.5;
fs_label=v.la_fs;%12;
fs_legend=v.le_fs;%12; %legend


% fs_ti   =8;
% fs_ax   =12;
% lw_ax   =1.5;
% fs_label=12;
% fs_legend=12;
% fontName='Arial';

titleName=t{1,4};
title(titleName,'interpreter','none','fontsize',fs_ti);
set(gca,'fontsize',fs_ax);
%xlabel('time [min]','fontweight','bold','fontsize', fs_label);
% ylabelname='(R1p(i)-R1p_b_a_s_e_l_i_n_e)/R1p_b_a_s_e_l_i_n_e *100 [%]';
%ylab={ 'ADC [mm^2/s]'  'CBF [ml/(min*100g)]'  'none'};
% ylab={ 'ADC [mm^2/s]'  'CBF [ml/(min\cdot100g)]'  'none'};


set(gca,'xtick',[],'xColor',[1 1 1]);
set(gca,'fontname',fontName);
set(gca,'linewidth',lw_ax);

xlabelname=t{6};
if ~isempty(xlabelname)
    hx=xlabel(xlabelname, 'fontsize', fs_label,...
        'fontweight','bold','fontname',fontName,'color',[0 0 0]);%, 'interpreter', 'none')
end
ylabelname=t{7};
if ~isempty(ylabelname)
    ylabel(ylabelname, 'fontsize', fs_label,...
        'fontweight','bold','fontname',fontName);%, 'interpreter', 'none')
end





%% ===============================================




% 
% drawnow
% ax = gca;
% ti = ax.TightInset;     % required margins for labels
% ax.Position = [ ...
%     ax.Position(1)+ti(1), ...
%     ax.Position(2)+ti(2), ...
%     ax.Position(3)-ti(1)-ti(3), ...
%     ax.Position(4)-ti(2)-ti(4)];
% 
% drawnow
% ax = gca;
% ax.LooseInset = ax.TightInset;




%% =================[savePlot]==============================
if exist('saveas') && ~isempty(saveas)  && v.save==1  %savePlot==1
    f35=saveas;
    %print(hf,f35,'-r600','-dpng');
    print(hf,f35, ['-r' num2str(v.res)],'-dpng');
   
    
    if 1%---transparent Background
        [q qmap]=imread(f35);
        imwrite(q,f35,'png','transparency',[1 1 1]);
    end
    if v.verbose ==1;     showinfo2(['   png'],f35); end
end

% ==============================================
%%   legend
% ===============================================

if v.legend==1
    
    %% ===legend============================================
    if  length(t)>=8
        l=t{5};
        [hl,icons,plots,legend_text] =legend(hp,l,'box','off',...
            'fontsize',fs_legend,'fontname',fontName, 'location','bestoutside');
        %set(hl,'position',[ .6 .14 .3 .2]);
        % Find lines that use a marker
        set(findobj(icons,'type','patch'),'FaceAlpha',.5);
        for i=1:length(hhp)
            hx=hhp{i};
            delete(hx.hp);delete(hx.hh);delete(hx.hs)
        end
        axis off;
        title('');
        %     set(hl,'position', [0.05 0.65 0.3337 0.2926]);
        set(findobj(icons,'type','text'),'fontname',fontName,...
            'fontsize',fs_legend,'FontWeight','bold');
        
        lpos=get(hl,'position');
        lpos2=lpos;
        lpos2(1:2)=[0.05 0.65];
        set(hl,'position',lpos2);
        
    end
    
    %% =================[savePlot]==============================
    if exist('saveas') && ~isempty(saveas) && v.save==1  %savePlot==1
        f35=stradd(saveas,v.legendsuffix ,2);
        %%print(hf,f35,'-r600','-dpng');
        print(hf,f35, ['-r' num2str(v.res)],'-dpng');
        
        if 1%---transparent Background
            [q qmap]=imread(f35);
            imwrite(q,f35,'png','transparency',[1 1 1]);
        end
%         showinfo2(['png'],f35);
    end
    %% ===============================================
end

return
%
% % end %param
%
%
% % ==============================================
% %%   make powerpoint
% % ===============================================
% if makePPT ==1;  %[0/1]
%
%     pptfile=fullfile(savePath,'barplot.pptx');
%     pd= savePath;   %fullfile(pabase,[ 'fig_' num2str(nfig)],['panel' num2str(panel) '_ballNsticks'     ] );
%     titles=[pd  ];
%
%     % [fisXLS] = spm_select('List',pd,'^.*.xlsx'); fisXLS=cellstr(fisXLS);
%
%     % ======[1st slice]=========================================
%     %  [fis1] = spm_select('FPList',pd,'^v014.*.tif'); fis1=cellstr(fis1);
%     %  [fis2] = spm_select('FPList',pd,'^v005.*.tif'); fis2=cellstr(fis2);
%     %  [fis3] = spm_select('FPList',pd,'colorbar.tif');fis3=cellstr(fis3);
%     %  fis=[fis1;fis2;fis3];
%     [fis1] = spm_select('FPList',pd,'^bar_.*.png');    fis1=cellstr(fis1);
%     [fis2] ={};% spm_select('FPList',pd,'colorbar.tif');fis2=cellstr(fis2);
%     fis=[fis1;fis2];
%     [~,fname,fext]=fileparts2(fis);
%
%     l={};
%     l(end+1,1)={['path: '  pd ]};
%     % for i=1:length(fname)
%     %     l(end+1,1)={['file: '  fname{i}       ]};
%     % end
%     l(end+1,1)={['images (top-to-down ): '      ]};
%     l=[l; cellfun(@(a,b){[ '     '    a b ]}, fname,fext)];
%
%
%     % infofile=fullfile(pd,'node_list.txt');
%     % for i=1:length(fis)
%     %     if i==1; doctype='new'; else doctype='new';
%     img2ppt(pd,fis, pptfile,'size','A4','doc','new',...
%         'crop',0,'gap',[0 0 ],'columns',2,'xy',[.5 1.5 ],'wh',[ wh(1) nan],...
%         'title',titles,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
%         'text',l,'tfs',6,'txy',[5 20],'tbgcol',[1 1 1]);
%
% end
% %% ===============================================
%
%
%
%
%
%
%
%
%
%
