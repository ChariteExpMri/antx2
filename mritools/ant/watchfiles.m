



%% #gy watch files - checks the status (existence) of specified files across mouse folders
%
% function might be useful to obtain information on the processing state, i.e. existence of
% nifti-files, across mouse folders 
%   ("..does the files xyz.nii exist and in which folders?")
%___________________________________________________________________________________________________    
% #b [SET FILES TO BE WATCHED]
% -for a file (nifti) that you want to watch/check, click into the 2nd column to choose a color, 
%     click [ok] in the color-gui
% - do the same for additional files, (use other colors)
% - hit [OK] in the nifti-selection gui
%
% 
% - the list of watching files will be written to the project-file (proj.m, if not renamed). This 
%   allows to keep the watch list after reloading the gui
%
% #b [REMOVED FILES FROM WATCHING LIST]
%  - to options:
% (1):  click into the 2nd column to choose a color and click [cancel] in the color-gui, than click [ok]
% (2):  open the project-file (proj.m, if not renamed) and remove/modify the "watchfiles"-list
%       structure: each line of the list contrains a file to watch + HEXcolor + HEXsymbol
%___________________________________________________________________________________________________    
% #ry caller function
% antcb('watchfile');
      

function watchfiles



global an;
clear(an.configfile);
run(an.configfile);



pa=antcb('getallsubjects');
v=getuniquefiles(pa);

tb=v.tb;
tbh=v.tbh;

tb  =tb(:,[1 end 2:end-1]);
tbh=tbh([1 end 2:end-1]);

tbh(2)={'SELECT color'};
tb(:,2)={'  '};
us.dx=[tb(:,1) repmat({''}, [size(tb,1) 1 ])];
if isfield(x,'watchfiles')
    for i=1:size(x.watchfiles,1)
        ifo=find(strcmp(tb(:,1),   x.watchfiles(i,1)  ));
        if ~isempty(ifo)
            colhex=x.watchfiles{i,2};
            %<font size="12">
            tb{ifo,2} =['<html><font color =' colhex '>&#9733 watched</html>'];
            us.dx{ifo,2}=colhex;
        end
    end
end




% make figure
f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.0867    0.4000    0.8428]);
tx=uicontrol('style','text','units','norm','position',[0 .95 1 .05 ],...
    'string',      '..WATCH FILES: select color of 1 or more files, hit [OK] , (see [help])',... % UPPER-TITLE
    'fontweight','bold','backgroundcolor','w');

[~,MLvers] = version;
MatlabVersdate=str2num(char(regexpi(MLvers,'\d\d\d\d','match')));
if MatlabVersdate<=2014
    
    t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table',...
       'ColumnName',tbh, 'RowName',[]);
else
    
    t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table');
    %  ,...
    %     'ColumnWidth','auto');
    t.ColumnName =tbh;
    colwid=num2cell((max(cell2mat(cellfun(@(a){[length(a)]},[tbh;tb])))+0)*8);
    colwid{2}=100;
    set(t,'ColumnWidth',colwid);
    set(t,'RowName',[]);%,'ColumnName',[]);
    
    
    %columnsize-auto
    % set(t,'units','pixels');
    % pixpos=get(t,'position')  ;
    % set(t,'ColumnWidth',{pixpos(3)/2});
    % set(t,'units','norm');
    
    % tbeditable=[0 1 1   zeros(1,length(v.tbh(2:end))) ]; %EDITABLE
    % tbeditable
    %
    % t.ColumnEditable =logical(tbeditable ) ;% [false true  ];
    t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
end



%
%
%
% dx =  [  repmat( {'<font color =#FF00FF>'} ,[size(d,1) 1]) d(:,[1])  d(:,[2:end]) ]
% dxh=[ {'col'} dh(:,[1])  dh(:,[2:end])]
% id=selector2(dx,dxh,'iswait',0);%,'contextmenu',cm);
%

us.t =t;
set(t,'CellSelectionCallback',@setcol);


