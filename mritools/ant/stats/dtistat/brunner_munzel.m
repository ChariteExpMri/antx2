function [p_value, testStat, df] = brunner_munzel(sample1, sample2)
% BRUNNER_MUNZEL Brunner-Munzel test for two independent samples.
%
%   [p_value, testStat, df] = brunner_munzel(sample1, sample2)
%
% Inputs:
%   sample1  - First sample (numeric vector)
%   sample2  - Second sample (numeric vector)
%
% Outputs:
%   p_value  - Two-sided p-value using the small-sample t approximation
%   testStat - Brunner-Munzel test statistic
%   df       - Estimated degrees of freedom
%
% The test compares the relative treatment effect of two independent
% samples and allows for unequal variances.
%
% Ties receive half credit. NaN and Inf values are not accepted.
%
% Reference:
%   Brunner E, Munzel U (2000).
%   The Nonparametric Behrens-Fisher Problem: Asymptotic Theory and
%   a Small-Sample Approximation.
%   Biometrical Journal.
%
% This implementation retains the rank-statistic calculations of the
% original function and uses a small-sample t approximation for the
% p-value. Requires the Statistics and Machine Learning Toolbox.

% -------------------------------------------------------------
% Validate and prepare input
% -------------------------------------------------------------

if ~isnumeric(sample1) || ~isnumeric(sample2) || ...
        ~isvector(sample1) || ~isvector(sample2)
    error('Both inputs must be numeric vectors.');
end

sample1 = sample1(:);
sample2 = sample2(:);

if any(~isfinite(sample1)) || any(~isfinite(sample2))
    error('Samples must not contain NaN or Inf values.');
end

numSamples1 = length(sample1);
numSamples2 = length(sample2);
N = numSamples1 + numSamples2;

if numSamples1 < 2 || numSamples2 < 2
    error('Each sample must contain at least two observations.');
end

% -------------------------------------------------------------
% Calculate mean pooled ranks for both samples
% -------------------------------------------------------------

rankSum1 = 0;
rankSum2 = 0;

for k = 1:numSamples1
    tmpRank = 0.5;
    
    for l = 1:numSamples1
        if sample1(k) < sample1(l)
            c = 0;
        elseif sample1(k) == sample1(l)
            c = 0.5;
        else
            c = 1;
        end
        tmpRank = tmpRank + c;
    end
    
    for l = 1:numSamples2
        if sample1(k) < sample2(l)
            c = 0;
        elseif sample1(k) == sample2(l)
            c = 0.5;
        else
            c = 1;
        end
        tmpRank = tmpRank + c;
    end
    
    rankSum1 = rankSum1 + tmpRank / numSamples1;
end

for k = 1:numSamples2
    tmpRank = 0.5;
    
    for l = 1:numSamples1
        if sample2(k) < sample1(l)
            c = 0;
        elseif sample2(k) == sample1(l)
            c = 0.5;
        else
            c = 1;
        end
        tmpRank = tmpRank + c;
    end
    
    for l = 1:numSamples2
        if sample2(k) < sample2(l)
            c = 0;
        elseif sample2(k) == sample2(l)
            c = 0.5;
        else
            c = 1;
        end
        tmpRank = tmpRank + c;
    end
    
    rankSum2 = rankSum2 + tmpRank / numSamples2;
end

% -------------------------------------------------------------
% Calculate variance component S1sq
% -------------------------------------------------------------

S1sq = 0;

for k = 1:numSamples1
    tmpRank = 0.5;
    internRank1 = 0.5;
    
    for l = 1:numSamples1
        if sample1(k) < sample1(l)
            c = 0;
        elseif sample1(k) == sample1(l)
            c = 0.5;
        else
            c = 1;
        end
        
        tmpRank = tmpRank + c;
        internRank1 = internRank1 + c;
    end
    
    for l = 1:numSamples2
        if sample1(k) < sample2(l)
            c = 0;
        elseif sample1(k) == sample2(l)
            c = 0.5;
        else
            c = 1;
        end
        
        tmpRank = tmpRank + c;
    end
    
    residual = tmpRank - internRank1 - rankSum1 ...
        + (numSamples1 + 1) / 2;
    
    S1sq = S1sq + residual^2 / (numSamples1 - 1);
end

% -------------------------------------------------------------
% Calculate variance component S2sq
% -------------------------------------------------------------

S2sq = 0;

for k = 1:numSamples2
    tmpRank = 0.5;
    internRank2 = 0.5;
    
    for l = 1:numSamples1
        if sample2(k) < sample1(l)
            c = 0;
        elseif sample2(k) == sample1(l)
            c = 0.5;
        else
            c = 1;
        end
        
        tmpRank = tmpRank + c;
    end
    
    for l = 1:numSamples2
        if sample2(k) < sample2(l)
            c = 0;
        elseif sample2(k) == sample2(l)
            c = 0.5;
        else
            c = 1;
        end
        
        tmpRank = tmpRank + c;
        internRank2 = internRank2 + c;
    end
    
    residual = tmpRank - internRank2 - rankSum2 ...
        + (numSamples2 + 1) / 2;
    
    S2sq = S2sq + residual^2 / (numSamples2 - 1);
end

% -------------------------------------------------------------
% Calculate test statistic and variance components
% -------------------------------------------------------------

var1 = N * S1sq / numSamples2;
var2 = N * S2sq / numSamples1;

varTotal = var1 + var2;

if ~isfinite(varTotal) || varTotal <= 0
    p_value = NaN;
    testStat = NaN;
    df = NaN;
    return;
end

testStat = (rankSum2 - rankSum1) ...
    / sqrt(varTotal) * sqrt(numSamples1 * numSamples2 / N);

% -------------------------------------------------------------
% Small-sample degrees of freedom (Welch-Satterthwaite form)
% -------------------------------------------------------------

dfDenom = var1^2 / (numSamples1 - 1) ...
    + var2^2 / (numSamples2 - 1);

if ~isfinite(dfDenom) || dfDenom <= 0
    p_value = NaN;
    df = NaN;
    return;
end

df = varTotal^2 / dfDenom;

% -------------------------------------------------------------
% Two-sided p-value from the t distribution
% Using the lower tail avoids cancellation in 1 - tcdf(...)
% -------------------------------------------------------------

p_value = 2 * tcdf(-abs(testStat), df);

