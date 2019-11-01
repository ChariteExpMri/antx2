
 

%%  test2
%     ppm = ParforProgMon(strWindowTitle, nNumIterations <, nProgressStepSize, nWidth, nHeight>);
N=20
gcp
screensize=get(0,'ScreenSize')
sizwin=[screensize(3)*2./4 screensize(4)*2/20]
ppm = ParforProgMon('analysis', N ,1, sizwin(1),sizwin(2) );
% ppm = ParforProgMon('gbalaa', N, 1, 500, 10);
%  ppm = ParforProgMon('dddd', N)
parfor i=1:N
    pause(rand); % Replace with real code
   ppm.increment();
end

