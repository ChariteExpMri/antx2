

function fun2_activateResults
 
% 'fun2_activateResults: function used during shift MIPcursor'
drawnow;
pause(.1);
fig3=findobj(0,'Tag','Graphics');
ax=findobj(fig3,'Tag','hMIPax');
xyz=spm_mip_ui('GetCoords',ax);
[labelx header labelcell]=pick_wrapper(xyz(:)', 'Noshow');%
% cprintf([1 0 1],'fun2_activateResults');
% showtable2([0 0 1 1],[header(2:end);labelx(2:end)]','fontsize',8);

%  xSPM=evalin('base','xSPM');
 
 fig2=findobj(0,'Tag','Interactive');
 str=get(sort(findobj(fig2,'style','text')),'string');
value= char(str(  find(strcmp(str,'statistic'))+1 ));
tabx=[
[header(2) '#[1 0.1608 0] Value'                               header(3:end)];
[labelx(2) [  '#[1 0.1608 0]'      value   ]                  labelx(3:end)];
]';
showtable2([0 0 1 1],tabx,'fontsize',8);
