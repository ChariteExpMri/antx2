
function [sv]=pclustermaximaContraint(Z,A,XYZ,hdr,Num,Dis,invertZ)

%number of maxima pr cluster and distance among cluster  copy of [spm_list ~line 204]
% 
% function [sv]=pclustermaximaContraint(Z,A,XYZ,hdr,Num,Dis)
% NOTE: usage after applying [pclustermaxima]
% IN
%     Z   [vector] (Z,T  but not p!)
%     A   [vector]regnr: [254x1 double] region number
%     XYZ [3xNvox double] locations [x y x]' {in voxels}
%     hdr header
%       Num    default(3)        % number of maxima per cluster
%       Dis    default(8)        % distance among clusters (mm)
% OUT
%       idx: [33x1 double]  indices
%        tb: [33x6 double]  table [xyzmm(3cols) clusterIndex Zvector  idx]
%         Z: [1x33 double]  survived Zvector
%         A: [33x1 double]  survived region number
%       XYZ: [33x1 double]  ..
%     XYZmm: [33x1 double] ..
%       hdr: [1x1 struct]  ...
% EXAMPLE: contrainscluster with max N<=3 max per cluster with distance of 8mm
%    [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8)




if 0
 Z  =sm.Z ;
 A  =sm.regnr ;
 XYZ=sm.XYZ  ;
 hdr=sm.hdr;
 Num=3
 Dis=8
end
 
    if 1 strcmp(invertZ,'invert')
        Z=-Z;
    end

Z2=Z;%copy to be used later
 
