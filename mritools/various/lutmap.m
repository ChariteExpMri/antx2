
%obtain lutmaps
% [lutf lutmaps ]=lutmap('show'); % show all cmaps
%  [lutf lutmaps ]=lutmap('actc');
%  [lutf lutmaps ]=lutmap('actc_inv'); %inverted cmap (..using suffix: '_inv')
% 
%modified from from https://github.com/neurolabusc/MRIcron/issues/9
function [lut lutfpath] = lutmap(fnm)
lut    =[];
lutfpath=[];
if strcmp(fnm,'show')
    try
      palut=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','lut');
      lut=cellstr(spm_select('List',palut,'.lut$'));
     
      if isempty(char(lut)); lut=[]; 
      else
           lutinv=stradd(lut,['_inv' ],2);%add inverted
           lut=[lut; lutinv];
          lutfpath=stradd(lut,[palut filesep],1);
      end
    catch
       lut=[]; 
    end
    return
end

[pa fi ext]=fileparts(fnm);
isinverted=0;
if ~isempty(regexpi(fi,'_inv$'))
    fi=regexprep(fi,'_inv$','');
    isinverted=1 ;
end

if isempty(pa)
    palut=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','lut');
    fnm=fullfile(palut,[fi '.lut']);
else
    fullfile(pa,[fi '.lut']);
end

%load color lookup table in imageJ/MRIcron lut format or FSLeyes cmap format
if ~exist(fnm,'file'), error('Unable to find %s', fnm); end
lutfpath=fnm;
stats = dir(fnm);
if stats.bytes == 768 %ImageJ/MRIcron format bytes 0..255 RRR..RGGG..GBBB..B
    fid = fopen(fnm,'rb');
    lut = fread(fid);
    fclose(fid);
    lut = reshape(lut,256,3);
    lut = lut / 255; %scale 0..255 -> 0..1
else
    v=preadfile(fnm); v=v.all;
    v(regexpi2(v,'*|index|red|green|blue'))=[];%remove header
    v=regexprep(v,'[a-zA-Z]',''); %replace all letters
    v=str2num(char(v));
    if size(v,2)>3
        v=v(:,1:3);
    end
    lut = v / 255;
end

if isinverted==1
    lut=flipud(lut);
end


% [~,~,x] = fileparts(fnm);
% if strcmpi(x,'.lut'), lut = []; fprintf('Unable to read %s\n', fnm); return; end
% fid = fopen(fnm,'r');
% lut = fscanf(fid,'%f %f %f');
% fclose(fid);
% lut = reshape(lut,3,numel(lut)/3)';



% return
% %loadLutSub()
% if (max(lut(:)) > 1.0) |  (min(lut(:)) < 0), error('RGB should be in range 0..1 %s', fnm); end
% if (size(lut,1) == 255)
%     lut = [[0 0 0];lut];
% end
% if (size(lut,1) < 255)
%     %interpolate
%     lut = [[0 0 0];lut];
%     R = lut(:,1);
%     G = lut(:,1);
%     B = lut(:,1);
%     xq = 1: (numel(R)-1)/255 : numel(R);
%     R = interp1(R,xq);
%     G = interp1(G,xq);
%     B = interp1(B,xq);
%     lut = [R' G' B'];
% end
% %loadLutSub()