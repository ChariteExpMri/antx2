%% insert 2d-slices into 3D/4D-volume, preserve alignment with reference file
% #yk xinsertslice_aligned.m
% - This function inserts one/more 2d slices into a 3d or 4d volume which corresponds to a reference file
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
%
% 'reffile'        -NIFTI file used as reference for 2D slice insertion (3D/4D)
%
% 'insertfiles'    2D-file(s) to insert
%                  or usefile-filter, see example below
% 'slicenumber'   slice-number to insert
%                 -array of indices
%                 -'fromsuffix' to obtain sliceIndices from fileName of insertfiles
%
% 'volumenumber'  volume-number to insert, for 4D-volume: select index of volume in 4th dimension
%                 default:
% 'force3D'       force output to be a 3D-NIFTI, if true and 'reffile' is 4D, than only the 1st volume is written as 3D-NIFTI
%
% 'outputname'     name of the written NIFTI-file
%                -explicit name such as 'blob.nii'
%                -or use prefix tag ($p); example:  "_$sreconst" with reffile"t2.nii" ---> "t2_reconst.nii"
%                -or use suffix tag ($s); example:  "$preconst_" with reffile"t2.nii" ---> "reconst_t2.nii"
%
% 'showoutput'    'display hyperlink in cmd-window to visualize overlay of inputfile & outputfile' {0|1}; default: 1
%
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xinsertslice_aligned(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xinsertslice_aligned(1);     % ... open PARAMETER_GUI with defaults
% xinsertslice_aligned(0,z);   % ...run without GUI with specified parametes (z-struct)
% xinsertslice_aligned(1,z);   % ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #ky EXAMPLES
%% ===============================================
%% insert single-slices, detect sliceNo from inputFileName, save as 'test.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = 't2anat.nii';              % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = 't2anat_slice008.nii';     % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%     z.slicenumber  = 'fromsuffix';              % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                       % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                       % % force output to be a 3D-NIFTI
%     z.outputname   = 'test.nii';                % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                       % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert single-slices, detect sliceNo from inputFileName, save as 'CON_t2anat.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = 't2anat.nii';              % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = 't2anat_slice008.nii';     % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%     z.slicenumber  = 'fromsuffix';              % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                       % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                       % % force output to be a 3D-NIFTI
%     z.outputname   = '$pCON_';                  % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                       % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert 2 slices, detect sliceNo from inputFileName, save as '2anat_CON.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = { 't2anat.nii' };              % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = { 't2anat_slice008.nii'        % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%         't2anat_slice009.nii' };
%     z.slicenumber  = 'fromsuffix';                  % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                           % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                           % % force output to be a 3D-NIFTI
%     z.outputname   = '$s_CON.nii';                  % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                           % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert 2 slices, explicitely set sliceNumber, save as 'test.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = { 't2anat.nii' };              % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = { 't2anat_slice008.nii'        % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%                        't2anat_slice009.nii' };
%     z.slicenumber  = [8  9];                        % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                           % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                           % % force output to be a 3D-NIFTI
%     z.outputname   = 'test.nii';                    % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                           % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert 4 slices, detect sliceNo from inputFileName, save as 'adc_constr.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = 'adc.nii';                % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = { 'adc_01_001.nii'        % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%                        'adc_01_002.nii'
%                        'adc_01_003.nii'
%                        'adc_01_004.nii' };
%     z.slicenumber  = 'fromsuffix';             % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                      % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                      % % force output to be a 3D-NIFTI
%     z.outputname   = '$s_constr';              % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                      % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert all slices from 1st volume, detect sliceNo from inputFileName, save as 'test.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = 'adc.nii';            % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = '^adc_01_.*.nii';     % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%     z.slicenumber  = 'fromsuffix';         % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = [1];                  % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [1];                  % % force output to be a 3D-NIFTI
%     z.outputname   = 'test.nii';           % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                  % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
%% ===============================================
%% insert all slices from all volumes, detect sliceNo and volumeNI from inputFileName,
%% save as 'test4D.nii' ( 3D-nifti)
%     z=[];
%     z.reffile      = 'adc.nii';          % % (<<) SELECT reference file (3D/4D)
%     z.insertfiles  = '^adc_0.*.nii';     % % (<<) SELECT 2D-files to insert (or use file-filter, see example)
%     z.slicenumber  = 'fromsuffix';       % % select slice-number to insert   (EXAMPLES: [1], [23], '[1:2:end-4]',[1:3],'all','end','end-2:end')
%     z.volumenumber = 'fromsuffix';       % % select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)
%     z.force3D      = [0];                % % force output to be a 3D-NIFTI
%     z.outputname   = 'test4D.nii';       % % name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options
%     z.showoutput   = [1];                % % display hyperlink in cmd-window to visualize overlay of inputfile & outputfile
%     xinsertslice_aligned(0,z);
% 
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function xinsertslice_aligned(showgui,x,pa)





