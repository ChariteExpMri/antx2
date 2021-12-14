
% merge DTI-matrix (fibreStrength) over assigned regions 
% Here one/several clusters can be formed, unclusterd data will remain in the resulting array
%%  INPUT: 
% d : 2d-DTI-matrix (symmetric matrix, main diagonal is zero)
% tb: cell-table with following arrangement:
%
% columns: 
%  1: ID; 
%  2: label; 
%  3: merging regions   
%  4:label donator: (logical) if "1" this region is the label-donator for the respective merging cluster
%                   use only one label donator per merging cluster
% example: Here we have to merging clusters '1' and '2' all, regions with an identical string in 
%         column-3 (merging regions) will be merged: example: 'L_Somatosensory_areas_MODIF' and
%         'L_Anterior_cingulate_area_ventral_part_6b_MODIF' will be merged, Here the labelDonator 
%         for cluster-'1' is 'L_Anterior_cingulate_area_ventral_part_6b_MODIF' (see column-4)
%     The 2nd merging cluster is '2' consisting of 'L_Infralimbic_area_layer_6b_MODIF' and 
%     ''L_Orbital_area_lateral_part_layer_6b_MODIF', Here the labelDOnator is 'L_Infralimbic_area_layer_6b_MODIF' 
%    The region 'L_Prelimbic_area_layer_6b_MODIF' remains un-clustered
%     tb={[1]  'L_Somatosensory_areas_MODIF'                       '1'  [0]
%         [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '1'  [1]
%         [3]  'L_Prelimbic_area_layer_6b_MODIF'                   ''   [0]
%         [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '2'  [1]
%         [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '2'  [0]
%         }
% 
% show: 0/1: show output
% 
%%  OUTPUT: 
%  d4  : merged data-table
%  tb2 : reduced version of the input-table (with label-donators)
%% ===============================================
%% EXAMPLE
% [d4 tb2]=mergeDTImatrix(d,tb, 1);

function [d4 tb2 in]=mergeDTImatrix(d,tb, show)
%% ===============================================
% clc
p.show=0;
p.tag ='';
if exist('show')==1
    p.show=show;
end


if 0
    
    %% ===============================================
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       '1'  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '1'  [1]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   '2'  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '2'  [1]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '2'  [0]
        }
    
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ];
    
    [d4 tb2]=mergeDTImatrix(d,tb,1);
    
    %% ===================================================================================================
end

% ==============================================
%%   example_call
% ===============================================

if numel(d)==1
    [d tb exnum exstr]=examples(d);
    
    p.show=1; 
    lin=repmat('_',[1 100]);
    p.tag={lin;['*** EXAMPLE-' num2str(exnum)  exstr ' ***'];lin};
end



%% ==== unpack table ===========================================
% 'a'
v0=tb(:,3);
clnames=unique(v0); clnames(strcmp(clnames,''))=[];
[~,ia]=ismember(v0,clnames);
v=ia;
label       =tb(:,2);
labeldonator=cell2mat(tb(:,4));

%% ===============================================

uni=unique(v); uni(uni==0)=[];

df=[];
for i=1:length(uni)
    is=find(v==uni(i));
    su=sum(d(is  ,:),1);
    df(i,:)=su;
end
% ----new matrix
n=length(uni)+length(find(v==0));
% d2=zeros(n,n)


d3=d;
repr=[];
labdon={};
ixlabdon=[];
for i=1:length(uni)
    dv=df(i,:);
    dv2=dv;
    it=find(v==uni(i));
    repr(i,1)=it(1);
    for j=1:length(uni)
        is=find(v==uni(j));
        dv2(is)=sum(dv(is));
    end
    d3(it,:)=repmat(dv2,  [length(it) 1          ]);
    d3(:,it)=repmat(dv2', [1          length(it) ]);
    
    % label donator_____________
    il=it(find(labeldonator(it)~=0));
    %il=it(find(labeldonator(it)==90))
    if length(il)~=1; 
        il=it(1);
    end
    labdon{i,1}=label{il};
    ixlabdon(i,1)=il;
    
end

ikeep=sort([repr(:);  find(v==0) ]);
d4=d3(ikeep,ikeep);
d4=~eye(length(ikeep)).*d4 ;% eyeElements="0"
% ----------label
tb2=tb;
tb2(repr,:)=tb(ixlabdon,:);
tb2=tb2(ikeep,:);

in.tb=tb;
in.d =d;

% =======[SHOW]========================================

if p.show==1
    disp(char([ p.tag ]));
    disp('----IMPUT-MATRIX:');
    disp(d);
    
    disp('----FINAL-MERGED-MATRIX:');
    disp(d4);
    
    disp('----input table:');
    disp(tb);
    
    disp('----merged table:');
    disp(tb2);
end




% ==============================================
%%
% ===============================================
% d=[
%     1 2 3 4 5;
%     2 1 3 4 5
%     3 3 1 4 5
%     4 4 4 1 5
%     5 5 5 5 1
%     ]
% v=[1 1 1 1 0  ]






function [d tb exnum exstr]=examples(d)
% ==============================================
%%
% ===============================================

if d==1
    exnum=d;
    exstr='..merging regions forming TWO clusters';
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       '1'  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '1'  [1]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   '2'  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '2'  [1]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '2'  [0]
        };
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ];
elseif d==2
    exnum=d;
    exstr='..merging regions forming TWO clusters reversed merging assignment    ';
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       '2'  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '2'  [1]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   '1'  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '1'  [1]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '1'  [0]
        };
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ];
elseif d==3
    exnum=d;
    exstr='..merging regions forming ONE cluster ';
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       '1'  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '1'  [1]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   '1'  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '1'  [0]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '0'  [0]
        };
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ]; 
 elseif d==4
    exnum=d;
    exstr='..merging regions forming ONE cluster--> BUT NO CONNECTIONS LEFT ';
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       '1'  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   '1'  [1]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   '1'  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 '1'  [0]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        '1'  [0]
        };
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ];   
elseif d==5
    exnum=d;
    exstr='..no merging/no clustering -->input is output ';
    
    tb={[1]  'L_Somatosensory_areas_MODIF'                       ''  [0]
        [2]  'L_Anterior_cingulate_area_ventral_part_6b_MODIF'   ''  [0]
        [3]  'L_Prelimbic_area_layer_6b_MODIF'                   ''  [0]
        [4]  'L_Infralimbic_area_layer_6b_MODIF'                 ''  [0]
        [5]  'L_Orbital_area_lateral_part_layer_6b_MODIF'        ''  [0]
        };
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ];
end











