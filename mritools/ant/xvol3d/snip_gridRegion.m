


% hp=findobj(findobj(0,'tag','xvol3d'),'tag','region')
hp=findobj(findobj(0,'tag','xvol3d'),'userdata',672)
set(hp,'visible','off')
stp=10;
ro=get(hp,'vertices');
vc=1:stp:length(ro);
pl=plot3(ro(vc,1),ro(vc,2),ro(vc,3),'k.')
set(pl,'MarkerSize',.001,'tag','regiondot')

delete(pl)