function showhelpx(ff)

g1=@(d) strsplit2(d,char(10))';
g2=@(d) regexprep(d,char(10),'');
g3=@(d,ff) [ [ ' #yk [' ff ']']  ;d];


txt=help(ff);
h1=txt(1:min(strfind(txt,char(10))));

if ~isempty(txt)
    uhelp(g3(g2(g1(txt)),ff));
end
