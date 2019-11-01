
%% simple check overlay
function gifoverlay2(handles,outname,resol )




% 
% outname=fullfile(pwd, 'test.gif')
% handles=[1 2]
% resol='-r300'


[paout fi]=fileparts(outname);


warning off;
figure(handles(1));
print(handles(1), '-djpeg',['-r' num2str(resol)],fullfile(paout, 'vv1.jpg'));
figure(handles(2));
print(handles(2), '-djpeg',['-r' num2str(resol)],fullfile(paout, 'vv2.jpg'));

ls2={
    fullfile(paout,  'vv1.jpg');
    fullfile(paout,  'vv2.jpg');
    };

makegif([  strrep(outname,'.gif','') '.gif']  ,ls2,.2);

delete(fullfile(paout,  'vv1.jpg'));
delete(fullfile(paout,  'vv2.jpg'));