%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%% get unique-files from all data
% pa=antcb('getsubjects'); %path
% v=getuniquefiles(pa);
[tb tbh v]=antcb('getuniquefiles',pa);



% ==============================================
%%   PARAMETER-gui
% ===============================================
% <BODY bgcolor="green">
%     '<html>[reffile]+$s+suffixString, tag:"_$sreconst"<font color=fuchsia>, example: "t2_reconst.nii"</FONT></HTML>'      , '_slice$s';...

outname_opt={...
    'use own name [add output filename]                            '        , '_test.nii' ;...
    '<html>referenceFile+suffix ($s+''string''):  <font color=fuchsia>, example: "_$sreconst"  &#x2192;  "t2_reconst.nii"'      , '_$sreconst';...
    '<html>prefix+referenceFile ($p+''string''):  <font color=fuchsia>, example: "$preconst_"  &#x2192;  "reconst_t2.nii"'      , '$preconst_';...
    };



if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** Insert 2D-SLICES keep aligned with reference file  ****     '         '' ''
    'reffile'        ''             '(<<) SELECT reference file (3D/4D) '  {@selectfile,v,'single'}
    'insertfiles'    ''             '(<<) SELECT 2D-files to insert (or use file-filter, see example)'  {@selectfile,v,'multi'}
    'slicenumber'    'fromsuffix'   'select slice-number to insert   (EXAMPLES: [1], [23], ''[1:2:end-4]'',[1:3],''all'',''end'',''end-2:end'')     '  {'fromsuffix','1', '1:28'}
    'volumenumber'   1              'select volume-number to insert, for 4D-volume: select index of volume in 4th dimension (default: 1)'    {'fromsuffix',1}
    'force3D'        1              'force output to be a 3D-NIFTI'  'b'
    'inf1' '' '' ''
    'outputname'     'test.nii'     'name of the outputfile or use prefix tag ($p) or suffix tag ($s). See left icon for options'   outname_opt
    'showoutput'     1              'display hyperlink in cmd-window to visualize overlay of inputfile & outputfile' 'b'
    };
p=paramadd(p,x);%add/replace parameter
if showgui==1%% show GUI
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title',['Insert 2D-SLICES, aligned (' mfilename '.m)' ],'info',{@uhelp, [mfilename '.m']});
    if isempty(m);    return ;    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   batch
% ===============================================
xmakebatch(z,p, mfilename);


%———————————————————————————————————————————————
%%   SUB  PROCESS
%———————————————————————————————————————————————
cprintf('[0 0 1]',[ repmat(char(hex2dec('2580')),[1 200]) '\n'] );
cprintf('*[0 0 1]',[ ' Insert 2D-slices... \n'] );
mdirs      =cellstr(pa);
z.insertfiles=cellstr(z.insertfiles);

for i=1:length(mdirs)
    z.mdir    =mdirs{i};
    z.ianimal =i;
    
    %cprintf('[0 .5 0]',[ ' [' num2str(i) '/'  num2str(length(mdirs)) ']: ' strrep(z.mdir,filesep,[filesep filesep])  '\n'] );
    %cprintf('[0 .5 0]',[ repmat(char(hex2dec('2580')),[1 2000]) 'eeee\n'] );
    %clc; for i=2000:4000; disp([char(hex2dec(num2str(i))) ', ' num2str(i) ]); end
    
    showinfo2([  repmat([char(hex2dec('02192')) ' '],[1 3]) ' [' num2str(i) '/'  num2str(length(mdirs)) ']:' ],z.mdir);
    insertSlice_call(z);
