



ml = actxserver('Matlab.Application');
ml.Visible = true;
ml.Execute('surf(peaks)');

 ml.Quit
 
 
 ml2 = actxserver('Matlab.Application');
ml2.Visible = true;


g= actxserver( 'matlab.application.single' );