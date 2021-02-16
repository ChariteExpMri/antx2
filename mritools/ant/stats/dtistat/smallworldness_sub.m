

% task=[1,2,3,4]; value or values
%           1.. calculate:  S_ws 
%           2.. calculate:  S_trans
%           3.. calculate:  S_ws_MC 
%           4.. calculate:  S_trans_MC
%          so task=[1 2] will calculate: S_ws ans S_trans
function [sw swlabel]=smallworldness_sub(A,task)

% ==============================================
%%
% check:  20x20: 40% data survive to obtain values~=0
% ===============================================

% w =dx;
% w2=log(1 + (w)) ; % Log Transform
% w3=threshold_proportional(w2, 0.41);
%
% nsurvived=sum(w3(:)>0);
% survperc=[nsurvived/numel(w3)*100];
% disp(['threshold_proportional: survived: ' ...
%     num2str(nsurvived) '/' num2str(numel(w3))  ' (' num2str(survperc) '%)']);
% A=w3;
% A=A>0;

% ==============================================
%
% ===============================================


% if 0
%     %% load the adjacency matrix for the Lusseau bottle-nose dolphin social
%     % network
%     load dolphins  % loads struct of data in "Problem"; adjacency matrix is Problem.A
%
%     A = full(Problem.A); % convert into full from sparse format
%
% end

% ==============================================
%%
% ===============================================

% analysis parameters
Num_ER_repeats = 100;  % to estimate C and L numerically for E-R random graph
Num_S_repeats = 1000; % to get P-value for S; min P = 0.001 for 1000 samples
I = 0.95;

FLAG_Cws = 1;
FLAG_Ctransitive = 2;

% ==============================================
%%
% ===============================================

swlabel={};
sw     =[];

% ==============================================
%%
% ===============================================


% get its basic properties
n = size(A,1);  % number of nodes
k = sum(A);  % degree distribution of undirected network
m = sum(k)/2;
K = mean(k); % mean degree of network
% ==============================================
% computing small-world-ness using the analytical approximations for the E-R graph
% ===============================================

[expectedC,expectedL] = ER_Expected_L_C(K,n);  % L_rand and C_rand
if ~isempty(find(task==1))
    [S_ws,C_ws,L] = small_world_ness(A,expectedL,expectedC,FLAG_Cws);  % Using WS clustering coefficient
    %[S_trans,C_trans,L] = small_world_ness(A,expectedL,expectedC,FLAG_Ctransitive);  %  Using transitive clustering coefficient
    
    swlabel=[swlabel 'S_ws'  ];
    sw     =[sw       S_ws];
end

if ~isempty(find(task==2))
    %[S_ws,C_ws,L] = small_world_ness(A,expectedL,expectedC,FLAG_Cws);  % Using WS clustering coefficient
    [S_trans,C_trans,L] = small_world_ness(A,expectedL,expectedC,FLAG_Ctransitive);  %  Using transitive clustering coefficient
    
    swlabel=[swlabel 'S_trans'  ];
    sw     =[sw       S_trans];
end

% ==============================================
%computing small-world-ness by estimating L_rand and C_rand from an ensemble of random graphs
% ===============================================
% check when using small networks...
if ~isempty(find(task>2))
    
    [Lrand,CrandWS] = NullModel_L_C(n,m,Num_ER_repeats,FLAG_Cws);
    [Lrand,CrandTrans] = NullModel_L_C(n,m,Num_ER_repeats,FLAG_Ctransitive);
    
    % Note: if using a different random graph null model, e.g. the
    % configuration model, then use this form
    
    % compute small-world-ness using mean value over Monte-Carlo realisations
    
    % NB: some path lengths in L will be INF if the ER network was not fully
    % connected: we disregard these here as the dolphin network is fully
    % connected.
    Lrand_mean = mean(Lrand(Lrand < inf));
    
    
    %     [S_ws_MC,~,~]    = small_world_ness(A,Lrand_mean,mean(CrandWS),FLAG_Cws);  % Using WS clustering coefficient
    %     [S_trans_MC,~,~] = small_world_ness(A,Lrand_mean,mean(CrandTrans),FLAG_Ctransitive);  %  Using transitive clustering coefficient
    
    
    if ~isempty(find(task==3))
        [S_ws_MC,~,~]    = small_world_ness(A,Lrand_mean,mean(CrandWS),FLAG_Cws);  % Using WS clustering coefficient
        swlabel=[swlabel 'S_ws_MC'  ];
        sw     =[sw      S_ws_MC];
    end
    if ~isempty(find(task==4))
        [S_trans_MC,~,~] = small_world_ness(A,Lrand_mean,mean(CrandTrans),FLAG_Ctransitive);  %  Using transitive clustering coefficient
        swlabel=[swlabel 'S_trans_MC'  ];
        sw     =[sw      S_trans_MC];
    end
    
end
% ==============================================
% do Monte-Carlo test of disitribution of S in ER random graph
% ===============================================
if 0
    [I,P,Sb] = SsampleER(n,K,m,I,Num_S_repeats,S_ws,FLAG_Cws);  % for Sws here
    
    % check how many samples ended up being used to calculate P-value
    Nsamps = numel(Sb);
    Pmax = 1 / Nsamps;
end

% ==============================================
% display
% ===============================================
if 0
    try; disp(['S_ws      : ' num2str(S_ws)]); end
    try; disp(['S_trans   : ' num2str(S_trans)]); end
    try; disp(['S_ws_MC   : ' num2str(S_ws_MC)]); end
    try; disp(['S_trans_MC: ' num2str(S_trans_MC)]); end
end
% ==============================================
%%
% ===============================================

% sw=[S_ws S_trans S_ws_MC S_trans_MC];



