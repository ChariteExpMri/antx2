



spmd
   for i = 1:10
      disp(i)
   end
end


clc
spmd
    switch labindex
        case 1
            for i=1:5
               disp(i);
            end
        case 2
            for i=6:10
                disp(i);
            end
    end
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
try
    matlabpool(3)
end

clc
nc=400
tic
    for n =1:10         % labindex = {1,2,3,4}
        %n                      % numlabs = 4
        testcalc(nc);
    end
toc
tic
spmd
    for n = labindex:numlabs:10         % labindex = {1,2,3,4}
        %n                      % numlabs = 4
        testcalc(nc);
    end
end
toc
tic
    parfor n =1:10         % labindex = {1,2,3,4}
        %n                      % numlabs = 4
        testcalc(nc);
    end
toc
