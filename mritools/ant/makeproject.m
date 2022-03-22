
% make ANTX project via commandline
% makeproject(varargin)
% -[1]--SAVE PROJECT-FILE WITH SPECIFIED PARAMETERS -------
% mandatory pairwise inputs
% 'pojectname'       -fullpath-name of the project (m-file) or study folder for analyis 
%                      -example: 
%                       - fullfile(pwd,'projA.m')
%                       - a directory such as: pwd  -> this will create the projectfile 'proj.m'
% 'voxsize'           -voxel size (default for Allen Mouse: [.07 .07 .07])  
% 'wa_refpath'        -path of the used reference system (such as "O:\anttemplates\mouse_spmmouse" for "mouse_spmmouse" )                                               
% 'wa_species'        -animal species to investigate {mouse or rat}                                                                                                     
% 
% 
% optional: additonal pairwise inputs                                                                                              voxel size (default for Allen Mouse: [.07 .07 .07])
% wa_BiasFieldCor         perform initial bias field correction (only needed if initial skullstripping failes)
% wa_usePriorskullstrip   use a priori skullstripping (used for automatic registration)
% wa_fastSegment          faster segmentation by cutting boundaries of t2.nii [0,1]
% wa_orientType           index from ReorientationTable (see: help findrotation2) to rougly match inputVol and "AllenSpace-template" (example [1]Berlin,[5]Munich/Freiburg)
% wa_orientelxParamfile   single Parameter file for rough Rigid-body registration; default: "trafoeuler2.txt"; use trafoeuler3.txt for large dislocations
% wa_elxMaskApproach      used registration approach..click icon for further information
% wa_elxParamfile         ELASTIX Parameterfiles, fullpath of either Par0025affine.txt+Par0033bspline_EM2.txt  or par_affine038CD1.txt+par_bspline033CD1.txt
% 
% 
%% examples with WITH SPECIFIED PARAMETERS 
% makeproject('projectname',fullfile(pwd,'projA.m'), 'voxsize',[.07 .07 .07],'wa_refpath','F:\anttemplates\mouse_Allen2017HikishimaLR','wa_species','mouse')
% makeproject('projectname',pwd, 'voxsize',[.07 .07 .07],'wa_refpath','F:\anttemplates\mouse_Allen2017HikishimaLR','wa_species','mouse')
%
% -[2]--SAVE AN UNSPECIFIED PROJECT-FILE-------
% save a default project-file
% WARNING: The following parameters has to be defined later in the mfile:
%  voxsize,wa.refpath, wa.species
%% EXAMPLE
% makeproject('projectname',fullfile(pwd,'projB.m'));
% 
% ---------------------------------
% 

%


function makeproject(varargin)

if 0

  makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[.07 .07 .07],'wa_refpath','F:\anttemplates\mouse_Allen2017HikishimaLR','wa_species','mouse')
 
  makeproject('projectname',pwd, 'voxsize',[.07 .07 .07],'wa_refpath','F:\anttemplates\mouse_Allen2017HikishimaLR','wa_species','mouse')
%
end

p=struct();
if nargin==0; 
    help([mfilename]);
   return 
