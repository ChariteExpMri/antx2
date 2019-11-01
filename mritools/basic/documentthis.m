

function documentthis(pa, fi,figs)
% documentthis([path.res], 'test2')     
% documentthis('test.ppt', 'test2',[1 2 3])

if 0
    pa=path.res
    fi='muell'
end

if ~exist('figs');    figs=[]; end
if isempty(figs);
    figs=sort(findobj(0,'type','figure'));
end
 
if ~exist('fi');    fi=[]; end
if isempty(fi);
    save_file=pa;
else
   save_file=fullfile(pa,fi );  
end

save_file=[regexprep(save_file,{'.ppt','.PPT'},{'',''}) '.ppt'];

  ppt=saveppt2(save_file,'init');
  for i=1:length(figs)
      set(0,'currentfigure',figs(i)); figure(i); drawnow;
%       pause(.1);
%        saveppt2('ppt',ppt)
    saveppt2('ppt',ppt,'driver','bitmap', 'res',150);%,'driver','bitmap','scale','stretch');
%       saveppt2('ppt',ppt,'driver','bitmap','scale','stretch');
%       if mod(i,5)==0 % Save half way through incase of crash
%         saveppt2('ppt',ppt,'save');
%       end
  end
  saveppt2(save_file,'ppt',ppt,'close');
%   
%     saveppt2('test.ppt','driver','meta','scale','stretch');
%   saveppt2('test.ppt','driver','bitmap','scale','stretch');