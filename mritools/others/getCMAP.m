
%% --------get CMAP-names ------------
% maps=getCMAP('names')
%  or 
% maps=getCMAP()
%% --------get CMAP-HTML-code ------------
% html=getCMAP('html')  ;%from all cmaps
% html=getCMAP('html','actc')  ;%from "actc"
% html=getCMAP('html',maps(1:3))  ;%first 3 maps
% html=getCMAP('html',{'actc','RdPu_flip','NIH_inv'})
%% -------get CMAP array(s)
% o=getCMAP(maps{2}); % get map of 2nd map
% o=getCMAP('actc'); %get map of 'actc'
% [o o2]=getCMAP({'actc' 'gray'}) ;%get arry of 'actc' 'gray'  ...output is of type cell
%% -------get CMAP numeric
% [table cmapname]=getCMAP(3)  %obtain table from 3rd mapname
% 

function [o o2]=getCMAP(arg1,arg2)



if 0
    % ==============================================
%%   
% ===============================================


z=[];                                                                                                                                                                         
z.backgroundImg = { 'x_t2.nii' };              % % [SELECT] Background/reference image (a single file)                                                                        
z.overlayImg    = { 'AVGT.nii' };              % % [SELECT] Image to overlay (multiple files possible)                                                                        
z.outputPath    = 'F:\data5\nogui\checks';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
z.outputstring  = '';                          % % optional Output string added (suffix) to the HTML-filename and image-directory                                             
z.slices        = 'n6';                        % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
z.dim           = [2];                         % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                 
z.size          = [400];                       % % Image size in HTML file (in pixels)                                                                                        
z.grid          = [1];                         % % Show line grid on top of image {0,1}                                                                                       
z.gridspace     = [20];                        % % Space between grid lines (in pixels)                                                                                       
z.gridcolor     = [1  0  0];                   % % Grid color                                                                                                                 
z.cmapB         = 'gray';                  % % <optional> specify BG-color; otherwise leave empty                                                                         
z.cmapF         = 'gold_inv';                % % <optional> specify FG-color; otherwise leave empty                                                                         
z.showFusedIMG  = [0];                         % % <optional> show the fused image                                                                                            
z.sliceadjust   = [0];                         % % intensity adjust slices separately; [0]no; [1]yes                                                                          
xcheckreghtml(0,z);   
end
if 0
    
   
    p={
        'color'          1     'BG-color head' {'cmap' 'list'}
        'c1'            1     'BG-color head' {'cmap' }
        'c2'            1     'BG-color head' {'cmap' [] 1 4 '' }
        'maps'          1     'BG-color head' {'cmap' cmapHTML}
        'maps2'          1     'BG-color head' {'cmap' {}}
        }; 
end
% ==============================================
%%   
% ===============================================








[o o2]=deal([]);
if exist('arg1')~=1  && exist('arg2')~=1
     o=names();
     o2=makeHTMLColorList(o);
     return
end

if strcmp(arg1,'names')
    o=names();
    return;
elseif strcmp(arg1,'html')
    if exist('arg2')==1 
       o=cellstr(arg2);  
    else
       o=names();
    end
     o=makeHTMLColorList(o);
    return;
elseif strcmp(arg1,'example')
    
    cmaps=names();
    cmapHTML=makeHTMLColorList(cmaps);
     
    p={
        'color'          1     'BG-color head' {'cmap' 'list'}
        'c1'            1     'BG-color head' {'cmap' }
        'c2'            1     'BG-color head' {'cmap' [] 1 4 '' }
        'maps'          1     'BG-color head' {'cmap' cmapHTML}
        'maps2'          1     'BG-color head' {'cmap' {}}
        };
m=paramgui(p,'uiwait',0,'editorpos',[.03 0 1 1],'figpos',[.5 .3 .3 .5 ],'info',{@doc,'paramgui.m'}); %%START GUI


 [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .6 ],...
        'title',['***COREGISTRATION***' '[' mfilename '.m]'],'info',{@uhelp, 'xcoreg.m'});

else
    if isnumeric(arg1)
        names=getCMAP('names');
        colname=names{arg1};
        o=getcolor(colname);
        o2=colname;
    else
        
        arg1=cellstr(arg1);
        for i=1:length(arg1)
            if length(arg1)==1
                o =getcolor(arg1{i});
                o2=arg1{i};
            else
                o{i,1} =getcolor(arg1{i});
                o2{i,1}=arg1{i};
            end
        end
    end
    
     
