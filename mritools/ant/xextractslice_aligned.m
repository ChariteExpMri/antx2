%% extract 2d-slice from 3D/4D-volume, preserve alignment with original file
% - This function extracts one/more 2d slices from a 3d or 4d volume with preserved aligment to original file
% - each single slice is stored in a new nifti, 
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% #b function-name: #lk [xextractslice_aligned]
% ______________________________________________________________________________________________
%
%% #lk PARAMETER:
% 'file'           - nifti-file, to extract slice(s) (example: t2.nii) 
%                  - nifti-volume is 3D or 4D
% 'slicenumber'    - index of the slice(s) to extract   
%                  EXAMPLES: [1]        : 1st slice,             [1:3]      : slices 1 to 3
%                           '[1:2:end]' : every 2nd slice        'all'      : all slices
%                           'end'       : last slice             'end-2:end': last three slices
% 'volumenumber'   - index of volume  (4th dimension) ; default: 1 
%                  EXAMPLES: [1]        : 1st volume,             [1:3]      : volume 1 to 3 
%                           'end'       : last volume,            'end-2:end': last three volumes
%                           'all'       : all volumes,            '[1:2:end]': every 2nd volume 
% 'outputname'     'name of the outputfile (See left icon in GUI for options and output examples)
%                 options: 
%                 '_slice$s'       : [filename]+'_slice'+[sliceNo]                ; example: 't2_slice001.nii'  (default)
%                 '$s'             : [filename]+[_sliceNo]                        ; example: 't2_001.nii'
%                 '_vol$v_slice$s' : [filename]+'_vol'+[volNo]+'_slice'+[sliceNo] ; example: 't2_vol01_slice001.nii'
%                 '_$v_$s'         : [filename]+[volumeNo]+[sliceNo]              ; example: 't2_01_001.nii'
%                 'myOutput.nii'   : an arbitrary filename, output-filename os overwritten if more than 1 slice is is extracted         
% 'showoutput'    'display hyperlink in cmd-window to visualize overlay of inputfile & outputfile' {0|1}; default: 1
% 
%
% ______________________________________________________________________________________________
%% #lk RUN-def:
% xextractslice_aligned(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xextractslice_aligned(1);     % ... open PARAMETER_GUI with defaults
% xextractslice_aligned(0,z);   % ...run without GUI with specified parametes (z-struct)
% xextractslice_aligned(1,z);   % ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #lk EXAMPLES
%% ======[3Dim]=========================================
%% extract slices 3 and 4, saved as 't2anat_slice003.nii' & 't2anat_slice004.nii'
% z=[];                                                                                                                                           
% z.file         = 't2anat.nii';      % % (<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)                                                
% z.slicenumber  = [3 4];       % % select slice number to extract                                                                          
% z.volumenumber = [1];               % % if file is a 4D-volume: select index of volume in 4th dimension (default: 1)                            
% z.outputname   = '_slice$s';        % % name of the outputfile (see left icon)                                                                  
% z.showoutput   = [1];               % % display hyperlink to visualize overlay of output with orig.file                                         
% xextractslice_aligned(0,z);  
%% ======[3Dim]=========================================
%% extract every 3rd slice to lastslice-5  , saved as 't2anat_slice001.nii','t2anat_slice004.nii'...'t2anat_slice031.nii'
% z=[];                                                                                                                                           
% z.file         = 't2anat.nii';      % % (<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)                                                
% z.slicenumber  = '1:3:end-5';       % % select slice number to extract                                                                          
% z.volumenumber = [1];               % % if file is a 4D-volume: select index of volume in 4th dimension (default: 1)                            
% z.outputname   = '_slice$s';        % % name of the outputfile (see left icon)                                                                  
% z.showoutput   = [1];               % % display hyperlink to visualize overlay of output with orig.file                                         
% xextractslice_aligned(0,z);  
%% ======[3Dim]=========================================
%% extract last slice, saved as 't2anat_slice038.nii'
% z=[];                                                                                                                                           
% z.file         = 't2anat.nii' ;     % % (<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)                                                
% z.slicenumber  = 'end';             % % select slice number to extract                                                                          
% z.volumenumber = [1];               % % if file is a 4D-volume: select index of volume in 4th dimension (default: 1)                            
% z.outputname   = '_slice$s';        % % name of the outputfile (see left icon)                                                                  
% z.showoutput   = [1];               % % display hyperlink to visualize overlay of output with orig.file                                         
% xextractslice_aligned(0,z);  
%% ======[4Dim]=========================================
%% extract all slices from last volume (5th volume) --> saved as 'adc_05_001.nii'--to -- 'adc_05_038.nii'
% z=[];                                                                                                                                           
% z.file         = 'adc.nii'  ;         % % (<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)                                                
% z.slicenumber  = 'all';               % % select slice number to extract                                                                          
% z.volumenumber = 'end';               % % if file is a 4D-volume: select index of volume in 4th dimension (default: 1)                            
% z.outputname   = '_$v_$s';            % % name of the outputfile (see left icon)                                                                  
% z.showoutput   = [1];                 % % display hyperlink to visualize overlay of output with orig.file                                         
% xextractslice_aligned(0,z);  
%% ======[4Dim]=========================================
%% extract all slices from last volume (5th volume) --> saved as 'adc_05_001.nii'--to -- 'adc_05_038.nii'
% z=[];                                                                                                                                           
% z.file         = 'adc.nii'    ;       % % (<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)                                                
% z.slicenumber  = 'all';               % % select slice number to extract                                                                          
% z.volumenumber = 'end';               % % if file is a 4D-volume: select index of volume in 4th dimension (default: 1)                            
% z.outputname   = '_$v_$s';            % % name of the outputfile (see left icon)                                                                  
% z.showoutput   = [1];                 % % display hyperlink to visualize overlay of output with orig.file                                         
% xextractslice_aligned(0,z);                                                                                                                                                
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function xextractslice_aligned(showgui,x,pa)

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
outname_opt={...
    '<html>[filename]+"_slice"+[sliceNo] <font color=fuchsia>; tag:"_slice$s"<font color=green>; example: "t2_slice001.nii"'      , '_slice$s';...
    '<html>[filename]+[_sliceNo]<font color=fuchsia>; tag:"_$s"<font color=green>example: "t2_001.nii">                        [_$s]'           , '_$s';...
    '<html>[filename]+"_vol"+[volNo]+"_slice"+[sliceNo] <font color=fuchsia>; tag:"_vol$v_slice$s"<font color=green>; example: "t2_vol01_slice001.nii"', '_vol$v_slice$s';...
    '<html>[filename]+[volumeNo]+[sliceNo]<font color=fuchsia>; tag:"_$v_$s"<font color=green>; example: "t2_01_001.nii"'        , '_$v_$s';...
    '<html>use my own name [please modify filename here]                            '        , '_test.nii' ;...
    };

if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** EXTRACT 2D-SLICES keep alignment with orig. file  ****     '         '' ''
    'file'          ''            '(<<) SELECT IMAGE, to extract 2D-slice (example: t2.nii)'  {@selectfile,v,'single'}
    'slicenumber'    1            'select slice number to extract   (EXAMPLES: [1], [23], ''[1:2:end-4]'',[1:3],''all'',''end'',''end-2:end'')     '  {'all',1,2,3,'end',['1:2:end']}
    'volumenumber'   1            'if file is a 4D-volume: select index of volume in 4th dimension (default: 1)'    ''
    'inf1' '' '' ''
    'outputname'     '_slice$s'   'name of the outputfile: {''_slice$s'' (default) |''$s''|''_$v_$s''|''_vol$v_slice$s''|''myOutput.nii''}. See left icon for options'   outname_opt
    'showoutput'     1            'display hyperlink in cmd-window to visualize overlay of inputfile & outputfile' 'b'
   };
