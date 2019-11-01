function f2=brViewer( dataset, varargin)
% f2=brViewer( dataset, ['figuretitle', 'yourfigurename'], ['imscale', imscale], ['res_factor', res_factor])
% dataset           : in kSpace with sizes: 
%                     (dim1, dim2, dim3, NumberOfObjects, NumberOfRepetitions, NumberOfChannels)
%                      OR
%                     as image with sizes: 
%                     (dim1, dim2, dim3, NumberOfVisuFrames)  
% imscale           : scale image using imagesc(), e.g. imscale=double(threshold_min, threshold_max)
%
% res_factor        : scalar, multiplication-factor on the imageresolution for saving as tiff 
%                     e.g. res_factor=2 and image (256x128) -> saved tiff has (512x256) pixel. Advantage: rendering with opengl
%                     default value is set to 2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: brViewer.m,v 1.2.4.1 2014/05/23 08:43:51 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generating invisible mainfigure - required for return value f2
fig_pos=[0 0 1130 700];
f2=figure('Visible','off','Units','pixels','Position',fig_pos,...
    'WindowButtonDownFcn',{@f_WindowButtonMotionFcn});


%% Define variables for nested-function-namespace:

abs_axes=[]; axes_size=[]; line_axes=[];
n1=[]; n2=[]; n3=[]; n4=[]; n5=[]; n6=[]; n7=[]; n8=[];
axes_show=[]; actDim1=[]; actDim2=[]; actDim3=[]; actDim4=[]; actDim5=[]; actDim6=[]; actDim7=[]; actDim8=[];
cmap=[]; freq=[]; mysize=[]; tiffnumber=[]; tiffname=[]; tiffnumber_text=[]; path_text=[];
axes_handle=[]; pt=[]; ds=[];
threshold_min=[]; threshold_max=[];
save_with_colorbar=[];

%=[]; Gui-Handel
pos_group_updownfields=[]; pos_updownfields=[]; updownfields=[];
cmap_pos=[]; group_cmap=[]; cmap_colorgray=[]; cmap_gray=[]; cmap_jet=[];
complex_pos=[]; group_complex=[]; complex_abs=[]; complex_phase=[]; complex_real=[]; complex_imag=[];
scaling_pos=[]; group_size=[]; size_image=[]; size_normal=[];
group_xscale=[]; xscale_pos=[]; x_dim1=[]; x_dim2=[]; x_dim3=[]; x_dim4=[]; x_dim5=[]; x_dim6=[]; x_dim7=[]; x_dim8=[]; x_dim=[];
group_yscale=[]; yscale_pos=[]; y_dim1=[]; y_dim2=[]; y_dim3=[]; y_dim4=[]; y_dim5=[]; y_dim6=[]; y_dim7=[]; y_dim8=[]; y_none=[]; y_dim=[];
threshold_min_heading=[]; threshold_min_text=[]; threshold_max_heading=[]; threshold_max_text=[]; threshold_pos=[];
line_pos=[]; group_line=[]; linex_axes=[]; liney_axes=[]; line_value=[]; line_text=[];
path_pos=[]; path_button=[]; tiffnumber_heading=[]; tiff_button=[]; tiff_colorbar_pos=[]; group_tiff_colorbar=[]; tiff_colorbar_on=[]; tiff_colorbar_off=[];


%% Read arguments
[varargin, figuretitle ] = bruker_addParamValue( varargin, 'figuretitle', '@(x) ischar(x)', 'DataViewer');
[varargin, imscale ] = bruker_addParamValue( varargin, 'imscale', '@(x) 1', []);
[varargin, res_factor ] = bruker_addParamValue( varargin, 'res_factor', '@(x) isscalar', 2);
imagescale=imscale;
clear varargin;

if ~exist('dataset', 'var') || ~isnumeric(dataset)
    error('dataset has to be exist and to be numeric.');
end

gui_setup;
% End main-function
% end is at the end of the file because of nested functions
%-----------------------------------------------------------------------------------------------------------------------------------------------------

%% Gui setup
function gui_setup(source, eventdata)
%% Setup
figure(f2);
set(f2, 'Visible', 'on', 'ResizeFcn',@figResize)


% reduce number of dimensions to 5 if necessary
dims=size(dataset);
if length(dims)>8
    dataset=reshape(dataset,[size(dataset,1), size(dataset,2), size(dataset,3), size(dataset,4), prod(dims(5:end))]);
end


% Generating axes (=image-field)
axes_size=[200,170,500,500];
abs_axes=axes('Units','pixels','Position',axes_size);
line_axes=[axes_size(1)+axes_size(3)+60,fig_pos(4)-10-500,350,500];

% Generate controls:
gen_controls; % Function-call 


%% Initialize data

[n1,n2,n3,n4,n5,n6,n7,n8] = size(dataset);

% Initialize objects

axes_show=[1 2]; % choose the dimensions shown at startup: axes_show(1)=Dimension auf x-Achse, axes_show(2)=Dimension auf y-Achse, 

dims=ones(8,1); % exclude 1st and 2nd dim     
for i=1:8
    if size(dataset,i) >1
        set(updownfields.text{i},'Visible', 'on');
        set(updownfields.heading{i},'Visible', 'on');
        set(updownfields.up{i}, 'Visible', 'on');
        set(updownfields.down{i}, 'Visible', 'on');
        set(x_dim{i}, 'visible', 'on');
        set(y_dim{i}, 'visible', 'on');
        dims(i)=ceil(size(dataset,i)/2);
    end     
end        
actDim1=size(dataset,1);
actDim2=size(dataset,2);
actDim3=dims(3);
actDim4=dims(4);
actDim5=dims(5);
actDim6=dims(6);
actDim7=dims(7);
actDim8=dims(8);

