
%%open windows explorer (win,mac,linux)
% function explorer(paths)
% paths: []points to pwd | singlepath | cell of multiple paths
%% examples
% explorer                      ;% open explorer with directory of the current directory
% explorer('mean.m')            ;% open explorer with directory where mean.m is located
% explorer(which('mean.m'))     ;% same as above
%explorer({'c:\';'o:\'})        ;% open two explorer windows with directories 'c:\' and 'o:\', repsectively


% call
% wind: % system('start O:\data4\phagozytose\dat\20190221CH_Exp1_M58\summary\index.html')
% ubuntu: xdg-open http://www.spiegel.de
% mac: open http://www.spiegel.de


function explorer(paths)



if exist('paths')==1
    if ischar(paths);
        paths={paths} ;
    end
else
    paths={pwd} ;
end

for i=1:length(paths)
    [pa2 pa ext]=fileparts(paths{i});
    if isempty(ext)
        %     eval(['!start ' paths{i} ]);
        if ispc
            eval(['!explorer ' paths{i} ]);
        elseif ismac
            system(['open '  paths{i} ' &']);
        else
            %             system(['nautilus "'  paths{i} '" &' ]);
            system(['xdg-open "'  paths{i} '" &' ]);
        end
    else
        %      eval(['!start ' pa2 ]) ;
        if ~isempty(ext) && isempty(pa2)  % mfile
            if ispc
                eval(['!explorer '  fileparts(which(paths{i})) ]);
            elseif ismac
                system(['open '  fileparts(which(paths{i})) ' &']);
            else
                %                 system(['nautilus "'  fileparts(which(paths{i})) '" &' ]);
                system(['xdg-open "'  fileparts(which(paths{i})) '" &' ]);
            end
        else
            if ispc
                eval(['!explorer ' pa2 ]) ;
            elseif ismac
                system(['open '  pa2 ' &']);
            else
                %                 system(['nautilus "'  pa2 '" &' ]);
                system(['xdg-open "'  pa2 '" &' ]);
            end
        end
    end
end