p=paramadd(p,x);%add/replace parameter
if showgui==1%% show GUI
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title',['EXTRACT 2D-SLICES, aligned (' mfilename '.m)' ],'info',{@uhelp, [mfilename '.m']});
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

% ==============================================
%%   SUB  PROCESS
% ===============================================
cprintf('[0 0 1]',[ repmat(char(hex2dec('2580')),[1 200]) '\n'] );
cprintf('*[0 0 1]',[ ' Extract slice... \n'] );
mdirs=cellstr(pa);
for i=1:length(mdirs)
    z.mdir    =mdirs{i};
    z.ianimal =i;
    
   %cprintf('[0 .5 0]',[ ' [' num2str(i) '/'  num2str(length(mdirs)) ']: ' strrep(z.mdir,filesep,[filesep filesep])  '\n'] );
   %cprintf('[0 .5 0]',[ repmat(char(hex2dec('2580')),[1 2000]) 'eeee\n'] );
   %clc; for i=2000:4000; disp([char(hex2dec(num2str(i))) ', ' num2str(i) ]); end

   showinfo2([  repmat([char(hex2dec('02192')) ' '],[1 3]) ' [' num2str(i) '/'  num2str(length(mdirs)) ']:' ],z.mdir);
    extractSlice_call(z);
end
cprintf('*[0 0 1]',[ ' Done\n'] );

% ==============================================
%%   extract slice
% ===============================================
function extractSlice_call(z)

z.file=char(z.file);
f1=fullfile(z.mdir,z.file  );

if ischar(z.slicenumber)  
    h=spm_vol(f1);
    h=h(1);
    if strcmp(z.slicenumber,'all')==1
        z.slicenumber=[1: h.dim(3)];
    elseif ~isempty(strfind(z.slicenumber,'end'))
        eval(['z.slicenumber=[' strrep(z.slicenumber,'end',num2str(h.dim(3))) '];']);
    end
end
if ischar(z.volumenumber) 
    h=spm_vol(f1);
    if strcmp(z.volumenumber,'all')==1
        z.volumenumber=[1: length(h)];
    elseif ~isempty(strfind(z.volumenumber,'end'))
        eval(['z.volumenumber=[' strrep(z.volumenumber,'end',num2str(length(h))) '];']);
    end
end

%% =====[outputname-filter]========================
for i=1:length(z.volumenumber)
    fileout={};
    for j=1:length(z.slicenumber)
        [pam infilename ]=fileparts(z.file);
        [~, outnameTag ]=fileparts(z.outputname);
        if isempty(regexpi(outnameTag,'\$'));
            d=[ outnameTag  ];
        else
            d=[infilename outnameTag  ];
        end
        d=regexprep(d,'\$s',pnum(z.slicenumber(j),3));
        d=regexprep(d,'\$v',pnum(z.volumenumber(i),2));
        outName=d;
        if isempty(outName);
            outName=[infilename '_' pnum(z.volumenumber(j),2) '_' pnum(z.slicenumber(i),3)  ];
        end
        outName=[outName '.nii'];
        FPoutName=fullfile(z.mdir, outName);
        %disp(FPoutName);
        fileout{end+1,1}=FPoutName;
    end
   
    fout=extract_slice(f1,fullfile(z.mdir,'___temp.nii'),z.slicenumber,z.volumenumber(i),0);
    %rename files
    movefilem(fout(1:length(fileout)),fileout );
    
    if z.showoutput==1
        for j=1:length(fileout)
            showinfo2('extract slice: ',f1,fileout{j},13);
        end
    end
    
end

%% ===============================================








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
