function tt=load_lutfile(lutfile)

p.headerlines=1;

%% ========[test]=======================================

if 0
    px='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\dat\20231024_083619_wmstroke_mainstudy_GH2716_TP1_4d_1_1_1'
    lutfile=fullfile(px,'atlas_lut.txt');
    tt=load_lutfile(lutfile);
    
    
    lutfile2=fullfile(px,'LUT_connectome_di_sy__mask.txt')
    tt=load_lutfile(lutfile2);
end
%% ===============================================

% f3=fullfile(md, 'atlas_lut.txt');
t0=preadfile(char(lutfile));t0=t0.all;
tt={};
for i=1:size(t0,1)
    temp=  strsplit(t0{i});
    tt(i, 1:length(temp))=temp;
end
tt(1:p.headerlines,:)=[];




% remove first column if last entry is emptx
% sum_empty=sum(cellfun(@isempty,tt(:,1)))
if isempty(tt{end,1})
    tt(:,1)=[];
end