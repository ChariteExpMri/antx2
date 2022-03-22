
% load configuration without GUI
% loadconfig(<projectfilename>)
%% example:
% loadconfig(fullfile(pwd,'proj.m'))
function loadconfig(projectfile)

if 0
    loadconfig(fullfile(pwd,'proj.m'))
end

[pa fi ext]=fileparts(projectfile);
if isempty(pa); pa=pwd; end
cd(pa);

a=preadfile(projectfile);
a=a.all;
eval(strjoin(a,char(10)));

global an
an=x;

showinfo2('project loaded: ',projectfile,[],[],['from STUDY: "' pa '"']);

% disp('<a href="matlab:disp(''projectfile'')">see help of "makeproject"</a>')