end
cprintf('*[0 0 1]',[ ' Done\n'] );




function z=obtain_slice_and_volNR(z)
%% ===============================================
if ischar(z.slicenumber)
    if strcmp(z.slicenumber,'fromsuffix')==1
        [pam name ext]=fileparts2(z.insertfiles);
        num=[];
        for i=1:length(name)
            try
                num(i,1)=str2num(regexprep(name{i}(max(strfind(name{i},'_'))+1:end),'\D',''));
            end
        end
        if isempty(num) || length(num)~=length(name)
            error('could not obtain sliceNumber from fileNameSuffix of reference-file')
        end
        z.slicenumber=num;
    end
end
if ischar(z.volumenumber)
    if strcmp(z.volumenumber,'fromsuffix')==1
        [pam name ext]=fileparts2(z.insertfiles);
        vnum=[];
        for i=1:length(name)
            nus=strfind(name{i},'_');
            if length(nus)>1
                try
                    vnum(i,1)=str2num(regexprep(name{i}(nus(end-1)+1:nus(end)-1),'\D',''));
                end
            end
        end
        if isempty(vnum) || length(vnum)~=length(name)
            error('could not obtain volumeNumber from fileNameSuffix of reference-file')
        end
        z.volumenumber=vnum;
    end
end
%% ===============================================
function z=file_filter(z);
if  ~isempty(   regexpi2(cellstr(z.insertfiles),'*|\^|\$')  )
    [fis] = spm_select('List',z.mdir,z.insertfiles);fis=cellstr(fis);
    z.insertfiles=fis;
    disp([' ... using filter: ' num2str(length(fis)) ' files found:' strjoin(fis,'|')  ]);
end

%% ===============================================
function insertSlice_call(z)

%% ===============================================
z.reffile=char(z.reffile);
% z.file=char(z.file);

z=file_filter(z);
z=obtain_slice_and_volNR(z);

%% ===============================================


fr=fullfile(z.mdir,z.reffile);

% [ha a]=rgetnii(fr);
[h0]=spm_vol(fr);
ha=h0(1);
x=zeros((ha.dim));


for i=1:length(z.insertfiles)
    f1=fullfile(z.mdir,z.insertfiles{i});
    [hb b]=rgetnii(f1);
    if     length(z.volumenumber)==1;       volnr=z.volumenumber;
    else                                    volnr=z.volumenumber(i);
    end
    
    slicenr=z.slicenumber(i);
    x(:,:,slicenr,volnr)=b;
end
%% ===============================================

% =====[save]==========================================
[ pax, refname ext1  ]=fileparts(z.reffile);

outname=z.outputname;
if ~isempty(strfind(outname,'$p'))
    outname=  [strrep(outname, '$p' ,'')  refname];
end
outname=strrep(outname, '$s' ,refname);
% outname=strrep(outname, '$p' ,refname);


[ pax, outname ext  ]=fileparts(outname);
if isempty(outname); outname='_test.nii'; end

fout=fullfile(z.mdir,[outname '.nii']);
%% ===============================================

if z.force3D==1
    if ndims(x)>3
        disp(['reffile has ' num2str(length(h0)) ' volumes but "z.force3D" is [1], thus keep 1st volume and write 3D-NIFTI ']);
        x=x(:,:,:,1);
    end
end

if size(x,4)==1
    hv=ha;  %3D
else
    hv=h0; %4D
end

try; delete(fout); end
rsavenii(fout, hv, x, 64);

if z.showoutput==1
    showinfo2(['new ' num2str(ndims(x)) 'D-NIFTI:'],fr,fout,13);
end

%% ===============================================



