
%add struct-paramters(x) to parameterlist(p)
%function paramadd(p,x)
function p=paramadd(p,x)

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
    
    x=[]
    x.masktag='mm'
    x.hemisphere='leftHEM'
    p=paramadd(p,x);
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


if isstruct(x)==1
    %fn =fieldnames(x);
    fn= fieldnamesr(x);
    fnp=fieldnamesr(x,'prefix');
    va = struct2cell(x);
    for i=1:length(fn)
        id=find(strcmp(p(:,1),fn{i}));
        if ~isempty(id)
            eval(['dum=' fnp{i} ';']);
            %             eval(['drum=' t3{i,1} ])
            p(id,2)={dum};
%             p(id,2)=va(i);
        end
    end
end