%   XYZmm2=sm.XYZmm
M=hdr.mat;
XYZmm = M(1:3,:)*[XYZ; ones(1,size(XYZ,2))];
 
 
 
 test=sortrows([XYZmm' A Z(:)],4);
 %-Local maxima p-values & statistics
    %----------------------------------------------------------------------
%     HlistXYZ = [];
tb=[];
    while numel(find(isfinite(Z)))



        %-Find largest remaining local maximum
        %------------------------------------------------------------------
        [U,i]   = max(Z);           % largest maxima
        j       = find(A == A(i));  % maxima in cluster


%         %-Compute cluster {k} and peak-level {u} p values for this cluster
%         %------------------------------------------------------------------
%         if STAT ~= 'P'
%             Nv      = N(i)/v2r;                       % extent {voxels}
%             
%             Pz      = spm_P(1,0,   U,df,STAT,1,n,S);  % uncorrected p value
%             Pu      = spm_P(1,0,   U,df,STAT,R,n,S);  % FWE-corrected {based on Z}
%             [Pk Pn] = spm_P(1,N(i),u,df,STAT,R,n,S);  % [un]corrected {based on k}
%             if topoFDR
%                 Qc  = spm_P_clusterFDR(N(i),df,STAT,R,n,u,QPc); % cluster FDR-corrected {based on k}
%                 Qp  = spm_P_peakFDR(U,df,STAT,R,n,u,QPp); % peak FDR-corrected {based on Z}
%                 Qu  = [];
%             else
%                 Qu  = spm_P_FDR(   U,df,STAT,n,QPs);  % voxel FDR-corrected {based on Z}
%                 Qc  = [];
%                 Qp  = [];
%             end
% 
%             if Pz < tol                               % Equivalent Z-variate
%                 Ze  = Inf;                            % (underflow => can't compute)
%             else
%                 Ze  = spm_invNcdf(1 - Pz);
%             end
%         else
%             Nv      = N(i);
%             
%             Pz      = [];
%             Pu      = [];
%             Qu      = [];
%             Pk      = [];
%             Pn      = [];
%             Qc      = [];
%             Qp      = [];
%             Ze      = spm_invNcdf(U);
%         end
% 


        % Specifically changed so it properly finds hMIPax
        %------------------------------------------------------------------
        tXYZmm = XYZmm(:,i);
      

%         HlistXYZ = [HlistXYZ, h];
%         if spm_XYZreg('Edist',xyzmm,XYZmm(:,i))<tol && ~isempty(hReg)
%             set(h,'Color','r')
%         end
%         hPage  = [hPage, h];

%         y      = y - dy;
% 
%         if topoFDR
%         [TabDat.dat{TabLin,3:12}] = deal(Pk,Qc,Nv,Pn,Pu,Qp,U,Ze,Pz,XYZmm(:,i));
%         else
%         [TabDat.dat{TabLin,3:12}] = deal(Pk,Qc,Nv,Pn,Pu,Qu,U,Ze,Pz,XYZmm(:,i));
%         end
%         TabLin = TabLin + 1;

        %-Print Num secondary maxima (> Dis mm apart)
        %------------------------------------------------------------------
        [l q] = sort(-Z(j));                % sort on Z value
        D     = i;
        
%             disp([XYZmm(:,D)' A(D) Z(D)]);
        tb(end+1,:)=[XYZmm(:,D)' A(D) Z(D) D];
        for i = 1:length(q)
            d = j(q(i));
            
        
            
            if min(sqrt(sum((XYZmm(:,D)-XYZmm(:,d)*ones(1,size(D,2))).^2)))>Dis;

                if length(D) < Num

%                     % Paginate if necessary
%                     %------------------------------------------------------
%                     if y < dy
%                         h = text(0.5,-5*dy,sprintf('Page %d',...
%                             spm_figure('#page',Fgraph)),...
%                             'FontName',PF.helvetica,...
%                             'FontAngle','Italic',...
%                             'FontSize',FS(8));
% 
%                         spm_figure('NewPage',[hPage,h])
%                         hPage = [];
%                         y     = y0;
%                     end

                    % voxel-level p values {Z}
                    %------------------------------------------------------
%                     if STAT ~= 'P'
%                         Pz    = spm_P(1,0,Z(d),df,STAT,1,n,S);
%                         Pu    = spm_P(1,0,Z(d),df,STAT,R,n,S);
%                         if topoFDR
%                             Qp = spm_P_peakFDR(Z(d),df,STAT,R,n,u,QPp);
%                             Qu = [];
%                         else
%                             Qu = spm_P_FDR(Z(d),df,STAT,n,QPs);
%                             Qp = [];
%                         end
%                         if Pz < tol
%                             Ze = Inf;
%                         else
%                             Ze = spm_invNcdf(1 - Pz); 
%                         end
%                     else
%                         Pz    = [];
%                         Pu    = [];
%                         Qu    = [];
%                         Qp    = [];
%                         Ze    = spm_invNcdf(Z(d));
%                     end

%                     h     = text(tCol(7),y,sprintf(TabDat.fmt{7},Pu),...
%                         'UserData',Pu,...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     hPage = [hPage, h];
% 
%                     if topoFDR
%                     h     = text(tCol(8),y,sprintf(TabDat.fmt{8},Qp),...
%                         'UserData',Qp,...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     else
%                     h     = text(tCol(8),y,sprintf(TabDat.fmt{8},Qu),...
%                         'UserData',Qu,...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     end
%                     hPage = [hPage, h];
%                     h     = text(tCol(9),y,sprintf(TabDat.fmt{9},Z(d)),...
%                         'UserData',Z(d),...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     hPage = [hPage, h];
%                     h     = text(tCol(10),y,sprintf(TabDat.fmt{10},Ze),...
%                         'UserData',Ze,...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     hPage = [hPage, h];
%                     h     = text(tCol(11),y,sprintf(TabDat.fmt{11},Pz),...
%                         'UserData',Pz,...
%                         'ButtonDownFcn','get(gcbo,''UserData'')');
%                     hPage = [hPage, h];

                    % specifically modified line to use hMIPax
                    %------------------------------------------------------
                    tXYZmm = XYZmm(:,d);
%                     h     = text(tCol(12),y,...
%                         sprintf(TabDat.fmt{12},tXYZmm),...
%                         'Tag','ListXYZ',...
%                         'ButtonDownFcn',[...
%                         'hMIPax = findobj(''tag'',''hMIPax'');',...
%                         'spm_mip_ui(''SetCoords'',',...
%                         'get(gcbo,''UserData''),hMIPax);'],...
%                         'Interruptible','off','BusyAction','Cancel',...
%                         'UserData',XYZmm(:,d));

%                     HlistXYZ = [HlistXYZ, h];
%                     if spm_XYZreg('Edist',xyzmm,XYZmm(:,d))<tol && ...
%                             ~isempty(hReg)
%                         set(h,'Color','r')
%                     end
%                     hPage = [hPage, h];
                       D     = [D d];
%                     y     = y - dy;
%                     if topoFDR
%                     [TabDat.dat{TabLin,7:12}] = ...
%                         deal(Pu,Qp,Z(d),Ze,Pz,XYZmm(:,d));
%                     else
%                     [TabDat.dat{TabLin,7:12}] = ...
%                         deal(Pu,Qu,Z(d),Ze,Pz,XYZmm(:,d));
%                     end
%                     TabLin = TabLin+1;

%                 disp( [XYZmm(:,d)' A(d) Z(d)]);
        tb(end+1,:)=[XYZmm(:,d)' A(d) Z(d) d];

                end
            end
        end
        Z(j) = NaN;     % Set local maxima to NaN
    end             % end region

  
idx=tb(:,6);
    
    
sv.idx= tb(:,6);
sv.tb=tb;
if 1 strcmp(invertZ,'invert')
     sv.Z     =-[Z2(idx)];
else
    sv.Z     =[Z2(idx)];
end


sv.A     =A(idx); 
sv.XYZ   =XYZ(:,idx); 
sv.XYZmm =XYZmm(:,idx);
sv.hdr   =hdr;
  if 1 strcmp(invertZ,'invert')
sv.Z  =sv.Z(:);
  else
  sv.Z  =-sv.Z(:);    
  end
sv.A  =sv.A(:);
% [sv]=pclustermaximaContraint(Z,A,XYZ,hdr,Num,Dis)

    