set(updownfields.text{1},'String',int2str(actDim1));
set(updownfields.text{2},'String',int2str(actDim2));
set(updownfields.text{3},'String',int2str(actDim3));
set(updownfields.text{4},'String',int2str(actDim4));
set(updownfields.text{5},'String',int2str(actDim5));
set(updownfields.text{6},'String',int2str(actDim6));
set(updownfields.text{7},'String',int2str(actDim7));
set(updownfields.text{8},'String',int2str(actDim8));
set(updownfields.heading{1},'String','Dim-1');
set(updownfields.heading{2},'String','Dim-2');
set(updownfields.heading{3},'String','Dim-3');
set(updownfields.heading{4},'String','Dim-4');
set(updownfields.heading{5},'String','Dim-5');
set(updownfields.heading{6},'String','Dim-6');
set(updownfields.heading{7},'String','Dim-7');
set(updownfields.heading{8},'String','Dim-8');

% disable used dimensions
if axes_show(1)~=0 % normal:
    for i=axes_show
        set(updownfields.text{i},'Visible', 'off');
        set(updownfields.up{i}, 'Visible', 'off');
        set(updownfields.down{i}, 'Visible', 'off');
    end
else % none:
    set(updownfields.text{axes_show(2)},'Visible', 'off');
    set(updownfields.up{axes_show(2)}, 'Visible', 'off');
    set(updownfields.down{axes_show(2)}, 'Visible', 'off');
end

cmap='bruker_ColorGray';
freq='abs';
mysize='image';

tiffnumber=1;
tiffname=['.', filesep, 'Image'];
set(tiffnumber_text,'String',int2str(tiffnumber));
set(path_text, 'String',['next save: ', tiffname, num2str(tiffnumber), '.tiff']);
%save_with_colorbar=false;

set(f2,'Position', fig_pos);

% Global appearance settings
movegui(f2,'center');
set(f2,'Name',figuretitle);
set(f2,'Visible','on');

ds=dataset(1:actDim1,1:actDim2,actDim3, actDim4, actDim5, actDim6, actDim7, actDim8);

% for line plot
axes_handle=abs_axes;
pt=[ceil(n2/2) ceil(n1/2)];

Draw_Image(false);
Draw_Line(false);

end

%% Generating controls for frame selection
function gen_controls
    
    % Generate 5 invisible up-down-text-fields:
    pos_group_updownfields=[10 20; 105 20; 200 20; 295 20; 390 20; 485 20; 580 20; 675 20];
    for i=1:8
        pos_updownfields.heading{i}=[pos_group_updownfields(i,1) pos_group_updownfields(i,2)+40 60 15];
        pos_updownfields.text{i}=[pos_group_updownfields(i,1) pos_group_updownfields(i,2) 60 30];
        pos_updownfields.up{i}=[pos_group_updownfields(i,1)+65 pos_group_updownfields(i,2)+15 15 15];   
        pos_updownfields.down{i}=[pos_group_updownfields(i,1)+65 pos_group_updownfields(i,2) 15 15];
        
        updownfields.heading{i}=uicontrol('Style','text',...
                         'Position',pos_updownfields.heading{i},'Visible','off');                     
        updownfields.text{i} = uicontrol('Style','edit',...
                      'Position',pos_updownfields.text{i},'Visible','off');               
        updownfields.up{i} = uicontrol('Style','pushbutton','String','+',...
                    'Position',pos_updownfields.up{i},'Visible','off');               
        updownfields.down{i} = uicontrol('Style','pushbutton','String','-',...
                      'Position',pos_updownfields.down{i},'Visible','off');
    end
    set(updownfields.text{1},'Callback', {@updownfield_text_1_Callback});
    set(updownfields.text{2},'Callback', {@updownfield_text_2_Callback});
    set(updownfields.text{3},'Callback', {@updownfield_text_3_Callback});
    set(updownfields.text{4},'Callback', {@updownfield_text_4_Callback});
    set(updownfields.text{5},'Callback', {@updownfield_text_5_Callback});
    set(updownfields.text{6},'Callback', {@updownfield_text_6_Callback});
    set(updownfields.text{7},'Callback', {@updownfield_text_7_Callback});
    set(updownfields.text{8},'Callback', {@updownfield_text_8_Callback});
    set(updownfields.up{1},'Callback', {@updownfield_up_1_Callback});
    set(updownfields.up{2},'Callback', {@updownfield_up_2_Callback});
    set(updownfields.up{3},'Callback', {@updownfield_up_3_Callback});
    set(updownfields.up{4},'Callback', {@updownfield_up_4_Callback});
    set(updownfields.up{5},'Callback', {@updownfield_up_5_Callback});
    set(updownfields.up{6},'Callback', {@updownfield_up_6_Callback});
    set(updownfields.up{7},'Callback', {@updownfield_up_7_Callback});
    set(updownfields.up{8},'Callback', {@updownfield_up_8_Callback});
    set(updownfields.down{1},'Callback', {@updownfield_down_1_Callback});
    set(updownfields.down{2},'Callback', {@updownfield_down_2_Callback});
    set(updownfields.down{3},'Callback', {@updownfield_down_3_Callback});
    set(updownfields.down{4},'Callback', {@updownfield_down_4_Callback});
    set(updownfields.down{5},'Callback', {@updownfield_down_5_Callback});
    set(updownfields.down{6},'Callback', {@updownfield_down_6_Callback});
    set(updownfields.down{7},'Callback', {@updownfield_down_7_Callback});
    set(updownfields.down{8},'Callback', {@updownfield_down_8_Callback});
                  