%
%
%
% return
%
% f1=fullfile(z.mdir,z.file  );
%
%
%
%
% if ischar(z.slicenumber)
%     h=spm_vol(f1);
%     h=h(1);
%     if strcmp(z.slicenumber,'all')==1
%         z.slicenumber=[1: h.dim(3)];
%     elseif ~isempty(strfind(z.slicenumber,'end'))
%         eval(['z.slicenumber=[' strrep(z.slicenumber,'end',num2str(h.dim(3))) '];']);
%     end
% end
% if ischar(z.volumenumber)
%     h=spm_vol(f1);
%     if strcmp(z.volumenumber,'all')==1
%         z.volumenumber=[1: length(h)];
%     elseif ~isempty(strfind(z.volumenumber,'end'))
%         eval(['z.volumenumber=[' strrep(z.volumenumber,'end',num2str(length(h))) '];']);
%     end
% end
%
% %% =====[outputname-filter]========================
% for i=1:length(z.volumenumber)
%     fileout={};
%     for j=1:length(z.slicenumber)
%         [pam infilename ]=fileparts(z.file);
%         [~, outnameTag ]=fileparts(z.outputname);
%         if isempty(regexpi(outnameTag,'\$'));
%             d=[ outnameTag  ];
%         else
%             d=[infilename outnameTag  ];
%         end
%         d=regexprep(d,'\$s',pnum(z.slicenumber(j),3));
%         d=regexprep(d,'\$v',pnum(z.volumenumber(i),2));
%         outName=d;
%         if isempty(outName);
%             outName=[infilename '_' pnum(z.volumenumber(j),2) '_' pnum(z.slicenumber(i),3)  ];
%         end
%         outName=[outName '.nii'];
%         FPoutName=fullfile(z.mdir, outName);
%         %disp(FPoutName);
%         fileout{end+1,1}=FPoutName;
%     end
%
%     fout=extract_slice(f1,fullfile(z.mdir,'___temp.nii'),z.slicenumber,z.volumenumber(i),0);
%     %rename files
%     movefilem(fout(1:length(fileout)),fileout );
%
%     if z.showoutput==1
%         for j=1:length(fileout)
%             showinfo2('extract slice: ',f1,fileout{j},13);
%         end
%     end
%
% end
%
% %% ===============================================
%
%






