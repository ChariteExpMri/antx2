
function [labelx header s]=pick_wrapper(XYZmni, show,varargin)

% example: add 1st column 'title: cluster'
% [labelx header labelcell]=pick_wrapper(XYZmm', 'show',{'cluster',num2cell(num2str(A))});
% example2
% [labelx header labelcell]=pick_wrapper(XYZmm', 'show',{ {'cluster' 'maxAC' 'Zval'},tmp3} );
% example3 add one colum 'STATISTIC' with name 'STAT' and datavector 'val'
%   [labelx header labelcell]=pick_wrapper(p', 'Noshow');
%   showtable3([0 0 1 1],[ ['STAT' header ];[ num2str(val) labelx ]]','fontsize',8);


if isempty(XYZmni)
   state='empty';
   XYZmni=[nan nan nan]
end
    
co=XYZmni;
for i=1:size(co,1)
    tx=pickatlas(co(i,:))';
    if i==1
        labelx=repmat({''}, [ size(co,1) 2+size(tx,2) ]);
    end
    dp= [{sprintf('%3.0f',i)}  {sprintf('%4.0f%4.0f%4.0f',co(i,:))}   tx(2,:) ];
    labelx(i,:)=dp;
end

% if exist('tx')==0
%     return
% end
    
header=['  N' 'xyzMNI'  tx(1,:)];
if nargin>2
    addheader= varargin{1}(1) 
    header=[addheader{:} header ];
    addcol=varargin{1}(2);
    labelx=[addcol{:} labelx];
end

[s hist]=plog({},{[] header labelx  }, 1,'LABELING','s=0','d=0');
if strcmp(show,'show');
    uhelp(s);
end