end


% ==============================================
%%   
% ===============================================

return
% list=getCmaplist();
% % list2=lutmap('show')
% % list=[list1;list2];
% [list1]=getCmaplist();
% [list2]=lutmap('show');
% maps=[list1;list2]
% 
% list=makeHTMLColorList(maps)
% 
% % ==============================================
% %%   
% % ===============================================
% p={
%     'color'          1     'BG-color head' {'cmap' 'list'}
%     'c1'            1     'BG-color head' {'cmap' }
%     'c2'            1     'BG-color head' {'cmap' [] 1 4 '' }
%     'maps'          1     'BG-color head' {'cmap' list}
%     'maps2'          1     'BG-color head' {'cmap' {}}
%      'maps22'          1     'BG-color head' {'cmap' []}
%     };
% m=paramgui(p,'uiwait',0,'editorpos',[.03 0 1 1],'figpos',[.5 .3 .3 .5 ],'info',{@doc,'paramgui.m'}); %%START GUI




function maps=names
list=getCmaplist();
% list2=lutmap('show')
% list=[list1;list2];
[list1]=getCmaplist();
[list2]=lutmap('show');
maps=[list1;list2];





function cmaplist=getCmaplist()
cmaplist={...
   'gray' 'parula','jet' 'hot' 'cool' 'summer' 'autumn' 'winter' 'gray' 'copper' 'pink' ...
    'parulaFLIP','jetFLIP' 'hotFLIP' 'coolFLIP' 'summerFLIP' 'autumnFLIP' 'winterFLIP' 'grayFLIP' 'copperFLIP' 'pinkFLIP' ...
    '@yellow'  '@orange' '@red' '@green' '@blue' 'SPMhot' };%'user'

cnames{1,:}={'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn', 'Spectral'};
cnames{2,:}={'Blues','BuGn','BuPu','GnBu','Greens','Greys','Oranges','OrRd','PuBu','PuBuGn','PuRd',...
    'Purples','RdPu', 'Reds', 'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd'};
% cnames{3,:}={'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2', 'Set1', 'Set2', 'Set3'};
cnames{3}=cellfun(@(a){[a '_flip']} ,cnames{1,:});
cnames{4}=cellfun(@(a){[a '_flip']} ,cnames{2,:});

% othermaps=cmaps_other();
cnames2=[cnames{1} cnames{2} cnames{3} cnames{4}];
cmaplist=[cmaplist  cnames2 ];

cmaplist=cmaplist(:);

function cmap2=getcolor(cmap)
cmaplist=getCmaplist();
if isnumeric(cmap)
    cmap2=cmap;
    return
end


% othermaps=cmaps_other();

if strfind(cmap,'user')==1
    cc=uisetcolor();
    cmap2=repmat(cc,[64 1]);
elseif strfind(cmap,'@')==1
    tw={...
        '@red'  [1 0 0]
        '@yellow' [  1     1     0]
        '@blue' [ 0 0 1]
        '@green' [ 0.4667    0.6745    0.1882]
        '@orange' [1.0000    0.8431         0]
        };
    
    cmap2=repmat(cell2mat(tw(find(strcmp(tw(:,1),cmap)),2)),[64 1]);
    
elseif strfind(cmap,'FLIP')
    cmap2=eval(strrep(cmap,'FLIP',''));
    cmap2=flipud(cmap2);
    
%  elseif ~isempty(find(strcmp(othermaps(:,1),cmap)))           ;%OTHER MAPS (MRICRON ETC)
%     inum=find(strcmp(othermaps(:,1),cmap));
%     cmap2= othermaps{inum,2};
elseif strfind(cmap,'SPMhot')
    cmap2=getmymap('SPMhot');

