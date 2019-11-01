

function xresizeAtlas(   voxres )




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%          [1]       gui params 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
gui=[0 ];
 if exist('voxres')~=1 || isempty(voxres)     ;                                  gui=1;      voxres =[.07 .07 .07];                             end

 if any(gui)==1
     prompt = {     'Resolution (voxsize)'     };
     dlg_title = 'Inputs for DEFORM';
     num_lines = 1;
     def = {  '.07 .07 .07'   };
     answer = inputdlg(prompt,dlg_title,num_lines,def);
     if isempty(answer);    return             ; end
         resolution=  str2num(answer{1}) ;
 end


[pathx s]=antpath;
% voxres=[.07 .07 .07]

 disp('resize: AVGT,ANO, FIBT');

%% AVGT
fin=s.avg;
[pa fi ext]=fileparts(fin);
fout=fullfile(pa, [ 's' fi  ext]);
% --------
[bb vox]=world_bb(fin);
resize_img5(fin,fout, voxres, bb, [], 1,[]);   

%% ANO
fin=s.ano;
[pa fi ext]=fileparts(fin);
fout=fullfile(pa, [ 's' fi  ext]);
% --------
[bb vox]=world_bb(fin);
resize_img5(fin,fout, voxres, bb, [], 0,[]);   


%% FIBT
fin=s.fib;
[pa fi ext]=fileparts(fin);
fout=fullfile(pa, [ 's' fi  ext]);
% --------
[bb vox]=world_bb(fin)
resize_img5(fin,fout, voxres, bb, [], 0,[]);   