% create buttons for choosing x-axes
xscale_pos=[axes_size(1)-10 axes_size(2)-90 axes_size(3)+65 40; ...
            10 5 60 20;...
            80 5 60 20; ...
            150 5 60 20;...
            220 5 60 20; ...
            290 5 60 20; ...
            360 5 60 20; ...
            420 5 60 20; ...
            490 5 60 20];
group_xscale = uibuttongroup('visible','on','Title','X-Axis','Units',...
    'pixels','Position',xscale_pos(1,:));
x_dim{1}  = uicontrol('Style','Radio','String','dim1',...
                       'pos',xscale_pos(2,:),'parent',group_xscale,'visible', 'off');
x_dim{2}  = uicontrol('Style','Radio','String','dim2',...
                       'pos',xscale_pos(3,:),'parent',group_xscale,'visible', 'off');
x_dim{3}  = uicontrol('Style','Radio','String','dim3',...
                       'pos',xscale_pos(4,:),'parent',group_xscale,'visible', 'off');
x_dim{4}  = uicontrol('Style','Radio','String','dim4',...
                       'pos',xscale_pos(5,:),'parent',group_xscale,'visible', 'off');
x_dim{5}  = uicontrol('Style','Radio','String','dim5',...
                       'pos',xscale_pos(6,:),'parent',group_xscale,'visible', 'off');
x_dim{6}  = uicontrol('Style','Radio','String','dim6',...
                       'pos',xscale_pos(7,:),'parent',group_xscale,'visible', 'off');
x_dim{7}  = uicontrol('Style','Radio','String','dim7',...
                       'pos',xscale_pos(8,:),'parent',group_xscale,'visible', 'off');
x_dim{8}  = uicontrol('Style','Radio','String','dim8',...
                       'pos',xscale_pos(9,:),'parent',group_xscale,'visible', 'off');                                      
set(group_xscale,'SelectionChangeFcn',@group_xscale_SelectionChangeFcn);
set(group_xscale,'SelectedObject',x_dim{1});
set(group_xscale,'Visible','on');
                     
% create buttons for choosing y-axes
yscale_pos=[axes_size(1)-90 axes_size(2)+axes_size(4)-300 60 300];
yscale_pos(2:10,:)=[2 yscale_pos(1,4)-50 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-80 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-110 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-140 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-170 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-200 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-230 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-260 yscale_pos(1,3)-4 20; ...
                   2 yscale_pos(1,4)-290 yscale_pos(1,3)-4 20];
group_yscale = uibuttongroup('visible','off','Title','Y-Axis','Units',...
    'pixels','Position',yscale_pos(1,:));
y_dim{1}  = uicontrol('Style','Radio','String','dim1',...
                       'pos',yscale_pos(2,:),'parent',group_yscale,'visible', 'off');
y_dim{2}  = uicontrol('Style','Radio','String','dim2',...
                       'pos',yscale_pos(3,:),'parent',group_yscale,'visible', 'off');
y_dim{3}  = uicontrol('Style','Radio','String','dim3',...
                       'pos',yscale_pos(4,:),'parent',group_yscale,'visible', 'off');
y_dim{4}  = uicontrol('Style','Radio','String','dim4',...
                       'pos',yscale_pos(5,:),'parent',group_yscale,'visible', 'off');
y_dim{5}  = uicontrol('Style','Radio','String','dim5',...
                       'pos',yscale_pos(6,:),'parent',group_yscale,'visible', 'off');
y_dim{6}  = uicontrol('Style','Radio','String','dim6',...
                       'pos',yscale_pos(7,:),'parent',group_yscale,'visible', 'off');                   
y_dim{7}  = uicontrol('Style','Radio','String','dim7',...
                       'pos',yscale_pos(8,:),'parent',group_yscale,'visible', 'off');
y_dim{8}  = uicontrol('Style','Radio','String','dim8',...
                       'pos',yscale_pos(9,:),'parent',group_yscale,'visible', 'off'); 
y_none  = uicontrol('Style','Radio','String','none',...
                        'pos',yscale_pos(10,:),'parent',group_yscale,'visible', 'on');
set(group_yscale,'SelectionChangeFcn',@group_yscale_SelectionChangeFcn);
set(group_yscale,'SelectedObject',y_dim{2});
set(group_yscale,'Visible','on');

% IF Frequency -> activate this box with: real, imag, abs, phase
complex_pos=[10 sum(yscale_pos(1,[2,4]))-120 85 120; 3 80 75 20; 3 55 75 20; 3 30 75 20; 3 5 75 20];
group_complex = uibuttongroup('visible','off','Title','Mode','Units',...
    'pixels','Position',complex_pos(1,:));
complex_abs  = uicontrol('Style','Radio','String','absolute',...
                       'pos',complex_pos(2,:),'parent',group_complex,'HandleVisibility','off');
complex_phase  = uicontrol('Style','Radio','String','phase',...
                       'pos',complex_pos(3,:),'parent',group_complex,'HandleVisibility','off');
complex_real  = uicontrol('Style','Radio','String','real',...
                       'pos',complex_pos(4,:),'parent',group_complex,'HandleVisibility','off');
complex_imag  = uicontrol('Style','Radio','String','imag',...
                       'pos',complex_pos(5,:),'parent',group_complex,'HandleVisibility','off');                   
set(group_complex,'SelectionChangeFcn',@group_complex_SelectionChangeFcn);
set(group_complex,'SelectedObject',complex_abs);
set(group_complex,'Visible','on');

