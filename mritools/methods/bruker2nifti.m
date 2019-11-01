


function tagout=bruker2nifti(pathin, pathout)
%
% s=input('use GUI or ')
% [files,dirs] = spm_select('FPListRec',a,'2dseq')


%% gui ..get 2dseq
if ~exist('pathin') || isempty(pathin); pathin=pwd; end


disp('====================================================');
disp('*** find recursively all "2dseq" in subfolders ***');
disp('[1]in GUI select upper path were data are stored in subfolders');
disp('[2]in GUI pres [rec] button to recursively find all 2dseq-files in all subfolders');
disp('[3]in GUI pres [done]');



[files,dirs] = spm_select(inf,'2dseq',...
    'select [2dseq], press [rec] to recursively find all [2dseq]files in subfolder',...
    '',pathin);
if isempty(files); return; end ;%ESCAPE
files=cellstr(files);


%% gui ..path2store NIFT
if ~exist('pathout') || isempty(pathout)
    % [pa fi]=fileparts(pathin)
    pathout = uigetdir(pathin,'Select the directory to store NIFTI data');
end
if exist(pathout,'file')~=7
    mkdir(pathout);
end


%% select data via check size
for i=1:size(files,1)
    k(i)=dir(files{i});
end
mbytes=cell2mat({k(:).bytes}')/1e6;


prompt = {'select method [rare,flash,fisp], if empty all sequences processed'; 'select data above x-Mbites, otherwise [empty] using all data'};
dlg_title = 'Input for peaks function';
num_lines = 1;
def = {'rare' , num2str([0])};
answer = inputdlg(prompt,dlg_title,num_lines,def);

sequence= answer{1};
mbthresh  = answer{2};

%% byte-issue
if isempty(mbthresh);     mbthresh='0';  end
mbthresh=str2num(mbthresh);
isel= find(mbytes>=mbthresh );
sprintf(' # %d files above %2.2fMB found',length(isel) ,mbthresh);

files=files(isel);
% filesbk=files;


%% sequence-issue
%check: <Bruker:RARE>
tagout={''};
if ~isempty(sequence)
    usedfiles  =zeros(length(files),1);
    usedfileSeq=cell(length(files),1);
    disp('*** check Sequence ***');
    for i=1:length(files)
        [pa fi]=fileparts(files{i});
        pa2=pa(1:strfind(pa,'pdata')-1);
        methodfile=fullfile(pa2,'method');
        
        %% if methodfile is not found ...  adaption needed...
        if exist(methodfile,'file')~=2
            keyboard
        end
        
        pause(.1); %readerrorstuff :)
        methods=readBrukerParamFile(methodfile);
        
        usedfileSeq{i,1}=methods.Method;
        % if strcmp(methods.Method, upper(sequence) )==1
        if ~isempty(regexpi(methods.Method,sequence))
            usedfiles(i)=1;
        end
        
        tag= sprintf('%d\\%d-%s:\t%s >>[used]%d',i,length(files), methodfile,methods.Method,usedfiles(i)) ;
        disp(tag);
        tagout{i,1}=tag;
    end
    files= files(find(usedfiles));
    tagout=[{'*** USED FILES ***'} ;tagout(find(usedfiles))];
end

% keyboard

tagout=[tagout; {['#MbSizeTresh: ' num2str(mbthresh)  ]} ];
tagout=[tagout; {['#Sequence: ' sequence  ]} ];
tagout=[tagout; {['#Nfolders: ' num2str(length(files))  ]} ];




if pathout==0 ; return; end


%% loop trhoug all 2dseq-files

