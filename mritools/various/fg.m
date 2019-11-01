function varargout=fg(varargin)

hf=figure('color','w');
if nargout>0
    varargout{1}=hf;
end
if ~isempty(varargin)
    set(hf, varargin{:});
end