% threshold:
threshold_pos=[complex_pos(1,1), complex_pos(1,2)-30-15, complex_pos(1,3), 30];
threshold_pos(2:4,1:4)=[threshold_pos(1,1), threshold_pos(1,2)-35, threshold_pos(1,3), threshold_pos(1,4);...
                        threshold_pos(1,1), threshold_pos(1,2)-80, threshold_pos(1,3), threshold_pos(1,4);...
                        threshold_pos(1,1), threshold_pos(1,2)-115, threshold_pos(1,3), threshold_pos(1,4)];
threshold_min_heading = uicontrol('Style','text','String','Threshold min:',...
                        'Position',threshold_pos(1,:));
threshold_min_text = uicontrol('Style','edit',...
                     'Position',threshold_pos(2,:),'Callback',{@threshold_min_text_Callback}, 'FontSize', 8);
threshold_max_heading = uicontrol('Style','text','String','Threshold max:',...
                        'Position',threshold_pos(3,:));
threshold_max_text = uicontrol('Style','edit',...
                     'Position',threshold_pos(4,:),'Callback',{@threshold_max_text_Callback}, 'FontSize', 8);

% Create controls for  scaling
scaling_pos=[10 yscale_pos(1,2)-95-15 yscale_pos(1,1)+yscale_pos(1,3)-10 95; 10 55 130 20; 10 30 130 20];
group_size = uibuttongroup('visible','off','Title','Image size','Units',...
    'pixels','Position',scaling_pos(1,:));
size_image  = uicontrol('Style','Radio','String','Square Pixels',...
                       'pos',scaling_pos(2,:),'parent',group_size,'HandleVisibility','off');
size_normal  = uicontrol('Style','Radio','String','Fullsize',...
                       'pos',scaling_pos(3,:),'parent',group_size,'HandleVisibility','off');

set(group_size,'SelectionChangeFcn',@group_size_SelectionChangeFcn);
set(group_size,'SelectedObject',size_image);
set(group_size,'Visible','on');

% Create controls for colormap and scaling
cmap_pos=[10 scaling_pos(1,2)-95-15 scaling_pos(1,3) 95; 10 55 90 20; 10 30 80 20; 10 5 80 20];
group_cmap = uibuttongroup('visible','off','Title','Colormap','Units',...
    'pixels','Position',cmap_pos(1,:));
cmap_colorgray  = uicontrol('Style','Radio','String','ColorGray',...
                       'pos',cmap_pos(2,:),'parent',group_cmap,'HandleVisibility','off');
cmap_gray  = uicontrol('Style','Radio','String','Gray',...
                       'pos',cmap_pos(3,:),'parent',group_cmap,'HandleVisibility','off');
cmap_jet  = uicontrol('Style','Radio','String','Jet',...
                       'pos',cmap_pos(4,:),'parent',group_cmap,'HandleVisibility','off');
set(group_cmap,'SelectionChangeFcn',@group_cmap_SelectionChangeFcn);
set(group_cmap,'SelectedObject',cmap_colorgray);
set(group_cmap,'Visible','on');



% Create controls for line plots
line_pos=[line_axes; ...
          30 20, line_axes(3)-40 line_axes(4)/2-50; ...
          30 line_axes(4)/2+15, line_axes(3)-40 line_axes(4)/2-50; ...
          line_axes(1)+line_axes(3)/2-50 line_axes(2)-30 40 15; ...
          line_axes(1)+line_axes(3)/2-10 line_axes(2)-30 60 15];
group_line=uipanel(f2,'Units','pixels','Title','Line plot', 'Position',line_pos(1,:));
linex_axes=axes('Units','pixels','Parent',group_line, 'Position',line_pos(2,:));
liney_axes=axes('Units','pixels','Parent',group_line, 'Position',line_pos(3,:));
line_value=uicontrol('Style','text','Position',line_pos(4,:), 'String','value:');
line_text=uicontrol('Style','text','Position',line_pos(5,:), 'String','');

%% Set path, name and printbutton for printing:
path_pos=[line_axes(1)+10 100 165 30];
path_pos(2:3,:)=[path_pos(1,1), path_pos(1,2)-45 line_axes(3) 35; ...
                 path_pos(1,1)+path_pos(1,3)+10 path_pos(1,2) 0 0]; % pos of tiffnumber
path_pos(4:6,:)=[path_pos(3,1) path_pos(3,2)+35 70 15;...
                 path_pos(3,1) path_pos(3,2) 70 30; ...
                 path_pos(1,1)+path_pos(1,3)+85 path_pos(1,2) 80 30];                 
path_button=uicontrol('Style','pushbutton','String','Set path and Dataname',...
    'Position',path_pos(1,:),...
    'Callback',{@path_button_ButtonDownFcn});
% show datapath:
path_text=uicontrol('Style','text','Position',path_pos(2,:),...
    'String',['next save: .', filesep, 'Image1.tiff']);

% tiffnumber
tiffnumber_heading = uicontrol('Style','text','String','number:',...
                        'Position',path_pos(4,:));
tiffnumber_text = uicontrol('Style','edit',...
                     'Position',path_pos(5,:),'Callback',{@tiffnumber_text_Callback});
% Print to tiff
tiff_button=uicontrol('Style','pushbutton','String','Save as .tiff',...
    'Position',path_pos(6,:),...
    'Callback',{@tiff_button_ButtonDownFcn});
% Colarbar selector
tiff_colorbar_pos=[path_pos(1,1), path_pos(1,2)-90 line_axes(3) 40;...
                   10 5 150 20;...
                    160 5 150 20];
group_tiff_colorbar = uibuttongroup('visible','on','Title','Colorbar','Units',...
    'pixels','Position',tiff_colorbar_pos(1,:));