else
    %% ===============================================
    
    p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    if ~isfield(p,'projectname')
       help([mfilename]); 
       return
    end
    
    projectname=p.projectname; %project name/path
    [datproj projname, ext]=fileparts(projectname);
    if isempty(ext)
        projname='proj';
        ext     ='.m';
        datproj =projectname;
        projectname=fullfile(datproj,[ projname ext ]);
    end
    p=rmfield(p,'projectname');
    
    p.datpath=fullfile(datproj,'dat') ;%adding datapath
    fn=fieldnames(p);
    ix=regexpi2(fn,'^wa_');  % remodel the "wa"-paramter
    fn2=fn(ix);
    fn3=regexprep(fn2,'^wa_','');
    if ~isempty(fn2)
        wa=struct();
        for i=1:length(ix)
            var=getfield(p,fn2{i});
            wa=setfield(wa,fn3{i},var);
            p=rmfield(p,fn2{i});
            
        end
        p.wa=wa;
    end
    %% ======[checks]=========================================
    msg={''};
    if length(fn)>1
        chk=zeros(1,4);
        if isfield(p,'datpath')==1;    chk(1)=1; end
        if isfield(p,'voxsize')==1;     chk(2)=1; end
        if isfield(p.wa,'refpath')==1;  chk(3)=1; end
        if isfield(p.wa,'species')==1;  chk(4)=1; end
        
        if sum(chk)~=4 %error
            disp('the following fiels has to be defined: ');
            disp(' project, voxsize, refpath,species ');
            disp('<a href="matlab:uhelp(''makeproject'')">see help of "makeproject"</a>')
            error('fields ht to be defined');
        end
    else
      msg=' WARNING: parameter project-file not defined...parameter have to be set later!'  ;
    end
    %% ===============================================

    
end


% ==============================================
%%   
% ===============================================
% clear all
% p.datpath=fullfile(pwd,'dat')
% p.wa.elxParamfile={'klasue' 'maus'}
% p.wa.BiasFieldCor=888

[w1 p0 cc ]=antconfig(0);
p0=rmfield(p0,'ls');
% p1=catstruct(p0,p)
% p2=catstruct(p,p0)
% k=paramadd(p0,p)
p0=rmfield(p0,'templatepath');
[p1 p1s]=catstruct2(p0,p);
p1=orderfields(p1,p0);


q=struct2list3(p1,cc,'x');
f1=projectname ;%fullfile(pwd,'proj.m')
pwrite2file(f1,q);

% disp('created projectfile: ' )
showinfo2('created projectfile',f1);
% edit(f1)

warning off
mkdir(p.datpath);

if ~isempty(char(msg))
    disp(msg);
end


% ==============================================
%%   
% ===============================================
% 
% w2=rmfield(w2,'ls')
% fn=fieldnames(w2)
% badfields=fn(regexpi2(fn,'^inf\d+'))
% x=rmfield(w2,badfields)
% s=struct2list(x)
% 
% f1=fullfile(pwd,'projA.m')
% pwrite2file(f1,s)
% 
% 
% 
% % x.project               =  'NEW PROJECT';                                                                                                              
% % x.datpath               =  'F:\data5\nogui\dat';                                                                                                       
% % x.voxsize               =  [0.07  0.07  0.07];                                                                                                         
% %                             x.wa.BiasFieldCor=       [0];                                                                                              
% %                             x.wa.usePriorskullstrip= [1];                                                                                              
% %                             x.wa.fastSegment=        [1];                                                                                              
% %                             x.wa.orientType=         [1];                                                                                              
% % x.wa.orientelxParamfile =  'f:\antx2\mritools\elastix\paramfiles\trafoeuler5.txt';                                                                     
% % x.wa.elxMaskApproach    =  [1];                                                                                                                        
% % x.wa.elxParamfile       =  { 'f:\antx2\mritools\elastix\paramfiles\Par0025affine.txt' 	'f:\antx2\mritools\elastix\paramfiles\Par0033bspline_EM2.txt' };
% %                             x.wa.cleanup=            [1];                                                                                              
% %                             x.wa.usePCT=             [2];                                                                                              
% %                             x.wa.refpath=            'MUST_BE_DEFINED';                                                                                
% %                             x.wa.species=            'mouse';                                                                                          
% %                             x.wa.tf_t2=              [1];                                                                                              
% %                             x.wa.tf_avg=             [1];                                                                                              
% %                             x.wa.tf_ano=             [1];                                                                                              
% %                             x.wa.tf_c1=              [0];                                                                                              
% %                             x.wa.tf_c2=              [0];                                                                                              
% %                             x.wa.tf_c3=              [0];                                                                                              
% %                             x.wa.tf_c1c2mask=        [0];                                                                                              
% % x.templatepath          =  'F:\data5\nogui\templates';   