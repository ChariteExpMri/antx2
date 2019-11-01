

function varargout=batab(varargin) %show BAtable

% use with SPM:  batab(1) from cmd-line
 busy;

if varargin{1}==1%whole brain
    xSPM=  evalin('base','xSPM');
    hReg=  evalin('base','hReg');
    TabDat = spm_list('List',xSPM,hReg);
    assignin('base','TabDat',TabDat);
elseif varargin{1}==2%curent cluster
    xSPM=  evalin('base','xSPM');
    hReg=  evalin('base','hReg');
    TabDat = spm_list('ListCluster',xSPM,hReg);
     assignin('base','TabDat',TabDat);
end


fig=findobj(0,'Tag','Graphics');
axtab=get(findobj(fig,'string','mm mm mm'),'parent');%table
hl=sort(findobj(axtab,'Tag','ListXYZ')) ;%mmText mm mm mm

% return
if isempty(axtab)
   disp('there is no table');
    return
end

cords=str2num(char([get(hl,'string')]));
[labelx header labelcell]=pick_wrapper(cords, 'Noshow');%
 showtable3([0 0 1 1],[header;labelx],'fontsize',8);
 
 zz.cords  =cords;
 zz.labelx=labelx;
 zz.header=header;
 zz.labelcell=labelcell;
 varargout{1}=zz;

% TabDat = spm_list('List',xSPM,hReg);
% TabDat = spm_list('ListCluster',xSPM,hReg);

 busy(1);