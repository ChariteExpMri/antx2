function cmap=bruker_colorgray(levels)
% A Colormap for Effective Black and White Rendering of Color Scale Images
%
% Usage: cmap=colorgray(levels)
%
% cmap           : matrix used by colormap()
% levels         : number of intensity values, default: 64

% modified script by
% Carey Rappaport, Northeastern University, Boston, MA 02115
% downloaded from Matlab Central

if nargin<1, levels=64; end;

% 9 Level Color Scale Colormap with Mapping to Grayscale for Publications.
CMRmap=[0 0 0;.15 .15 .5;.3 .15 .75;.6 .2 .50;1 .25 .15; ...
    .9 .5 0;.9 .75 .1;.9 .9 .5;1 1 1];

% spline fit to increase number of levels
x = 1:8/(levels-1):9;           % 64 color levels instead of 9
x1 = 1:9;
for i = 1:3
    % spline fit intermediate values
	cmap(:,i) = spline(x1,CMRmap(:,i),x)';
end
% eliminate spurious values outside of range 
cmap = abs(cmap/max(max(cmap)));