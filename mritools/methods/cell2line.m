function [s]=cell2line(c,mode,varargin)
%======================================================================= 
% function [s]=cell2line(c,varargin)
%=======================================================================
% parse a singleline from a cell [works LINEWISE,]
% optional: varargin 1 can be a stoperSIGN (string) default is: ' | '
% 
%% exp.
%     lab={'Mrk', '12','45';'mkf','red' ,'blue' }
%     o=cell2line(lab,1);disp(o);
%     o=cell2line(lab,2);disp(o);
%     o=cell2line(lab,2,' ;Handle: ');disp(o);
% 
%======================================================================= 
%                                                      Paul, BNIC 2007
%=======================================================================
stp=' | ';

if nargin>2
stp= varargin{1};
end



y='';

if mode==1
    %COLUMNWISE
    for i=1:size(c,2)
        for j=1:size(c,1);
            try
            x=[char(c(j,i)) stp] ;
            catch
              x=[num2str(cell2mat(c(j,i))) stp] ; 
            end
                
            y(end+1: [end+length(x) ]) = [x ];
        end
    end
elseif mode==2
    %ROWISE
      for j=1:size(c,1);
          for i=1:size(c,2);
              try
             x=[char(c(j,i)) stp] ;
              catch
               x=[num2str(cell2mat(c(j,i))) stp] ;     
              end
            y(end+1: [end+length(x) ]) = [x ];
        end
    end
end



%clear stp at end
y(end-length(stp)+1:end)=[];

s=y;