elseif ~isempty(find(strcmp(cmaplist,cmap)))
    %iv=find(strcmp(cmaplist,cmap))
    %      F=cbrewer(ctypes{itype}, cnames{itype}{iname}, ncol);
    if isempty(strfind(cmap,'_flip'))
        [~,F]=evalc(['cbrewer(''div'',''' cmap ''', 64);']);
        if isempty(F)
            [~,F]=evalc(['cbrewer(''seq'',''' cmap ''', 64);']);
        end
        cmap2=F;
        if isempty(F)
            cmap2=eval(cmap);
        end
    else
        cmap=strrep(cmap,'_flip','');
        [~,F]=evalc(['cbrewer(''div'',''' cmap ''', 64);']);
        if isempty(F)
            [~,F]=evalc(['cbrewer(''seq'',''' cmap ''', 64);']);
        end
        cmap2=F;
        if isempty(F)
            cmap2=eval(cmap);
        end
       cmap2= flipud(cmap2);
    end
    
else
    try
        cmap2=eval(cmap);
    catch
        cmap2=lutmap(cmap);
    end
    
end





function list=makeHTMLColorList(maps)
maps(strcmp(maps,'user'))=[];
% maps={'jet' ,'hot' 'summer' 'gray' 'parula' 'cool' 'winter'}
list=repmat({''},[length(maps) 1]);
Nspaces=2;%size(char(maps),1)+3;
Ncol=9;
for j=1:length(maps)
    cmapname=maps{j};
    if strcmp(cmapname,'SPMhot')
        map=getmymap('SPMhot');
    else
        
        try
            map=sub_intensimg('getcolor',cmapname);
        catch
            map=lutmap(cmapname);
        end
        
    end
    %eval(['map=' cmapname ';']);
    ilin=round(linspace(1,size(map,1),Ncol));
    map=map(ilin,:);
    map(map>1)=1;
    map(map<0)=0;
    map=round(map*255);
    maphex=repmat({''},[size(map,1) 1]);
    for i=1:size(map,1)
        maphex{i,1}=reshape(dec2hex(map(i,:), 2)',1, 6);
    end
    
    v1=cellfun(@(a){[ '<span style="font-size: 30%;color:' '#' a ';font-weight:bold">&#9632;</span>']} ,maphex);
    %     ts=['<span style="font-size: 100%;color:black;font-weight:bold">' cmapname '</span>'];
    v1=cellfun(@(a){['<FONT color=#' a ' >&#9632;' ]} ,maphex);
    ts=[ '<FONT color=black>'  repmat('&nbsp;', [1 1]) cmapname '[' num2str(j) ']'];
    % ts=[ '<FONT color=black>'  repmat('&nbsp;', [1 Nspaces-length(cmapname)]) cmapname];
    v2=['<html> '   strjoin(v1,'') ts];
    list{j,1}=v2;
end



function map=getmymap(cm)

if strcmp(cm,'SPMhot')
  map=[  ...
    0.0417         0         0
    0.0833         0         0
    0.1250         0         0
    0.1667         0         0
    0.2083         0         0
    0.2500         0         0
    0.2917         0         0
    0.3333         0         0
    0.3750         0         0
    0.4167         0         0
    0.4583         0         0
    0.5000         0         0
    0.5417         0         0
    0.5833         0         0
    0.6250         0         0
    0.6667         0         0
    0.7083         0         0
    0.7500         0         0
    0.7917         0         0
    0.8333         0         0
    0.8750         0         0
    0.9167         0         0
    0.9583         0         0
    1.0000         0         0
    1.0000    0.0417         0
    1.0000    0.0833         0
    1.0000    0.1250         0
    1.0000    0.1667         0
    1.0000    0.2083         0
    1.0000    0.2500         0
    1.0000    0.2917         0
    1.0000    0.3333         0
    1.0000    0.3750         0
    1.0000    0.4167         0
    1.0000    0.4583         0
    1.0000    0.5000         0
    1.0000    0.5417         0
    1.0000    0.5833         0
    1.0000    0.6250         0
    1.0000    0.6667         0
    1.0000    0.7083         0
    1.0000    0.7500         0
    1.0000    0.7917         0
    1.0000    0.8333         0
    1.0000    0.8750         0
    1.0000    0.9167         0
    1.0000    0.9583         0
    1.0000    1.0000         0
    1.0000    1.0000    0.0625
    1.0000    1.0000    0.1250
    1.0000    1.0000    0.1875
    1.0000    1.0000    0.2500
    1.0000    1.0000    0.3125
    1.0000    1.0000    0.3750
    1.0000    1.0000    0.4375
    1.0000    1.0000    0.5000
    1.0000    1.0000    0.5625
    1.0000    1.0000    0.6250
    1.0000    1.0000    0.6875
    1.0000    1.0000    0.7500
    1.0000    1.0000    0.8125
    1.0000    1.0000    0.8750
    1.0000    1.0000    0.9375
    1.0000    1.0000    1.0000];

    map(1:12,:)=[];
end