tiff_colorbar_off  = uicontrol('Style','Radio','String','save only image',...
                       'pos',tiff_colorbar_pos(2,:),'parent',group_tiff_colorbar,'HandleVisibility','off');
tiff_colorbar_on  = uicontrol('Style','Radio','String','save with colorbar',...
                       'pos',tiff_colorbar_pos(3,:),'parent',group_tiff_colorbar,'HandleVisibility','off');
                                   
set(group_tiff_colorbar,'SelectionChangeFcn',@group_tiff_colorbar_SelectionChangeFcn);
set(group_tiff_colorbar,'SelectedObject',tiff_colorbar_off);
set(group_tiff_colorbar,'Visible','on');

end




%% Figure resize function
function figResize(src,evt)
    fpos = get(f2,'Position');
    for i=1:8
        set(updownfields.heading{i}, 'Position', posScal(pos_updownfields.heading{i}));
        set(updownfields.text{i}, 'Position', posScal(pos_updownfields.text{i}));
        set(updownfields.up{i}, 'Position', posScal(pos_updownfields.up{i}));
        set(updownfields.down{i}, 'Position', posScal(pos_updownfields.down{i}));
    end
    
    set(group_cmap, 'Position', posScal(cmap_pos(1,:)));
    set(cmap_colorgray, 'pos', posScal(cmap_pos(2,:)));
    set(cmap_gray, 'pos', posScal(cmap_pos(3,:)));
    set(cmap_jet, 'pos', posScal(cmap_pos(4,:)));   
       
    set(group_complex, 'Position',posScal(complex_pos(1,:)));
    set(complex_abs, 'pos',posScal(complex_pos(2,:)));
    set(complex_phase, 'pos', posScal(complex_pos(3,:)));
    set(complex_real, 'pos',posScal(complex_pos(4,:)));
    set(complex_imag, 'pos',posScal(complex_pos(5,:)));
    
    set(group_size, 'Position',posScal(scaling_pos(1,:)));
    set(size_image, 'pos',posScal(scaling_pos(2,:)));
    set(size_normal, 'pos',posScal(scaling_pos(3,:)));
   
    set(group_xscale, 'pos', posScal(xscale_pos(1,:)));
    set(x_dim1, 'pos', posScal(xscale_pos(2,:)));
    set(x_dim2, 'pos', posScal(xscale_pos(3,:)));
    set(x_dim3, 'pos', posScal(xscale_pos(4,:)));
    set(x_dim4, 'pos', posScal(xscale_pos(5,:)));
    set(x_dim5, 'pos', posScal(xscale_pos(6,:)));
    set(x_dim6, 'pos', posScal(xscale_pos(7,:)));
    set(x_dim7, 'pos', posScal(xscale_pos(8,:)));
    set(x_dim8, 'pos', posScal(xscale_pos(9,:)));
     
    set(group_yscale, 'pos', posScal(yscale_pos(1,:)));
    set(y_dim1, 'pos', posScal(yscale_pos(2,:)));
    set(y_dim2, 'pos', posScal(yscale_pos(3,:)));
    set(y_dim3, 'pos', posScal(yscale_pos(4,:)));
    set(y_dim4, 'pos', posScal(yscale_pos(5,:)));
    set(y_dim5, 'pos', posScal(yscale_pos(6,:)));
    set(y_dim6, 'pos', posScal(yscale_pos(7,:)));
    set(y_dim7, 'pos', posScal(yscale_pos(8,:)));
    set(y_dim8, 'pos', posScal(yscale_pos(9,:)));
    set(y_none, 'pos', posScal(yscale_pos(10,:)));
    
    set(threshold_min_heading,  'pos', posScal(threshold_pos(1,:)));
    set(threshold_min_text,     'pos', posScal(threshold_pos(2,:)));
    set(threshold_max_heading,  'pos', posScal(threshold_pos(3,:)));
    set(threshold_max_text,     'pos', posScal(threshold_pos(4,:)));  
    
    set(group_line, 'pos', posScal(line_pos(1,:)))
    set(linex_axes, 'pos', posScal(line_pos(2,:)));
    set(liney_axes, 'pos', posScal(line_pos(3,:)));    
    set(line_value, 'pos', posScal(line_pos(4,:)));
    set(line_text,  'pos', posScal(line_pos(5,:)));        
    
    set(path_button,        'pos', posScal(path_pos(1,:)));
    set(path_text,          'pos', posScal(path_pos(2,:)));  
    set(tiffnumber_heading, 'pos', posScal(path_pos(4,:)));
    set(tiffnumber_text,    'pos', posScal(path_pos(5,:)));
    set(tiff_button,        'pos', posScal(path_pos(6,:))); 
    set(group_tiff_colorbar,'pos', posScal(tiff_colorbar_pos(1,:)));
    set(tiff_colorbar_off,   'pos', posScal(tiff_colorbar_pos(2,:)));  
    set(tiff_colorbar_on,  'pos', posScal(tiff_colorbar_pos(3,:)));
    
    set(abs_axes, 'Position', axes_size.*[fpos(3)/fig_pos(3) fpos(4)/fig_pos(4) fpos(3)/fig_pos(3) fpos(4)/fig_pos(4)]);
end

function [new_pos]=posScal(original_pos)
    fpos = get(f2,'Position');
    new_pos=[fpos(3)*original_pos(1)/fig_pos(3), fpos(4)*original_pos(2)/fig_pos(4) fpos(3)*original_pos(3)/fig_pos(3) fpos(4)*original_pos(4)/fig_pos(4)];
end

%% Callbacks

