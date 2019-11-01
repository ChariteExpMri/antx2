

function  tplfiles=xcreatetemplatefiles(an,forcetooverwrite)



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% FILES to be copied to studies template-folder
tb={...  %% fieldname    newName   interp    dt-type
    'avg' 'AVGT.nii'                                                       1   [64 0] ; %refIMAGE must be first IMAGE
    'refTPM' {'_b1grey.nii' '_b2white.nii' '_b3csf.nii'}  1   [2 0];
    'ano' 'ANO.nii'                                                        0  [64 0] ;
    'fib' 'FIBT.nii'                                                           0  [64 0] ;
    'gwc' 'GWC.nii'                                                       0  [2 0] ;
    };

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if exist('forcetooverwrite')==0
    forcetooverwrite=0;
end

%% create templateFolder
patpl=fullfile(fileparts(an.datpath),'templates');
if exist(patpl)~=7; mkdir(patpl); end



%% copy files with specific voxres
voxres=abs(an.voxsize);
fn=fieldnames(an);



tplfiles=[];

for i=1:size(tb,1)
    id= regexpi2(fn, tb{i,1});
    eval(['f1=an.' fn{id} ';']);
    f2name=tb{i,2};
    dt      =tb{i,4};
    interp=tb{i,3};
    if i==1 %%refIMAGE
        [BB, vox]   = world_bb(f1);
        f2       =fullfile(patpl,f2name);
        
        makefile= imstatus(f2, forcetooverwrite ) ;
        if makefile==1
                 displayx(f2);
                  resize_img5(f1,f2, voxres, BB, [], interp,dt);
        end
        refimage=f2;
        eval(['tplfiles.' fn{id} '=f2;']);
    else
        
        if ~iscell(f1)%%convert to cell
            f1=cellstr(f1);
            f2name=cellstr(tb{i,2});
        end
        for j=1:length(f1)
            f2       =fullfile(patpl,f2name{j});
            if exist(f1{j})~=2 %if not exists
                createfile(struct('tag', fn{id} ,'f1',f1,'f2',f2, 'refimage',refimage,'interp',interp, 'dt',dt,'tb',{tb},'forcetooverwrite',forcetooverwrite) );
            else
                makefile= imstatus(f2, forcetooverwrite ) ;
                if makefile==1
                      displayx( f2);
                           rreslice2target(f1{j}, refimage, f2, interp,dt);
                end
            end
            
            %%outputVARIABLE
            if length(f1)==1
                eval(['tplfiles.' fn{id} '=f2;']);
            else
                eval(['tplfiles.' fn{id} '{j,1}=f2;']);
            end
            
        end
    end
end




%%createfile
function createfile(s)
if strcmp(s.tag,'gwc')
    ano=fullfile(fileparts(s.f2),'ANO.nii');
    fib=fullfile(fileparts(s.f2),'FIBT.nii');
    if exist(ano)==2 && exist(fib)==2
        makefile= imstatus(s.f2, s.forcetooverwrite ) ;
        if makefile==1
            displayx( s.f2);
            xcreateGWC( ano,fib,  s.f2 );
            
        end
    end
end

function makefile=imstatus(f2, forcetooverwrite )
makefile=0;
if forcetooverwrite==1
    makefile=1;
else
    if exist(f2)~=2
        makefile=1;
    else
        makefile=0;
    end
end
% makefile

function displayx(file)
% disp(file);
% file
% file
if iscell(file)==0
    disp(['generate: ' file]);
else
    disp(['generate: ' char(file)]);
end



