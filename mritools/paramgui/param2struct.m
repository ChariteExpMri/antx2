
%convert paramarray(p) to structur, and delete infoTags
function x=param2struct(p)

%% EXAMPLE
if 0
    
    p={...
        'inf98'      '*** ALLEN LABELING                 '                         '' ''
        'inf99'      'USE EITHER APPROACH-1 OR APPROACH-2'                         '' ''
        'inf100'     '==================================='                          '' ''
        'inf1'      '% APPROACH-1 (fullpathfiles: file/mask)          '                                    ''  ''
        'files'      ''                                                           'files used for calculation' ,'mf'
        'masks'      ''                                                           '<optional>maskfiles (order is irrelevant)' ,'mf' ...
        %
        'inf2'      '% APPROACH-2 (use filetags)' ''  ''
        'filetag'      ''   'matching stringpattern of filename' ,''
        'masktag'      ''   '<optional> matching stringpattern of masksname (value=1 is usef for inclusion)' ,''
        'hemisphere' 'both'     'calculation over [left,right,both]' {'left','right','both'}
        %
        'inf3'      '% PARAMETERS' ''  ''
        'frequency'  1     'paramter to extract' 'b'
        'mean'       1     'paramter to extract' 'b'
        'std'        1     'paramter to extract' 'b'
        'median'     1     'paramter to extract' 'b'
        'min'        1     'paramter to extract' 'b'
        'max'        1     'paramter to extract' 'b'
        }
    
 
    z=param2struct(p);
end


idel=regexpi2(p(:,1),'^inf\d');
p(idel,:)=[];
x=cell2struct(p(:,2)',p(:,1)',2);