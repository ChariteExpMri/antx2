% Brunner-Munzel test (2000) for the comparison of two samples. It is a
% non-parametric test for the relatvive treatment effect p. If a significant
% difference is found at level alpha, it means that one of the two samples tends 
% to larger values than the other, with respect to the confidence level. 
% Compared to the Wilcoxon-Man-Whitney test this test has the advantage 
% that it also works under heteroscedasticity. The implementation here is 
% the ASYMPTOTIC version only, sample sizes>20 work well.
%
% function [p_value testStat]=brunner_munzel(sample1, sample2)
%
% Required Inputs:
%  sample1 - first sample, can be different in lenght from the second
%  sample2 - second sample which has to be testes to the first
%
% Output:
%  p_value - p-value calculated under the asymptotic normal distribution
%
% Example: p = brunner_munzel(x, y)
%
% Reference:
%
% The Nonparametric Behrens?Fisher Problem: Asymptotic Theory and a Small?Sample Approximation
% E. Brunner and U. Munzel, Biometrical Journal (2000) 
%
%
% Author:
% Maximilian Beckers
% Sachse Lab
% European Molecular Biology Laboratory
% Heidelberg
% December 2018
function [p_value testStat] = brunner_munzel(sample1, sample2)
    
    %some initialization
    numSamples1 = length(sample1);
    numSamples2 = length(sample2);
    N = numSamples1 + numSamples2;
    rankSum1 = 0;
    rankSum2 = 0;
   
    %get mean ranksum of sample1
    for k=1:numSamples1 
        tmpRank = 0.5;
        for j=1:2
            if j==1
                numSamples = numSamples1;
                for l=1:numSamples
                    if sample1(k)-sample1(l) < 0
                        c = 0;
                    elseif sample1(k)-sample1(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    tmpRank = tmpRank + c;
                end   
            else
                numSamples = numSamples2;
                for l=1:numSamples
                    if sample1(k)-sample2(l) < 0
                        c = 0;
                    elseif sample1(k)-sample2(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    tmpRank = tmpRank + c;
                end   
            end
        end
        rankSum1 = rankSum1 + (1/numSamples1)*tmpRank ;
    end

    %get mean ranksum 2
    for k=1:numSamples2 
        tmpRank = 0.5;
        for j=1:2
            if j==1
                numSamples = numSamples1;
                for l=1:numSamples
                    if sample2(k)-sample1(l) < 0
                        c = 0;
                    elseif sample2(k)-sample1(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    
                    tmpRank = tmpRank + c;
                end   
            else
                numSamples = numSamples2;
                for l=1:numSamples
                    if sample2(k)-sample2(l) < 0
                        c = 0;
                    elseif sample2(k)-sample2(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    
                    tmpRank = tmpRank + c;
                end   
            end
        end
        rankSum2 = rankSum2 + (1/numSamples2)*tmpRank ;
    end

    %calculate variance S1_squared
    S1sq = 0;
    for k=1:numSamples1 
        tmpRank = 0.5;
        internRank1 = 0.5;
        for j=1:2
            if j==1
                numSamples = numSamples1;
                for l=1:numSamples
                    if sample1(k)-sample1(l) < 0
                        c = 0;
                    elseif sample1(k)-sample1(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    tmpRank = tmpRank + c;
                    internRank1 = internRank1 + c;
                end   
            else
                numSamples = numSamples2;
                for l=1:numSamples
                    if sample1(k)-sample2(l) < 0
                        c = 0;
                    elseif sample1(k)-sample2(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    
                    tmpRank = tmpRank + c;
                end   
            end
        end
        S1sq = S1sq + (1/(numSamples1-1))*(tmpRank - internRank1 - rankSum1 + (numSamples1 +1)/2)^2;
    end
    
    %calculate variance S_squared
    S2sq = 0;
    for k=1:numSamples2 
        tmpRank = 0.5;
        internRank2 = 0.5;
        for j=1:2
            if j==1
                numSamples = numSamples1;
                for l=1:numSamples
                    if sample2(k)-sample1(l) < 0
                        c = 0;
                    elseif sample2(k)-sample1(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    tmpRank = tmpRank + c;
                    
                end   
            else
                numSamples = numSamples2;
                for l=1:numSamples
                    if sample2(k)-sample2(l) < 0
                        c = 0;
                    elseif sample2(k)-sample2(l) == 0
                        c = 0.5;
                    else 
                        c = 1;
                    end
                    
                    tmpRank = tmpRank + c;
                    internRank2 = internRank2 + c;
                end   
            end
        end
        S2sq = S2sq + (1/(numSamples2-1))*(tmpRank - internRank2 - rankSum2 + (numSamples2 +1)/2)^2;
    end
    
 
    %final variance
    var = N*S1sq/(N-numSamples1) + N*S2sq/(N-numSamples2);
    
    %calcuate the value of the test statistic
    testStat = ((rankSum2-rankSum1)/(sqrt(var)))*sqrt(numSamples1*numSamples2/N);
    
    %calculate p-value
    p_value =  2*min(1-normcdf(testStat), normcdf(testStat));
   
end