% Field 1
function updownfield_text_1_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
            if (1<=valNum) && (valNum<=n1)
                actDim1=floor(valNum);
            end
            set(source,'String',int2str(actDim1));
    end
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_1_Callback(source, eventdata)
    if (actDim1+1<=n1)
        actDim1=actDim1+1;
    end
    set(updownfields.text{1},'String',int2str(actDim1));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_down_1_Callback(source, eventdata)
    if (actDim1-1>=1)
        actDim1=actDim1-1;
    end
    set(updownfields.text{1},'String',int2str(actDim1));
    Draw_Image(false);
    Draw_Line(false);
end

% Field 2
function updownfield_text_2_Callback(source, eventdata)
    if (1<=valNum) && (valNum<=n2)
        actDim2=floor(valNum); 
    end 
    set(source,'String',int2str(actDim2));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_2_Callback(source, eventdata)
    if (actDim2+1<=n2)
        actDim2=actDim2+1;
    end
    set(updownfields.text{2},'String',int2str(actDim2));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_down_2_Callback(source, eventdata)
    if (actDim2-1>=1)
        actDim2=actDim2-1;
    end
    set(updownfields.text{2},'String',int2str(actDim2));
    Draw_Image(false);
    Draw_Line(false);
end

% Field 3
function updownfield_text_3_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n3)
            actDim3=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim3));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_3_Callback(source, eventdata)
    if (actDim3+1<=n3)
        actDim3=actDim3+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{3},'String',int2str(actDim3));
end

function updownfield_down_3_Callback(source, eventdata)
    if (actDim3-1>=1)
        actDim3=actDim3-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{3},'String',int2str(actDim3));
end

% Field 4
function updownfield_text_4_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n4)
            actDim4=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim4));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_4_Callback(source, eventdata)
    if (actDim4+1<=n4)
        actDim4=actDim4+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{4},'String',int2str(actDim4));
end

function updownfield_down_4_Callback(source, eventdata)
    if (actDim4-1>=1)
        actDim4=actDim4-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{4},'String',int2str(actDim4));
end

% Field 5
function updownfield_text_5_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n5)
            actDim5=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim5));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_5_Callback(source, eventdata)
    if (actDim5+1<=n5)
        actDim5=actDim5+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{5},'String',int2str(actDim5));
end

function updownfield_down_5_Callback(source, eventdata)
    if (actDim5-1>=1)
        actDim5=actDim5-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{5},'String',int2str(actDim5));
end

% Field 6
function updownfield_text_6_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n6)
            actDim6=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim6));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_6_Callback(source, eventdata)
    if (actDim6+1<=n6)
        actDim6=actDim6+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{6},'String',int2str(actDim6));
end

function updownfield_down_6_Callback(source, eventdata)
    if (actDim6-1>=1)
        actDim6=actDim6-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{6},'String',int2str(actDim6));
end
% Field 7
function updownfield_text_7_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n7)
            actDim7=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim7));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_7_Callback(source, eventdata)
    if (actDim7+1<=n7)
        actDim7=actDim7+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{7},'String',int2str(actDim7));
end

function updownfield_down_7_Callback(source, eventdata)
    if (actDim7-1>=1)
        actDim7=actDim7-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{7},'String',int2str(actDim7));
end

% Field 8
function updownfield_text_8_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        if (1<=valNum) && (valNum<=n8)
            actDim8=floor(valNum);
        end
    end
    set(source,'String',int2str(actDim8));
    Draw_Image(false);
    Draw_Line(false);
end

function updownfield_up_8_Callback(source, eventdata)
    if (actDim8+1<=n8)
        actDim8=actDim8+1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{8},'String',int2str(actDim8));
end

function updownfield_down_8_Callback(source, eventdata)
    if (actDim8-1>=1)
        actDim8=actDim8-1;
        Draw_Image(false);
        Draw_Line(false);
    end
    set(updownfields.text{8},'String',int2str(actDim8));
end

% Colormap group
function group_cmap_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'ColorGray'
            cmap='bruker_ColorGray';
        case 'Gray'
            cmap='gray';
        case 'Jet'
            cmap='jet';
    end
    Draw_Image(false);
    
end

% freq. mode
function group_complex_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'absolute'
            freq='abs';
        case 'phase'
            freq='phase';
        case 'real'
            freq='real';
        case 'imag'
            freq='imag';    
    end
    Draw_Image(false);   
end

% Size group
function group_size_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'Square Pixels'
            mysize='image';
        case 'Fullsize'
            mysize='normal';
    end
    Draw_Image(false);
    
end

% Get pointer location for line plots
function f_WindowButtonMotionFcn(source, eventdata)
    % location of mouse pointer
    pa=get(abs_axes,'CurrentPoint');
    pa=round(pa(1:2:3));
        
    if (pa(2)>=1 && pa(2)<=size(ds,1) && pa(1)>=1 && pa(1)<=size(ds,2)),
        % pointer is on abs_axes
        axes_handle=abs_axes;
        pt=pa;
        Draw_Image(false);
        Draw_Line(true);
    end
end

% xscale group
function group_xscale_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'dim1'
            axes_show(1)=1;
        case 'dim2'
            axes_show(1)=2;
        case 'dim3'
            axes_show(1)=3;
        case 'dim4'
            axes_show(1)=4;
        case 'dim5'
            axes_show(1)=5;
        case 'dim6'
            axes_show(1)=6;
        case 'dim7'
            axes_show(1)=7;
        case 'dim8'
            axes_show(1)=8;
    end
    handle_dimensions;
    Draw_Image(false);
    Draw_Line(false);
