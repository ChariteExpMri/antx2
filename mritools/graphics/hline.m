function varargout=hline(y0, varargin)

% HLINE plot a horizontal line in the current graph
%multiple lines-supported

if isempty(varargin)
    varargin= {'color', [0 0 0]};
end

for i=1:length(y0)
    y=y0(i);

    abc = axis;
    y = [y y];
    x = abc([1 2]);
    if length(varargin)==1
        varargin = {'color', varargin{1}};
    end
    h = line(x, y);
    set(h, varargin{:});
    h2(i)=h;
end
varargout{1}=h2;

 


% %%original
% abc = axis;
% y = [y y];
% x = abc([1 2]);
% if length(varargin)==1
%   varargin = {'color', varargin{1}};
% end
% h = line(x, y);
% set(h, varargin{:});
% varargout{1}=h;
