function coords = getcoords(hFigure)

  %# Get the screen coordinates:
  coords = uni2uni(0,'PointerLocation','pixels');

  %# Get the figure position, axes position, and axes limits:
%   hFigure = get(hAxes,'Parent');
  figurePos = uni2uni(hFigure,'Position','pixels');
%   axesPos = uni2uni(hAxes,'Position','pixels');
%   axesLimits = [get(hAxes,'XLim').' get(hAxes,'YLim').'];

  %# Compute an offset and scaling for coords:
  offset = figurePos(1:2)+axesPos(1:2);
  axesScale = diff(axesLimits)./axesPos(3:4);

  %# Apply the offsets and scaling:
  coords = (coords-offset).*axesScale+axesLimits(1,:);

end