end
% yscale group
function group_yscale_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'dim1'
            axes_show(2)=1;
        case 'dim2'
            axes_show(2)=2;
        case 'dim3'
            axes_show(2)=3;
        case 'dim4'
            axes_show(2)=4;
        case 'dim5'
            axes_show(2)=5;
        case 'dim6'
            axes_show(2)=6;
        case 'dim7'
            axes_show(2)=7;
        case 'dim8'
            axes_show(2)=8;    
        case 'none'
            axes_show(2)=0;
    end
    handle_dimensions;
    Draw_Image(false);
    Draw_Line(false);
end

% threshold:
function threshold_min_text_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum)) && isempty(imscale)
       threshold_min=valNum;
       set(source,'String',num2str(valNum, '% 10.2f'));
    elseif ~isempty(imscale)
        set(source,'String','');
    else
        set(source,'String',num2str(threshold_min, '% 10.2f'));
    end
    Draw_Image(true);
    Draw_Line(false);
end
function threshold_max_text_Callback(source, eventdata)
    valString=get(source,'String');
    valNum=str2double(valString);
    if  (~isnan(valNum)) && isempty(imscale)
       threshold_max=valNum;
       set(source,'String',num2str(valNum, '% 10.2f'));
    elseif ~isempty(imscale)
        set(source,'String','');
    else
        set(source,'String',num2str(threshold_max, '% 10.2f'));
    end   
    Draw_Image(true);
    Draw_Line(false);
end

function path_button_ButtonDownFcn(source, eventdata)
   tiffname=uiputfile('*', 'Save Image as');
   if tiffnumber <= 0
       set(path_text, 'String',['next save: ', tiffname, '.tiff']);
   else
       set(path_text, 'String',['next save: ', tiffname, num2str(tiffnumber), '.tiff']);
   end  	
end

function tiffnumber_text_Callback(source, eventdata)
    valString=get(source, 'String');
    valNum=str2double(valString);
    if  (~isnan(valNum))
        tiffnumber=floor(valNum);
    end
    set(source,'String',int2str(tiffnumber));
    if tiffnumber>=1
        set(path_text, 'String',['next save: ', tiffname , num2str(tiffnumber), '.tiff']);
    else
        set(path_text, 'String',['next save: ', tiffname, '.tiff']);
    end
end

function group_tiff_colorbar_SelectionChangeFcn(source, eventdata)
    switch get(eventdata.NewValue,'String')   % Get Tag of selected object
        case 'save only image'
            save_with_colorbar=false;
        case 'save with colorbar'
            save_with_colorbar=true;
    end
end

% save image as tiff
function tiff_button_ButtonDownFcn(source, eventdata)
    % generate image:
    normal_axes_handle=gca; % save handle for write-back
    create_slice;
    if save_with_colorbar
        %% with colorbar
        if axes_show(2)~=0 && strcmp(mysize, 'image')
            printfigure=figure('Units','pixels','Position',[0,0,size(ds,2)+130+60, size(ds,1)+60], 'Visible', 'off');
            print_axes=axes('Units','pixels','Position',[30,30,size(ds,2)+130, size(ds,1)]);
            axis image;
        elseif axes_show(2)~=0 && strcmp(mysize, 'normal')
            printaxes_size=get(abs_axes,'Position');
            printfigure=figure('Position',[0,0,printaxes_size(3)+130+60,printaxes_size(4)+60], 'Visible', 'off');
            printaxes_size=[30,30,printaxes_size(3)+130,printaxes_size(4)];
            print_axes=axes('Units','pixels','Position',printaxes_size);
            axis normal;
        end
        % show image:
        if axes_show(2)~=0
            axes(print_axes);
            colormap(cmap);
            imagesc(ds,imagescale);
            set(print_axes,'Tag','abs');
            colorbar;
        else
            plot(squeeze(ds));
        end
    else
        %% only image
        if axes_show(2)~=0 && strcmp(mysize, 'image')
            printfigure=figure('Visible', 'off', 'Units','pixels','Position',[0,0,size(ds,2), size(ds,1)]);
            print_axes=axes('Units','pixels','Position',[0,0,size(ds,2), size(ds,1)]);
            axis image;
        elseif axes_show(2)~=0 && strcmp(mysize, 'normal')
            printaxes_size=get(abs_axes,'Position');
            printfigure=figure('Visible', 'off', 'Position',[0,0,printaxes_size(3),printaxes_size(4)]);
            printaxes_size=[0,0,printaxes_size(3),printaxes_size(4)];
            print_axes=axes('Units','pixels','Position',printaxes_size);
            axis normal;
        end

        % show image:
        if axes_show(2)~=0
            axes(print_axes);
            colormap(cmap);
            imagesc(ds,imagescale);
            set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []); % remove numbers on X-axes
            set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []); % remove numbers on Y-axes
        else
            plot(squeeze(ds));
        end
    end
        
    
    % save image
    if tiffnumber>=1
        dataname=[tiffname, num2str(tiffnumber), '.tiff'];
    else
        dataname=[tiffname, '.tiff'];
    end      
    res = ['-r' num2str(ceil(get(0, 'ScreenPixelsPerInch')*res_factor))];
    set(printfigure, 'PaperPositionMode', 'auto');
    print(printfigure, '-opengl', res, '-dtiff', dataname);
    if tiffnumber>=1
        tiffnumber=tiffnumber+1;
        set(tiffnumber_text, 'String',num2str(tiffnumber));
        set(path_text, 'String',['next save: ', tiffname , num2str(tiffnumber), '.tiff']);
    else
        set(path_text, 'String',['next save: ', tiffname, '.tiff']);
    end
    close(printfigure);
    figure(f2);
    axes(normal_axes_handle); % write handle back
end

