function varargout=showbrodmann(src,evt,varargin)


global Atlas;
fig1=findobj(0,'tag','Menu');
atlas=getappdata(fig1,'atlas');

if nargin<3
    fig2=findobj(0,'Tag','Interactive');
    axpar= get(findobj(0,'tag','hX2r'),'parent');
    xyz=spm_mip_ui('GetCoords',axpar);
    % disp(xyz);
    cox=xyz(:)';
else
    cox=varargin{1};
end


%============================================================
[labelx header labelcell]=pick_wrapper(cox, 'Noshow');
% char(labelx);
% cprintf([1 .5 1],'showbrodmann');
% showtable2([0 0 1 1],[header(2:end);labelx(2:end)]','fontsize',8);

if nargin<3
    
     xSPM=evalin('base','xSPM');
     xyz=round(xyz);
     distanx=sqrt(sum((xSPM.XYZmm'-repmat(xyz',[size(xSPM.XYZmm,2) 1])).^2,2));
    [mindistanx iminx]=min(distanx);
    if mindistanx<2
    value=['  ' num2str(xSPM.Z(iminx))];
    else
       value=['  ' ];
    end
    
    
    %     fig2=findobj(0,'Tag','Interactive');
    %     str=get(sort(findobj(fig2,'style','text')),'string');
    %     value= char(str(  find(strcmp(str,'statistic'))+1 ));
    tabx=[
        [header(2) '#[1 0.1608 0] Value'                               header(3:end)];
        [labelx(2) [  '#[1 0.1608 0]'      value   ]                  labelx(3:end)];
        ]';
    showtable2([0 0 1 1],tabx,'fontsize',8);
else
    showtable2([0 0 1 1],[header(2:end);labelx(2:end)]','fontsize',8);

end
 %============================================================
if nargin>=3
    varargout{1}= idlabel;%area(idlabel)';
   return
end
fig=findobj(0,	'Tag','Graphics');
% filecallback='fun2_activateResults';
for i=1:3
    c=findobj(fig,	'Tag',['hX' num2str(i) 'r' ]);
    str=get(c,'ButtonDownFcn');
    
    orig='spm_mip_ui(''MoveStart'')';
    set(c,'ButtonDownFcn',[ orig ';' 'fun2_activateResults']);
end



