


%  function snp( )


v.position=[0.001 0.001 1 1];
v.hfig    =[];
v.pb1string ='RUN'
v.uiwait   =0



% v.hfig=2
% v.position=[0.5 0.5 .2 .1];
 
% x=get(gcf)

%% test
% b =struct2list(x)
% global an



qw={...
   'hemisphere' 'both'                  'calculation on [left|right|both] hemisphere' 
   'resolution' [.4 .4 .1]              'voxelsize [1x3]mm'
   'tpm'        {'grey.nii' 'white.nii' 'csf.nii'}'     'used Tissue Prob.Map' 
   'configfile' 'O:\TOM\mritools\ant\templateBerlin_hres\_b3csf.nii'    'used configfile'
   'alpha'       .5                     'transparency [0< alpha >1]'
};
% qw={...
%    'hemisphere' 'both'               
%    'resolution' [.4 .4 .1] 
%    }
   
% qw=preadfile2('cell2line.m')


if size(qw,2)>1
x=cell2struct(qw(:,2),qw(:,1),1 );
qw2=struct2list(x);
end

if size(qw,2)>2
    idinfo=regexpi2(qw2(:,1),'^\w');
    info=repmat({''},size(qw2,1), 1);
    info(idinfo)= cellfun(@(a) {[ '% '  a]},qw(:,3));
    qw3=cellfun(@(a,b) {[a char(9)  b]}, qw2,info);
elseif size(qw,2)==2
    qw3=qw2;
else
    qw3=qw;
end

b=qw3;
b2=cell2line(b,1,'@999@');
b3=regexprep(b2,'@999@',char(10));
b3=[b3 ' ' char(09) ];


% b2=char(b)
% 
% b3='';
% for i=1:size(b2,1)
%     dum=b2(i,:);
%     dum=regexprep(dum,char(13),'');
%     b3=[b3 dum ];
% %     b2(i,:)
% end
% b3
%     


% %% test
pos=v.position;%[0.001 0.001 1 1];

% figure
if isempty(v.hfig)
    figure('visible','off','color','w','menubar','none','toolbar','none')
else
     figure(v.hfig)
end
set(gcf,'units','pixels')
figposp=get(gcf,'position')
sizepixel=figposp(3:4);

set(gcf,'units','norm')
pos0=get(gcf,'position')
set(gcf,'position',[0.01 pos0(2) 1  pos0(4)   ])
set(gcf,'units','pixels');


posfig   =get(gcf,'position');

pos2=[ pos(1:2).*sizepixel  pos(3:4).*sizepixel];

jCodePane = com.mathworks.widgets.SyntaxTextPane;
codeType = com.mathworks.widgets.text.mcode.MLanguage.M_MIME_TYPE;
jCodePane.setContentType(codeType)
% jCodePane.setContentType('text/html');
% str = ['% create a file for output\n' ...
%        '!touch testFile.txt\n' ...
%        'fid = fopen(''testFile.txt'', ''w'');\n' ...
%        'for i=1:10\n' ...
%        '    % Unterminated string:\n' ...
%        '    fprintf(fid,''%6.2f \\n, i);\n' ...
%        'end'];
% str = sprintf(strrep(str,'%','%%'));

jCodePane.setText(b3);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCodePane);
[jhPanel,hContainer] = javacomponent(jScrollPane,round(pos2),gcf); %[10,10,500,200]
% jhPanel.setFont(java.awt.Font('Comic Sans MS',java.awt.Font.PLAIN,28))
set(gcf,'position',figposp)
set(gcf,'visible','on')
set(hContainer,'units','norm');


us.jCodePane=jCodePane;
set(gcf,'userdata',us);

set(gcf,'units','normalized');
p=uicontrol('style','pushbutton',       'tag','pb1',    'string',v.pb1string,'units','normalized',...
    'position',[.01 0 .1 .04],'units','pixels');%[.01 .93 .1 .04]

if v.uiwait==1
    uiwait(gcf);
end












