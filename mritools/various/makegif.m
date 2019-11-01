

function makegif(fileoutname,ls,delay)

% ls={
%     fullfile(pwd,  'v1.jpg')
%     fullfile(pwd,  'v2.jpg')
%     }
% makegif('test.gif',ls,.3);

loops=65535;
% delay=.4

for i=1:size(ls,1)
    fi=ls{i};
    if strcmpi('gif',fi(end-2:end))
        [M  c_map]=imread([fi]);
    else
        a=imread([fi]);
        [M  c_map]= rgb2ind(a,256);
    end
    %         imwrite(M,c_map,[fout ],'gif','LoopCount',loops,'WriteMode','append','DelayTime',delay)


    if i==1
        imwrite(M,c_map,[fileoutname],'gif','LoopCount',loops,'DelayTime',delay);
    else
        imwrite(M,c_map,[fileoutname],'gif','WriteMode','append','DelayTime',delay);
    end
end




return

% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % 
% % 
% % 
% % 
% % clear all
% % [file_name file_path]=uigetfile({'*.jpeg;*.jpg;*.bmp;*.tif;*.tiff;*.png;*.gif','Image Files (JPEG, BMP, TIFF, PNG and GIF)'},'Select Images','multiselect','on');
% % file_name=sort(file_name);
% % [file_name2 file_path2]=uiputfile('*.gif','Save as animated GIF',file_path);
% % lps=questdlg('How many loops?','Loops','Forever','None','Other','Forever');
% % switch lps
% %     case 'Forever'
% %         loops=65535;
% %     case 'None'
% %         loops=1;
% %     case 'Other'
% %         loops=inputdlg('Enter number of loops? (must be an integer between 1-65535)        .','Loops');
% %         loops=str2num(loops{1});
% % end
% % 
% % delay=inputdlg('What is the delay time? (in seconds)        .','Delay');
% % delay=str2num(delay{1});
% % dly=questdlg('Different delay for the first image?','Delay','Yes','No','No');
% % if strcmp(dly,'Yes')
% %     delay1=inputdlg('What is the delay time for the first image? (in seconds)        .','Delay');
% %     delay1=str2num(delay1{1});
% % else
% %     delay1=delay;
% % end
% % dly=questdlg('Different delay for the last image?','Delay','Yes','No','No');
% % if strcmp(dly,'Yes')
% %     delay2=inputdlg('What is the delay time for the last image? (in seconds)        .','Delay');
% %     delay2=str2num(delay2{1});
% % else
% %     delay2=delay;
% % end
% % 
% % h = waitbar(0,['0% done'],'name','Progress') ;
% % for i=1:length(file_name)
% %     if strcmpi('gif',file_name{i}(end-2:end))
% %         [M  c_map]=imread([file_path,file_name{i}]);
% %     else
% %         a=imread([file_path,file_name{i}]);
% %         [M  c_map]= rgb2ind(a,256);
% %     end
% %     if i==1
% %         imwrite(M,c_map,[file_path2,file_name2],'gif','LoopCount',loops,'DelayTime',delay1)
% %     elseif i==length(file_name)
% %         imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay2)
% %     else
% %         imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay)
% %     end
% %     waitbar(i/length(file_name),h,[num2str(round(100*i/length(file_name))),'% done']) ;
% % end
% % close(h);
% % msgbox('Finished Successfully!')
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% ls={
%   fullfile(pwd,  'm1.png')
%   fullfile(pwd,  'm2.png')
%   fullfile(pwd,  'm1.png')
%   fullfile(pwd,  'm2.png')
%   }
% 
% clear im
% 
% for i=1:size(ls,1)
%     [a m]=imread(ls{i});
%     
%     [im2,map] = rgb2ind(a,256,'nodither');
% %     if i==2
%        map2=map 
% %     end
%     im(:,:,:,i)=im2 ;%rgb2ind(f.cdata,map,'nodither');
% end
% imwrite(im,map2,'test.gif','DelayTime',1,'LoopCount',inf) %g443800
% 
% 
% %% How to make an animated GIF
% % This example animates the vibration of a membrane, captures a series of
% % screen shots, and saves the animation as a GIF image file.
% %
% % Copyright 2008-2010 The MathWorks, Inc. 
% %%
% % <<../DancingPeaks.gif>>
% %%
% % The resulted animated GIF was embedded in this HTML page using the Image
% % cell markup (see 
% % <http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_env/f6-30186.html#breug1i help for markup formatting>). 
% %%
% % Here's the M code.
% Z = peaks; 
% surf(Z)
% axis tight
% set(gca,'nextplot','replacechildren','visible','off')
% f = getframe;
% [im,map] = rgb2ind(f.cdata,256,'nodither');
% im(1,1,1,20) = 0;
% for k = 1:20 
%   surf(cos(2*pi*k/20)*Z,Z)
%   f = getframe;
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
% end
% imwrite(im,map,'DancingPeaks.gif','DelayTime',0,'LoopCount',inf) %g443800
% %%
% % For more details about GIF settings |DelayTime| and |LoopCount| for desired
% % effect see the 
% % <http://www.mathworks.com/access/helpdesk/help/techdoc/ref/imwrite.html#f25-752355 help for |imwrite/gif|>. 