if 0
    % d=toeplitz(1:5)
    d=[
        0  2  3  4  5
        2  0  3  4  5
        3  3  0  4  5
        4  4  4  0  5
        5  5  5  5  0
        ]
end
% v=[1 1 0 2 2  ]
% v=[0 0 0 0 0  ]; %works ...so no merging outPut is identical to input


% v=[1 1 1 1 0  ] ; % works: matrix is
% d4 =
%      0    20
%     20     0
% --> check lower left quadrant: 3+3+4+4+5+5=24
% ===============================================
if 0
    % MERGING  REGIONS INTO TWO CLUSTER!
    v=[  2 2 0 1 1  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    %     d4 =
    %          0     6    18
    %          6     0     9
    %         18     9     0
    % check: for cluster-2: take first two columns, sum index-3: 3+3=6, than sum index 3-to-5:
    %    3+3+4+4+5+5=18;
    % check2; for cluster-1 take columns 4&5, sum index-3: 4+5=9, than sum index 1-to-2: 4+5+4+5=18
    
end


if 0
    % MERGING  REGIONS INTO ONE CLUSTER!
    v=[  1 1 0 0 0  ] ; % tHESE REGIONS (1) WILL BE MERGED
    %     ----FINAL-MERGED-MATRIX:
    %     d4 =
    %          0     6     8    10
    %          6     0     4     5
    %          8     4     0     5
    %         10     5     5     0
    % check: sum colums 1and2, indices 3:5 are: 3+3=6,4+4=8,5+5=10 // rest is identical to input
end


if 0
    % MERGING  REGIONS INTO ONE CLUSTER!
    v=[  1 1 0 1 1  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    % d4 =
    %      0    15
    %     15     0
    % check: sum middle colum: 3+3+4+5=15
end

if 0
    % MERGING  REGIONS INTO TWO CLUSTER!
    v=[  1 1 2 2 2  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    % d4 =
    %       0    24
    %      24     0
    %check sum-elemets of first-two columns,indices 3-to-5: 3+3+4+4+5+5=24
    %check2: sum-elemets of columns3,4,5, indices 1-to-2: 3+4+5+3+4+5=24
end

if 0
    % MERGING ONE REGIONO INTO ONE!---> this is just a check...because one region only can not be merged
    %  ....output is identical to input
    v=[  0 1 0 0 0  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    % d4 =
    %      0     2     3     4     5
    %      2     0     3     4     5
    %      3     3     0     4     5
    %      4     4     4     0     5
    %      5     5     5     5     0
    
end
if 0
    % MERGING TWO REGIONS INTO ONE!
    v=[  0 1 1 0 0  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    % d4 =
    %      0     5     4     5
    %      5     0     8    10
    %      4     8     0     5
    %      5    10     5     0
    %
    % check: sum of row (equals column) of index 2&3: 2+3=5, [0],[0] ,4+4=8,5+5=10// rest is as input
    
end
if 0
    % MERGING FOUR REGIONS INTO ONE!
    v=[  0 1 1 1 1  ] ; % tHESE REGIONS (1) WILL BE MERGED
    % ----FINAL-MERGED-MATRIX:
    % d4 =
    %      0    14
    %     14     0
    % check: sum first column --> 2+3+4+5=14
end


% ==============================================
%%
% ===============================================