h={' '};
h0={};
h0{end+1,1}=[' '];
h0{end+1,1}=[' ##m   *** [ ' upper(mfilename)  '] ***'   ];
h0{end+1,1}=[' _______________________________________________'];
hlp=help(mfilename);
h=[h0; strsplit2(hlp,char(10))' ; h ];

setappdata(gcf,'phelp',h);
pb=uicontrol('style','pushbutton','units','norm','position',[.45 0.02 .15 .03 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);


p1=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .03 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'tag','okbutton',    'callback',   @ok         );%@renameFile
pb=uicontrol('style','pushbutton','units','norm','position',[.8 0.02 .15 .03 ],'string','CANCEL','fontweight','bold','backgroundcolor','w',...
    'callback',   @cancel           );

set(findobj(gcf,'tag','okbutton') ,'userdata',us);


function cancel(e,e2)
close(gcf);



function ok(e,e2)
global an;
clear(an.configfile);
run(an.configfile);

us=get(findobj(gcf,'tag','okbutton') ,'userdata');
ids=find(cellfun('isempty',(us.dx(:,2)))==0);

% if isempty(ids)
%    close(gcf);return; 
% end
watchnew=us.dx(ids,:);
watchnew(:,3)={'&#9733'};



drawnow
ac=preadfile([strrep(an.configfile,'.m','') '.m']); ac=ac.all;
if isfield(x,'watchfiles')
    watchold=x.watchfiles;
       
    chk1=[regexpi2(ac,'x.watchfiles') ];
    curl=cell2mat(regexpi(ac(chk1),'{'));
    curl2=[];
    for i=chk1:size(ac,1)
        curlid=[regexpi2(ac(i),'}') ];
        if ~isempty(curlid)
            curl2(end+1)=i;
        end
    end
    
    
  
    if isempty(watchnew)
        insert=[];
    else
        x=[];
        x.watchfiles=watchnew;
        insert= (struct2list(x));
    end
    %nf=[ac(1:chk1-1)   ;   insert; ac(curl2+1:end)  ];
    nf=[ cellstr(char( ac(1:chk1-1) )); cellstr(char( insert ));  ...
        cellstr(char(  ac(curl2+1:end) )) ];
    
else %NOT DEFINED IN CONFIGFILE
    if isempty(watchnew)
        insert=[];
    else
        x=[];
        x.watchfiles=watchnew;
        insert= [(struct2list(x))   ];
    end
    %nf=[ac  ;   insert; {''} ] ;
    nf=[cellstr(char(ac)) ;  cellstr(char(insert))  ];
end
pwrite2file([strrep(an.configfile,'.m','') '.m'],nf);
close(gcf);
antcb('update');


function setcol(e,e2,ha)
us=get(findobj(gcf,'tag','okbutton') ,'userdata');
w=get(e,'Data');

idx=e2.Indices;
try
    if idx(2)==2
        col=uisetcolor;
        
        if col==0
            w{idx(1),idx(2)}=[' '];
            us.dx(idx(1),2)={''};
        else
            c=col*255;
            h{1}=dec2hex(c(1)); if length(h{1})==1; h{2}=['0' h{1}]; end
            h{2}=dec2hex(c(2)); if length(h{2})==1; h{2}=['0' h{2}]; end
            h{3}=dec2hex(c(3)); if length(h{3})==1; h{3}=['0' h{3}]; end
            colhex=['#' [h{1} h{2} h{3}]];
            %<font size="8">
            %             colhex=['#' char(cellfun(@(a,b,c){[ dec2hex(a*255) dec2hex(b*255)  dec2hex(c*255)  ]},col(1),col(2),col(3)))];
            w{idx(1),idx(2)}=['<html><font color =' colhex '>&#9733 watched</html>'];
            us.dx{idx(1),2}=colhex;
        end
        set(e,'Data',w);
    end
end
set(findobj(gcf,'tag','okbutton') ,'userdata',us);






%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
    if isempty(files); continue; end
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
li=unique(fi2);
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    ha=spm_vol(fifull2{i});
    ha0=ha;
    ha=ha(1);
    if length(ha0)==1
        tb{i,1}='3';
        tag='';
    else
        tb{i,1}='4' ;
        tag= length(ha0);
    end
    tb{i,2}=sprintf('%i ',[ha.dim tag]);
    tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
    tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];