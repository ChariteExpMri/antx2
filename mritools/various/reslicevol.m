
%     fo='O:\data3\hedermanip\dat\M_1\masklesion.nii'
%     fr='O:\data3\hedermanip\dat\M_1\t2.nii'
%     fs='O:\data3\hedermanip\dat\M_1\hmasklesion.nii'
%     
%     reslicevol(fo,fr,fs)
%     
%     reslicevol(fo,[],fs)
%     
%     
%     [hy yy]=reslicevol(fo);
%     [hy yy]=reslicevol(fo,fr);
%     [hy yy]=reslicevol(fo,fr,fs);

function [hy,yy]=reslicevol(fo,fr,fs)

% if 0
%     fo='O:\data3\hedermanip\dat\M_1\masklesion.nii'
%     fr='O:\data3\hedermanip\dat\M_1\t2.nii'
%     fs='O:\data3\hedermanip\dat\M_1\hmasklesion.nii'
%     
%     reslicevol(fo,fr,fs)
%     reslicevol(fo,[],fs)
%     [hy yy]=reslicevol(fo);
%     [hy yy]=reslicevol(fo,fr);
%     [hy yy]=reslicevol(fo,fr,fs);
%     
% end


if exist('fs')~=1;  fs=[]; end
if exist('fr')~=1;  fr=[]; end


%———————————————————————————————————————————————
%%   appr2   use reference
%———————————————————————————————————————————————
if isempty(fr)~=1
    
    %     clear
    %     fo='O:\data3\hedermanip\dat\M_1\masklesion.nii'
    %     fr='O:\data3\hedermanip\dat\M_1\t2.nii'
    %     fs='O:\data3\hedermanip\dat\M_1\hmasklesion.nii'
    
    
    [hs ss]=rgetnii(fo);
    [hr rr]=rgetnii(fr);
    
    [hy, yy] = nii_reslice_target(hs, ss, hr, 0) ;
    
    
    if ~isempty(fs)
        rsavenii(fs,hy,yy);
    end
    
    %     disp('----');
    %     spm_get_space(fo)
    %     spm_get_space(fr)
    %     spm_get_space(fs)
    
else
    
    %———————————————————————————————————————————————
    %%   appr3   remove minus signs , no ref
    %———————————————————————————————————————————————
    [hs ss]=rgetnii(fo);
    len4=size(hs,1);
    % [hr rr]=rgetnii(fr);
    
    hr=hs(1);
    m=hr.mat;
    mv=spm_imatrix(m);
    
    mx=eye(4);
    dia=ones(1,4);
    dia((diag(m)<0))=-1;
    mx(logical(eye(size(mx)))) =dia;
    hr.mat=mx*m;
    if len4==1
    [hy, yy] = nii_reslice_target(hs, ss, hr, 0) ;
    else
        for i=1:len4
            [hy(i,1), yy(:,:,:,i)] = nii_reslice_target(hs(1), ss(:,:,:,i), hr, 0) ;
            hy(i).n               =   hs(i).n ; 
        end
    end
    
    
    if ~isempty(fs)
        rsavenii(fs,hy,yy);
    end
    
    
    
    
    
end




