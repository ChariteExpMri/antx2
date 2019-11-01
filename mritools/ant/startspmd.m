

function startspmd(an, paths,tasks)

createParallelpools;
disp('..PCT-SPMD used');

atime=tic;
%% SPMD
% global an
spmd
    for j = labindex:numlabs:length(paths)   %% j=1:length(paths)
        for i=1:size(tasks,1)
            %try
            %  i,j, paths{j}
            
            try
                disp(sprintf('%d, %d  -%s',j,i,paths{j} ));
                antfun(tasks{i},paths{j},tasks{i,2:end},an);
            end
            %catch
            % &antfun(tasks{i,1},paths{j});
            %end
        end %i
    end
end %spmd
toc(atime);
     