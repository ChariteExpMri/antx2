
%% #b fastviewer (montage) of 3dim or 4dim data
% from file-picker-window select one(!) file and hit [1]-key  (not [f1]!!!) to display the volume
% when montage-plot is ready, you can:
%      -navigate across the 4th-dimension via <leftarror>&<rightarrow>keys 
%      -get instant value of the voxel under the hovering mouse
%      -depicts the mean/std/min/max/median of each 3d-volume (also for each 3d-vol within 4th.dimension-volume)
%      -depict the header information
% #r  NOTE #k : file-picker-window depend on the pre-selected mouse-folders in the ANT-GUI

 function xfastview(showgui,x,pa)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end





%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; [[fis files] ]   ];
    end
    [a1 b1 ]=unique(fi2(:,1));
    niparas={};
    for i=1:length(b1)
        he=spm_vol(fi2{b1(i),2});
        niparas(i,:)= {
            [num2str(length(he(1).dim) +(size(he,1)>1)) '-D']    % 3d vs 4d
            num2str(size(he,1))                                 %No volumes
            regexprep(num2str(he(1).dim),' +',' ')              %first 3dims
          he(1).descrip };                                      %descript
    end
    li=[a1 niparas];
    lih={'nifti'  '3d/4d'  '#Vol' 'dims_1-3' 'descript'};
end


% cc5=['us=get(gcf,''userdata'');'...
%     'lb1=findobj(gcf,''tag'',''lb1'');'...
% 'va=min(get(lb1,''value''));'...
% 'fname=us.raw{va,1};'...
% 'montage2(fname);'  ];



cm={ 'show VOLUME             [key-1]', {@showx,pa}
      'open path in explorer  [key-2]', {@explor,pa} };

id=selector2(li,lih,'iswait',0,'contextmenu',cm);
delete(findobj(gcf,'tag','pb1'));

function showx(h,e,pa)
if exist('pa')==0
     pa=antcb('getsubjects');
end
    
us=get(gcf,'userdata');
lb1=findobj(gcf,'tag','lb1');
va1=[];
try
    va1=find(us.sel==1)  ;%min(get(lb1,'value'));
end
va2=min(get(lb1,'value'));
va=unique([va1(:);va2(:)]);
fname=us.raw(va,2);

for j=1:size(fname,1)
    for i=1:size(pa,1)
       try
           montage2(fullfile( pa{i}  ,fname{j}));
       end
    end
end

function explor(h,e,pa)
if exist('pa')==0
    pa=antcb('getsubjects');
end
explorer(pa{1});





