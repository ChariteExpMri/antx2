

%% define mousebutton [left/right, double-left/right,& SHIFT-CONTROL-ALT  ]
%% button:
%     1:left
%     2:right
%     3:double click left
%     4:double click right
%% sca: 
%    3-element vector refers to combinations of SHIFT-CONTROL-ALT  
%% button & sca can be combined

%EXAMPLE: 
% [b sca] = mousebutton;
% if b==0; return; end          %necessary to allow double-click

function [button sca]=mousebutton


persistent chkx
persistent chkxtype
persistent chkbutton
persistent chkdouble
button = 0;
sca    = [];

val=0;
if isempty(chkx)
    chkxtype=get(gcf,'SelectionType');
    chkdouble=1;
    chkx = 1;
    pause(0.3); %Add a delay to distinguish single click from a double click
    if chkx == 1
        %% SINGLE-CLICK
        val=0;
        chkx = [];
        chkdouble=0;
%         disp('single-click');
        [button sca]=getbutton(0,chkxtype);
       % disp(button);
    end
else
    %% DOUBLE-CLICK
    chkx = [];
    %
%     disp('double-click');
    [buttonx scax]=getbutton(2,chkxtype);
    val=1;
    chkbutton=[buttonx scax];
    button=0;
    sca=[0 0 0];
    chkdouble=chkdouble+1;
    
end

if ~isempty(chkbutton) && chkdouble==2
    button=chkbutton(1);
    sca    =chkbutton(2:end);
    chkdouble=0;
end

function [button sca]=getbutton(nclick,chkxtype)

%  chkxtype
% button='';
% pause(.2)
% return
% mouse_seltype=get(gcf,'SelectionType')
if strcmp(chkxtype,'normal')  %LEFT
    button=1+nclick;
elseif strcmp(chkxtype,'alt') %RIGHT
    button=2+nclick;
 elseif strcmp(chkxtype,'extend')
     if nclick==2; nclick=1 ; end
    button=5+nclick;   
else
%      button=10+nclick
     button = 0;
      sca    = [];

end


modifiers = get(gcf,'CurrentModifier');
s = ismember('shift',   modifiers);  % true/false
c  = ismember('control', modifiers);  % true/false
a   = ismember('alt',     modifiers);  % true/false
sca=[s c a];





