
function out=makenicer2(in)

%% ________________________________________________________________________________________________
% make nicer
%% ________________________________________________________________________________________________

if ischar(in)
    tx5=strsplit(in,char(10))';
else
    tx5=in;
end
% lincod=regexpi2(tx5, ['x.' '\w+=|\w+\s+=']);
% lincod=regexpi2(tx5,'^an\.'); 

% s=regexpi2(tx5,'^[A-Za-z][a-zA-Z_0-9]*\.?[A-Za-z][a-zA-Z_0-9.]*\s*=')
lincod=regexpi2(tx5,'^[A-Za-z][a-zA-Z_0-9]*\.?[A-Za-z][a-zA-Z_0-9.]*\s*=');

% starts with letter, followed by 0-n alphanumeric_ characters, followed by 0-1 dot (? sign)
% ,followed by by 0-n alphanumeric_ characters, folowed by 0-n spaces and dot, followed by '='


lin=tx5(lincod);

% set '='
w1=regexpi(lin,'=','once')          ; %equal sign
w2=regexpi(lin,'\S=|\S\s+=','once') ;% %last char of fieldname %regexpi({'w.e=3';'wer   =  33'},'\S=|\S\s+=','once')
try; w1=cell2mat(w1); end
try; w2=cell2mat(w2); end
lin2=lin;
for i=1:size(lin2)
    is1=regexpi(lin2{i},'\S=|\S\s+=','once');
    is2=regexpi(lin2{i},'=','once');
    
  lin2{i} = ...
  [lin2{i}(1:is1) repmat(' ',[1 max(w2)-w2(i)]) ' ='  lin2{i}(is2+1:end) ];
end
% char(lin2)
lin=lin2;

%set field
w1=regexpi(lin,'(?<==\s*)(\S+)','once'); %  look back for "= & space"
try; w1=cell2mat(w1); end
lin2=lin;
spac=repmat(' ',[1 2]);
for i=1:size(lin2)
    is=regexpi(lin2{i},'=','once');
      if i==1
        extens=length([lin2{i}(1:is) spac]  );%used later for multiline
      end
      lin2{i} = [lin2{i}(1:is) spac   lin{i}(w1(i):end) ];
end
lin=lin2;

%place back
tx6=tx5;
tx6(lincod)=lin;

% multi-line array
for i=lincod(1):size(tx6,1)
    if isempty(find(lincod==i))% no first-line linecode or other stuff
        dx=tx6{i};
        if strcmp(regexpi(dx,'\S','match','once'),'%') ==0 ;% FIRST SIGN ASIDE SPACE is not COMMENTSIGN  regexpi(' ;%','\S','match','once')

        dx=[repmat(' ',[1 extens+1]) regexprep(dx,'^\s+','','once')];
        tx6{i}=dx;
        end
    end
    
end

if ischar(in)
    out=strjoin(tx6,char(10));
else
    out=tx6;
end