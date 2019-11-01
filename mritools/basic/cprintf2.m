

function count = cprintf2(style,format,header,varargin)
% for cellarry
% cprintf2([1 0 1], z.pp ,'DONE' );
% cprintf2([1 0 0], {'affe','mensch','klopapier'} ,'DONE' );
% cprintf2({[1 0 0] ;[0 .5 0] },{z.pp z.pp2} ,{'toDO' 'DONE'} );

if ~iscell(style)

    if exist('header')~=0
        if ~isempty(header)
            cprintf(-style, [ '  ' header '\n']  );
        end
    end


    for i=1:length(format);
        dum=[char(format{i})];
        %     dum=strrep(dum,'.','/.')
        cprintf(style, [ '  ' dum '\n']  );
    end

else %multiTable

%     cprintf2({[1 0 1] ;[0 1 0] },{z.pp2 z.pp} ,{'DONE' 'notDone'} );

 
isheader=0;
if exist('header')~=0
    if ~isempty(header)
        %             for i=1:length(header)
        %                 cprintf(-style{i}, [ '  ' header{i} '\t']  );
        %             end
        %             cprintf(-style{i}, [ '\n']  );
        isheader=1;

        for i=1:length(format)
            format{i}=[ header{i}; format{i}(:) ];
        end


    end
else
    %        header= repmat({''},[1 length(format)]);
end

len= (cellfun(@length, (format)));
imax=max(len);
for j=1:imax
    for i=1:length(format)
        dum=repmat(' ',[1 ...
                size(char([format{:,i} ]),2) ]  );
        if j>len(i)
            dum2='';
        else
            dum2=char(format{i}(j));
        end
        dum(1:length(dum2))=dum2;
        
        if j==1
            if isheader==1
                cprintf(-style{i}, [ '  ' dum '\t']  );
            else
                cprintf(style{i}, [ '  ' dum '\t']  );
            end
        else
            cprintf(style{i}, [ '  ' dum '\t']  );
        end


    end
    cprintf(-style{i}, [ '\n']  );
end
cprintf(-style{i}, [ '\n']  );





     





end