% %
% % %———————————————————————————————————————————————
% % %%   SUB  PROCESS
% % %———————————————————————————————————————————————
% %
% % function task(mdir,g)
% %
% % %% READ FILE, deal with 4d
% % g.file=g.file{1};
% % file=fullfile(mdir,g.file);
% %
% % if exist(file)~=2; return; end
% %
% % [ha a]=rgetnii(file);
% % ha = ha(g.volumenumber);
% % a  = a(:,:,:,g.volumenumber);
% %
% % %% DIMENSION TO SLICE
% % if     strcmp(lower(g.slicedim),'x'); slicedim=1;
% % elseif strcmp(lower(g.slicedim),'y'); slicedim=2;
% % elseif strcmp(lower(g.slicedim),'z'); slicedim=3;
% %
% % elseif strcmp(lower(g.slicedim),'allen') ; slicedim=2;
% % elseif strcmp(lower(g.slicedim),'native'); slicedim=3;
% % end
% %
% %
% %
% % %% convert slicenumber
% % % g.slicenumber ='1:3:end'
% % %
% % % g.slicenumber ='[end-1:end]'
% % % g.slicenumber ='end'
% % % g.slicenumber ='[end-4 end]'
% % % g.slicenumber =1:1:7
% % % g.slicenumber =3
% %
% % if isnumeric(g.slicenumber )
% %     sl=[ '[' num2str(g.slicenumber)  ']' ];
% % elseif ischar(g.slicenumber )
% %     sl=g.slicenumber;
% % end
% %
% % if strcmp(lower(sl),'all')           % ALL SLICES
% %     sl=[ '[' num2str([1:size(a,slicedim)])  ']' ];
% % end
% %
% % %% extract data (d) and get real slice index (sno)
% % if slicedim==1;     eval(['d   =  a(' sl  ',  :    ,:        );'       ]);      end
% % if slicedim==2;     eval(['d   =  a(:      ,' sl ' ,:        );'       ]);      end
% % if slicedim==3;     eval(['d   =  a(:      ,  :    , '  sl ' );']);      end
% %
% % svec=1:size(a,slicedim);
% % eval(['sno = svec('  sl ' );']);
% %
% %
% % %% LOOP
% % disp('[read out SINGLE SLICE] busy..');
% % for i=1:length(sno)
% %     fout=fullfile(mdir, stradd(g.file,['_Slice' pnum(sno(i),3)],2) );
% %
% %     hd=ha;
% %     %hd.dim=[hd.dim(1:2) 1]
% %     hd.dim=hd.dim;
% %     hd.dim(slicedim)=1;
% %     hd.n  =[1 1];
% %
% %     mat=ha.mat;
% %
% %     if g.iscolocated==0
% % %         %%%%of=[0:ha.dim(3)-1].*ha.mat(3,3)+ha.mat(3,4)+ha.mat(3,3)/2
% % %         of=[1:ha.dim(3)].*ha.mat(3,3)+ha.mat(3,4)-ha.mat(3,3)
% % %         mat(3,4)=of(sno(i))
% %
% %         of=[1:ha.dim(slicedim)].*ha.mat(slicedim,slicedim)+ha.mat(slicedim,4)-ha.mat(slicedim,slicedim);
% %         mat(slicedim,4)=of(sno(i));
% %     end
% %
% %
% %     hd.mat=mat;
% %     if     slicedim==1 ; dx=d(i,:,:);
% %     elseif slicedim==2 ; dx=d(:,i,:);
% %     elseif slicedim==3 ; dx=d(:,:,i);
% %     end
% %
% %     %hd.mat
% %     rsavenii(fout,hd, (dx));
% %
% %     try
% %         if i==1
% %         disp(['2d-registered image: <a href="matlab: explorerpreselect(''' ...
% %             fout ''')">' fout '</a>']);
% %         end
% %     end
% %
% % end
% %
% %
% % disp('done');




% % % % %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % % % %________________________________________________
% % % % %%  generate list of nifit-files within pa-path
% % % % %________________________________________________
% % % % function v=getuniquefiles(pa)
% % % % % keyboard
% % % % % global an
% % % % % pa=antcb('getallsubjects'); %path
% % % % % pa=antcb('getsubjects'); %path
% % % %
% % % % li={};
% % % % fi2={};
% % % % fifull={};
% % % % for i=1:length(pa)
% % % %     [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
% % % %     if ischar(files); files=cellstr(files);   end;
% % % %     fis=strrep(files,[pa{i} filesep],'');
% % % %     fi2=[fi2; fis];
% % % %     fifull=[fifull; files];
% % % % end
% % % % %REMOVE FILE if empty folder found
% % % % idel        =find(cell2mat(cellfun(@(a){[ isempty(a)]},fifull)));
% % % % fifull(idel)=[];
% % % % fi2(idel)   =[];
% % % %
% % % %
% % % % li=unique(fi2);
% % % % [li dum ncountid]=unique(fi2);
% % % % %% count files
% % % % ncount=zeros(size(li,1),1);
% % % % for i=1:size(li,1)
% % % %     ncount(i,1) =length(find(ncountid==i));
% % % % end
% % % % %% get properties spm_vol
% % % % fifull2=fifull(dum);
% % % % tb  = repmat({''},[size(fifull2,1)  ,4]);
% % % % tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
% % % % for i=1:size(fifull2,1)
% % % %     ha=spm_vol(fifull2{i});
% % % %     ha0=ha;
% % % %     ha=ha(1);
% % % %     if length(ha0)==1
% % % %         tb{i,1}='3';
% % % %         tag='';
% % % %     else
% % % %         tb{i,1}='4' ;
% % % %         tag= length(ha0);
% % % %     end
% % % %     tb{i,2}=sprintf('%i ',[ha.dim tag]);
% % % %     tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
% % % %     tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
% % % % end
% % % %
% % % %
% % % % v.tb =[li cellstr(num2str(ncount)) tb];
% % % % v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);