function handle_dimensions       
    dims=ones(8,1); % exclude 1st and 2nd dim     
    for i=1:8
        if size(dataset,i) >1
            dims(i)=ceil(size(dataset,i)/2);
            set(updownfields.text{i},'Visible', 'on', 'String', num2str(dims(i)));
            set(updownfields.heading{i},'Visible', 'on');
            set(updownfields.up{i}, 'Visible', 'on');
            set(updownfields.down{i}, 'Visible', 'on');            
        end     
    end        
    actDim1=dims(1);
    actDim2=dims(2);
    actDim3=dims(3);
    actDim4=dims(4);
    actDim5=dims(5);
    actDim6=dims(6);
    actDim7=dims(7);
    actDim8=dims(8);
    
    if axes_show(2)~=0 % normal:
        for i=axes_show
            set(updownfields.text{i},'Visible', 'off');
            set(updownfields.up{i}, 'Visible', 'off');
            set(updownfields.down{i}, 'Visible', 'off');
        end
    else % none:
        set(updownfields.text{axes_show(1)},'Visible', 'off');
        set(updownfields.up{axes_show(1)}, 'Visible', 'off');
        set(updownfields.down{axes_show(1)}, 'Visible', 'off');
    end


end


%% create Slice
function create_slice
   actDim_ges=[actDim1, actDim2, actDim3, actDim4, actDim5, actDim6, actDim7, actDim8];
   d=cell(8,1);
   for i=1:length(actDim_ges)
      if i==axes_show(1) || i==axes_show(2)
         d{i}=1:size(dataset,i); 
      else
         d{i}=actDim_ges(i);
      end
       
   end
  
    % create Image:

    switch freq
        case 'abs'
            ds=abs(squeeze(dataset(d{1}, d{2}, d{3}, d{4}, d{5}, d{6}, d{7}, d{8})));
        case 'phase'
            ds=angle(squeeze(dataset(d{1}, d{2}, d{3}, d{4}, d{5}, d{6}, d{7}, d{8})));
        case 'real'
            ds=real(squeeze(dataset(d{1}, d{2}, d{3}, d{4}, d{5}, d{6}, d{7}, d{8})));
        case 'imag'
            ds=imag(squeeze(dataset(d{1}, d{2}, d{3}, d{4}, d{5}, d{6}, d{7}, d{8}))); 
    end
    
        
    if ~(axes_show(1) > axes_show(2)) %|| (axes_show(1)==0 && axes_show(2)==2 && ~(axes_show(1)==2))
        ds=permute(ds, [2 1]);
    end
    
    
end


%% Drawing function
function Draw_Line(draw)
    if axes_show(2)~=0   
        im_handle=findobj('Tag',[get(axes_handle,'Tag') '_im']);
        im_handle=im_handle(1);
        im=get(im_handle,'CData');

        % print value
        if pt(1) > size(im,2)
            pt(1)=ceil(size(ds,2)/2);
        end
        if pt(2) > size(im,1)
            pt(2)=ceil(size(ds,1)/2);
        end
        set(line_text,'String',num2str(im(pt(2),pt(1))));

        axes(liney_axes);
        plot([1:size(im,2)],im(pt(2),:),'b');
        title(liney_axes,['horizontal ' num2str(pt(2))]);
        if ~(size(im,2)==1)
            set(liney_axes,'XLim',[1,size(im,2)]);
        end
        if axes_handle==abs_axes,
            set(liney_axes,'YLim',imagescale);
        else
            set(liney_axes,'YLim',[min(im(:)) max(im(:))]);
        end;

        axes(linex_axes);
        plot([1:size(im,1)],im(:,pt(1)),'r');
        title(linex_axes,['vertical ' num2str(pt(1))]);
        if~(size(im,1)==1)
            set(linex_axes,'XLim',[1,size(im,1)]);
        end
        if axes_handle==abs_axes,
            set(linex_axes,'YLim',imagescale);
        else
            set(linex_axes,'YLim',[min(im(:)) max(im(:))]);
        end;

        %Draw line
        axes(axes_handle);
        if draw
            line([pt(1) pt(1)],[1,size(ds,1)],'Color','r');
            line([1,size(ds,2)],[pt(2) pt(2)],'Color','b');
        end
    end
end

%-----Draws Image
function Draw_Image(keep_threshold)
    % ignore warning "Log of zero"
    warning off MATLAB:log:logOfZero
    
    create_slice;
    if axes_show(2)~=0
        % generate imagescale from thresholds   
        if isempty(imscale)
            if ~keep_threshold
                imagescale=double([min(ds(:)) max(ds(:))]);
                threshold_min=min(ds(:));
                threshold_max=max(ds(:));
                set(threshold_min_text, 'String', num2str(threshold_min, '% 10.2f'));
                set(threshold_max_text, 'String', num2str(threshold_max, '% 10.2f'));
            else
                imagescale=double([threshold_min, threshold_max]);
            end
            if ~isempty(imscale) && imagescale(1)==imagescale(2)
                imagescale(2)=imagescale(2)+1;
            end
        else
            imagescale=imscale;
        end
        
        % show image: 
        axes(abs_axes);
        colormap(cmap);
        abs_im=imagesc(ds,imagescale);
        if strcmp(mysize, 'image')
            axis image;
        elseif strcmp(mysize, 'normal')
            axis normal;
        end
        title(['(', num2str(n1), ',', num2str(n2), ',' num2str(n3), ',', num2str(n4), ',', num2str(n5), ',' num2str(n6), ',', num2str(n7), ',', num2str(n8), ')']);

        set(abs_axes,'Tag','abs');
        set(abs_im,'Tag','abs_im');
        colorbar;
    else
        plot(squeeze(ds));
    end
  
    warning on MATLAB:log:logOfZero
end

end % end brViewer