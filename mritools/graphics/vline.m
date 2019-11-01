function varargout=vline(x0, varargin);

% VLINE plot a vertical line in the current graph
%multiple lines-supported

if isempty(varargin)
    varargin= {'color', [0 0 0]};
end

for i=1:length(x0)
    x=x0(i);
    abc = axis;
    x = [x x];
    y = abc([3 4]);
    if length(varargin)==1
        varargin = {'color', varargin{1}};
    end
    h = line(x, y);
    set(h, varargin{:});
    h2(i)=h;
end
varargout{1}=h2;


%%original
% function varargout=vline(x, varargin);
% 
% % VLINE plot a vertical line in the current graph
% 
% 
% abc = axis;
% x = [x x];
% y = abc([3 4]);
% if length(varargin)==1
%   varargin = {'color', varargin{1}};
% end
% h = line(x, y);
% set(h, varargin{:});
% varargout{1}=h;