h = waitbar(0,'Please wait...');
for i=1:size(files,1)
    [pa fi]=fileparts(files{i});
    
    waitbar(i/size(files,1),h,[' convert2nifti:  ' num2str(i) '/' num2str(size(files,1)) ]);
    
    
    
    
    
    % PathName_2dseq=fullfile(PathName_pvstudy,nameFolds{i},'pdata',nameSubfolds{j});
    % path_to_2dseq=fullfile(PathName_2dseq,'2dseq');
    
    % open 2dseq
    path_to_2dseq = files{i} ;%fullfile(PathName_2dseq,'2dseq');
    Visu          = readBrukerParamFile(fullfile(pa,'visu_pars'));
    image_2dseq   = readBruker2dseq(path_to_2dseq,Visu);
    
    image_2dseq=squeeze(image_2dseq);% remove unnecessary dimensions
    
    %====Generate NIFTI files and store them in directory==========
    % Extract header info for NIFTI storage
    voxelsize_2dseq=[Visu.VisuCoreExtent./Visu.VisuCoreSize Visu.VisuCoreFrameThickness];
    voxelsize_2dseq=voxelsize_2dseq(1:3);
    
    %% ORIGIN : to check
    %     pos= Visu.VisuCorePosition;
    %     origin=[mean(pos(:,1:2)) [(min(pos(:,3))) ] ];
    
    % Convert the extracted image to Nifti and store
    %   image_2dseq_nii=make_nii(image_2dseq, voxelsize_2dseq);
    %      image_2dseq_nii=make_nii(image_2dseq, voxelsize_2dseq,origin);
    
    
       errorbool=[0 0 0 0];
    try
        SubjectId=Visu.VisuSubjectId ;
    catch
        SubjectId='x';    errorbool(1)=1;
    end
    
    try
        StudyNumber=num2str(Visu.VisuStudyNumber) ;
    catch
        StudyNumber='x';   errorbool(2)=1;
    end
    
    try
        ExperimentNumber=num2str(Visu.VisuExperimentNumber) ;
    catch
        ExperimentNumber='x' ; errorbool(3)=1;
    end
    
    try
        ProcessingNumber=num2str(Visu.VisuProcessingNumber) ;
    catch
        ProcessingNumber='x'   ;  errorbool(4)=1;
    end
    
    
   numID= files{1}(max(strfind(pa,filesep))+1:strfind(files{1},'2dseq')-2 );

    
    FileName_2dseq_base=[SubjectId '_' StudyNumber '_' ...
        ExperimentNumber '_' ProcessingNumber '_' numID ];
    
    
    
%     % Filenames
%     FileName_2dseq_base=[Visu.VisuSubjectId '_' num2str(Visu.VisuStudyNumber)...
%         '_' num2str(Visu.VisuExperimentNumber) '_' num2str(Visu.VisuProcessingNumber)];
%     
    filename=['s' FileName_2dseq_base];
    
    paout2=fullfile(pathout,filename);%% make DIR
    mkdir(paout2);
    
    filename2=fullfile(paout2,[filename '.nii']);
    %FileName_2dseq=fullfile(pathout,[FileName_2dseq_base '.nii']);
    
    
    
    % Store
    display(['saving ' filename2]);
    
    
    
    
    %     save_nii(image_2dseq_nii,FileName_2dseq);
    %         save_nii(image_2dseq_nii,'dum');
    %%===========SPM
    dim=size(image_2dseq);
    mat=diag([voxelsize_2dseq 1],0);
    mat(1:3,4)=-diag(mat(1:3,1:3)).*round(dim/2)' ;%origin set to centerImage
    hh   = struct('fname',filename2 ,...
        'dim',   {dim},...
        'dt',    {[64 spm_platform('bigend')]},...
        'pinfo', {[1 0 0]'},...
        'mat',   {mat},...
        'descrip', {['x']});
    %=================
    hh=spm_create_vol(hh);
    hh=spm_write_vol(hh,  (image_2dseq));
    
end%i
close(h)




%  FORMAT function [Outdata,voxdim, Origin] = rest_readfile(filename)
%                  filename - Analyze file (*.{hdr, img, nii})
%                  Outdata  - data file.
%                  VoxDim   - the size of the voxel.
%                  Header   - It's decided by the format of data file:
%                             for ANALYZE 7.5 - Header.Origin - the origin of the image;
%                             for NIFTI  - Head.fname - the filename of the image.
%                                          Head.dim   - the x, y and z dimensions of the volume
%                                          Head.dt    - A 1x2 array.  First element is datatype (see spm_type).
%                                                       The second is 1 or 0 depending on the endian-ness.
%                                          Head.mat   - a 4x4 affine transformation matrix mapping from
%                                                       voxel coordinates to real world coordinates.
%                                          Head.pinfo - plane info for each plane of the volume.
%                                          Head.pinfo(1,:) - scale for each plane
%                                          Head.pinfo(2,:) - offset for each plane
%                                                       The true voxel intensities of the jth image are given
%                                                       by: val*Head.pinfo(1,j) + Head.pinfo(2,j)
%                                          Head.pinfo(3,:) - offset into image (in bytes).
%                                                      If the size of pinfo is 3x1, then the volume is assumed
%                                                      to be contiguous and each plane has the same scalefactor
%                                                      and offset.
%                                          Head.private - a structure containing complete information in the
%                                                      header
%                                          Header.Origin - the origin of the image;

















