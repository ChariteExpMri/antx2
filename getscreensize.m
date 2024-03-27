

function [S1 S2]=getscreensize()
% get real screen size
% https://de.mathworks.com/matlabcentral/answers/312738-how-to-get-real-screen-size

S1=get(0, 'MonitorPositions');

ScreenPixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
ScreenDevices = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
try
    MainScreen = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getScreen()+1;
    MainBounds = ScreenDevices(MainScreen).getDefaultConfiguration().getBounds();
catch
    r=java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
    MainBounds = r.getDefaultConfiguration().getBounds();
end



MonitorPositions = zeros(numel(ScreenDevices),4);
for n = 1:numel(ScreenDevices)
    Bounds = ScreenDevices(n).getDefaultConfiguration().getBounds();
    MonitorPositions(n,:) = [Bounds.getLocation().getX() + 1,-Bounds.getLocation().getY() + 1 - Bounds.getHeight() + MainBounds.getHeight(),Bounds.getWidth(),Bounds.getHeight()];
end
S2=MonitorPositions;