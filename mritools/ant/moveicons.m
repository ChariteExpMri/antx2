



function moveicons

global mi
mi.dummy=1;
mi.co=[0 0];
mi.hb=[];

set(gcf,'WindowButtonDownFcn', @selectControl)
set(gcf,'WindowButtonMotionFcn', @moving_whichcontrol)

set(gcf,'WindowButtonupFcn', @deselectControl)

function deselectControl(e,e2)
global mi
pos=get(mi.hb,'position');
disp(['position:']);
disp(['        [' regexprep(num2str(pos),'\s+' ,' ') ']' ]);
clipboard('copy',[ '[' regexprep(num2str(pos),'\s+' ,' ')  ']' ] );
mi.hb=[];

function moving_whichcontrol(e,e2)
global mi

if isempty(mi.hb)
    ev=hittest(gcf);
    try
        set(ev,'enable','off');
    end
else
    hb=mi.hb;
    
    p1=get(hb,'position');
    co=get(gcf,'CurrentPoint');
    hpar=get(hb,'parent');
    ;
    if strcmp(get(hpar,'type'),'figure');
       upar0= get(hpar,'units');
       uhb0 = get(hb,'units');
       
       set(hb,'units',upar0);
       pos=get(hb,'position');
       pos2=[ co(1) co(2) pos(3:4)];
       set(hb,'position',pos2);
       
       set(hb,'units',uhb0);
       set(hpar,'units',upar0);
    else
        z=sign(mi.co(end-1,:)-co);
        mov=p1(3:4)/100;
        movs=mov.*z;
        
        p2=[p1(1)-movs(1)  p1(2)-movs(2) p1(3:4)] ;
        set(hb,'position', p2);
        
        
        
    end
    
end

mi.co(end+1,:)=get(gcf,'CurrentPoint');





function selectControl(e,e2)
ev=hittest(gcf);
global mi
hb=ev;
mi.hb=hb;












