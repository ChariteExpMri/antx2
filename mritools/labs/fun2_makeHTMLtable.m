function fun2_makeHTMLtable(varargin)
% function fun2_makeHTMLtable(varargin)
% save table as HTMLfile (SPM or user defined)
% fun2_makeHTMLtable('name','muell3')--> 

name=[];
 

if nargin~=0
    for i=1:2:nargin
      eval([varargin{i} '= varargin{' num2str(i+1) '};']) ; %name name to write file  
    end
end
    

fig=gcf;
% fig=findobj(0,'tag','tabelz2');
% lb=findobj(fig,'style','listbox')
us=get(fig,'userdata');
tx0=us.tablec;
tx0=[repmat({' '},[1 size(tx0,2)]) ;tx0];

try %SPM interface
    xSPM=evalin('base','xSPM');
    hReg=evalin('base','hReg');
    v=spm_list('List',xSPM,hReg);
    if size(v.dat,1)+2   ~=size(tx0,1)
        v=spm_list('ListCluster',xSPM,hReg);
    end
    if size(v.dat,1)+2   ~=size(tx0,1)
        return
    end
    info2=[v.ftr(:,1);v.ftr(:,2)];

    rdat =plog({},v.dat(:,1:end-1), -1,'condition','cr=0','s=0','d=0');
    rhdr=v.hdr(:,1:end-1);
    st=[rhdr;rdat];

    headerlineadd=0;
    if size(tx0,1)~=size(st,1)
        %     headerlineadd=1;
        %     tx0=[repmat({' '},[1 size(tx0,2)]) ;tx0];
        st(3,:)=[];
    end



    % tx=[tx0(:,1:2)  st tx0(:,3:end)]
    tx=[st tx0(:,1:2)   tx0(:,3:end)];
    nheadline=2+headerlineadd;
    isspm=1;

    ilincolspecial=find(cellfun('isempty',regexpi(tx(2,:),'xyzMNI'))==0);
catch %save what is there
    tx=us.tablec;
    ilincolspecial=find(cellfun('isempty',regexpi(tx(1,:),'xyzMNI'))==0);
    nheadline=1;
    isspm=0;
end

lg={'<html>'};
% lg{end+1,1}='<font size="1">';
lg{end+1,1}='<table border="0" cellspacing="1">';
for i=1:size(tx,1);
    dx='';
    for j=1:size(tx,2);
        if i<=nheadline
            fs='3';
        else
            fs='2';
        end

        if j==ilincolspecial
            fs='3';
        end

        tx2= ['<font size="' fs '">'  tx{i,j} '</font>'];
        %      tx2=['<th nowrap="nowrap">' tx2 '</th>']
        %         dx=[dx '<td>' ];
        %        dx=[dx '<td nowrap="nowrap" bgcolor="#FFFFFF">']  ;
        dx=[dx '<td nowrap="nowrap" bgcolor="#FFFFFF">']  ;
        if j==ilincolspecial
            %dx=[ '<color="#FF00FF">'  dx '</font>' ]  ; %FF0000
            dx=[dx '<td nowrap="nowrap" bgcolor="#FF9999">']  ;
        end
        if rem(j,2)==0 & j~=ilincolspecial
            dx=[dx '<td nowrap="nowrap" bgcolor="#FFFFCC" bgcolor="#0000FF">']  ;
        end
        if i<=nheadline
            dx=[dx '<b>' tx2  '</b>' '</td>']    ;
        else
            dx=[dx   tx2   '</td>']   ;
        end
    end
    lg{end+1,1}=[   '<tr>' dx '</tr>'  ] ;
end
lg{end+1,1}='</table>';
lg{end+1,1}='</font>';

if isspm==1 %ADD spm-stuff from figure
    lg{end+1,1}='<table border="0" cellspacing="1">';
    for i=1:size(info2,1);
        dx='';
        for j=1:size(info2,2);
            fs='2';
            tx2= ['<font size="' fs '">'  info2{i,j} '</font>'];
            dx=[dx '<td nowrap="nowrap" bgcolor="#FFFFFF">']  ;
            dx=[dx   tx2   '</td>']   ;
        end
        lg{end+1,1}=[   '<tr>' dx '</tr>'  ] ;
    end
    lg{end+1,1}='</table>';
    lg{end+1,1}='</font>';
end

if isempty(name)
    [fi pa]=uiputfile('' ,'save as html table','*.html');
    if fi~=0
        pwrite2file(fullfile(pa,[regexprep(fi,'.html','') '.html'] ),lg);
    end
else
  pwrite2file(  [regexprep(name,'.html','') '.html']  ,lg);
end

% !meull5.html






