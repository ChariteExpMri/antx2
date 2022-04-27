
function varargout = lastmodified(direc, num,flt,rec,show,smod)
% Return filenames and date of the last modified files in direc and subfolders (sorted)
% varargout = lastmodified(direc, num,flt,rec,show)
%% _optional inputs__
% direc:directory to search for files, if not specified the current dir (pwd) is used
% num  :number of files to display/output; if not specified: num=20
% flt  :file filter; if not specified: flt is '.*' (use regexp)
% rec  :[0/1]: search [1] recursively in subfolders of direc; [0] in direc only; if not specified rec=1
% show :[0/1]: show/display results in [1]cmd-window; [0] do not show; if not specified: show=1
% smod : search/sort-mode
%   ..BINARY: [0/1]: obtain [0]oldest or [1] newest (last modified) files; if not specified: smod=1
%   ..STRING:  if smod is a string: search for files form a specific date day-month-year time and/or time HH:MM:SS     
%        of the form: "11-Mar-2020 16:06:44"
%       examples "2020" :search for all files from year 2020
%                "Mar-2020" search for all files from month March of 2020
%                "Mar" search for all files last modified in month March across all years
%                " 11:" : all m-files last modified 11pm over the years
%                ":29:" : all m-files last modified in the 29th min over the years
%       * search within date/time-range via "--" separator:
%       examples: '2019--2020' search all files from 2019 to 2020
%                 '01-Feb-2020--30-Sep-2020'  search all files between 01-Feb-2020 and 30-Sep-2020
%                 'Feb-2020--Sep-2020'        search all files between Feb-2020 and Sep-2020
%                 '2021--2022' %  find all m-files in the years 2021 to 2022
%                 '01-Mar-2022 12:00--01-Mar-2022 16:00' find all m-files from 01-Mar-2022, modified between 12:00 and 16:00
%      * using 'now' ...
%                 'Feb-2020--now' or  '01-Feb-2020--now'  ..using "now"  to obtain files from specific date until now 
% 
%% _optional output__
% table with file + modification date, fullpath-filename
%% [1] Examples:
% lastmodified('F:\data5\nogui', 10); % display the 10 most recently modified files.
% k=lastmodified(pwd, 10,'.*', 1); % return 10 newest files, from all files, search also in subdirs of direc,  with output
% lastmodified('F:\data5\nogui', 10,'.nii', 1); % display 10 newest files, NIFTI(.nii)-files only, search also in subdirs of direc,  with output
% lastmodified(fileparts(which('antlink.m'))); %display the 20-newest (last modified) files from ant-project
% lastmodified(fileparts(which('antlink.m')),[],'.m$'); display the 20-newest (last modified) m-files form ant-project
% kk=lastmodified(fileparts(which('antlink.m')),[10],'.m$',1,0); return 20-newest (last modified) m-files form ant-project, do not display
%% [2] display the 10 oldest m-files from antproject
% lastmodified(fileparts(which('antlink.m')),10,'.m$',1,1,0);
%% [3] search for files from specific time:
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'2020'); %all m-files from 2020
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'Mar-2020');%all m-files from march 2020
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,' 11:'); all m-files last modified 11pm over the years
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,':29:'); all m-files last modified in the 29th min over the years
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'2019--2020'); all m-files from year 2019 to 2020
%% [4] search for files in time/date range time:
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'01-Feb-2020--30-Sep-2020') % find all m-files between 01-Feb-2020 and 30-Sep-2020
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'Feb-2020--Sep-2020'); find all m-files between Feb-2020 and Sep-2020
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'2021--2022'); %  find all m-files in the years 2021 to 2022
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'01-Mar-2022 12:00--01-Mar-2022 16:00'); find all m-files from 01-Mar-2022, between 12:00 and 16:00
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'Feb-2020--now') ;%  find all m-files between Feb-2020 until now
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'2020--now') ;% find all m-files from 2020 until now
% lastmodified(fileparts(which('antlink.m')),[inf],'.m$',1,1,'01-Apr-2022--now');%find all m-files from 01-Apr-2022 until now



if exist('direc')==0 || isempty(direc);   direc=pwd; end
if exist('num')==0   || isempty(num);     num=20   ; end
if exist('flt')==0   || isempty(flt);     flt='.*' ; end
if exist('rec')==0   || isempty(rec);     rec=1    ; end
if exist('show')==0  || isempty(show);    show=1    ; end
if exist('smod')==0   || isempty(smod);     smod=1    ; end
%% ===============================================

if rec==1
    [files] = spm_select('FPListRec',direc,flt);
else
    [files] = spm_select('FPList',direc,flt);
end
if isempty(files)==1
   disp(['..no files found..(direc:"' direc '"; rec:' num2str(rec) '; flt:"' num2str(flt) '")']) ;
   if nargout>0
       varargout={[]};
   end
   return
end
files=cellstr(files);
% dates=repmat({''},[length(files) 1]);
dates=zeros(length(files), 1);
name =repmat({''},[length(files) 1]);
for i=1:length(files)
    k=dir(files{i});
    %dates{i,1}=k.date;
    dates(i,1)=k.datenum;
    name{i,1}=k.name;
end
[datesort isort]=sort(dates,'descend');
name       =name(isort);
nameFP     =files(isort);
datemod    =cellstr(datestr(datesort));
tb=[name  datemod nameFP ];
%% ===============================================
if ischar(smod)
    sep=strfind(smod,'--');
    if isempty(sep) %find date
        tb= tb(regexpi2(datemod,smod),:) ;
        num=inf;
    else % find between two dates
        %% ===============================================
        mode2=dateconv(smod);
        num=inf;
        %mode2=strsplit(smod,'--');
        i1= (regexpi2(datemod,mode2{1}));
        
        if isempty(i1)
            i1=vecnearest2(datesort,datenum(mode2{1}));
            if sign(datenum(mode2{1})-datesort(i1))>0 && i1>0
                i1=i1-1; 
            end
        end
        
        i2= (regexpi2(datemod,mode2{2}));
        if isempty(i2)
            if strcmp(mode2{2},'now')
               mode2{2}=datestr(now);
            end
                i2=vecnearest2(datesort,datenum(mode2{2}));
      
            if sign(datenum(mode2{2})-datesort(i2))<0 && i2<=size(tb,1)
               i2=i2+1; 
            end
        end
        
        if 0
            %iall=[i1(:); i2(:)];
            
            irange=[min(i2) max(i1)];
            tb(irange(1):irange(2),2)
            smod
            
            %test
%             tb(irange(1)-1:irange(2)+1,2)
        end
        %% ===============================================
        irange=[min(i2) max(i1)];
        tb=tb(irange(1):irange(2),:);
        
        
    end
    
else
    if smod==0
        tb=flipud(tb);
    end
end

if size(tb,1)<num; 
    num=size(tb,1);
end
%% ===============================================
if show==1
    htb={'FILE' 'DATE' 'FILE_FULLPATH'};
    line=regexprep(htb,'\w','=');
    if isempty(tb)
        disp('..no files found');
    else
        disp(char(plog([],[[htb;[line;tb(1:num,:)]] ],0,'','plotlines=0;s=2;al=1')));
    end
end
if nargout>0
    varargout{1}=tb(1:num,:);
end
%% ===============================================


function mode2=dateconv(smod)
        
mode2=strsplit(smod,'--');

if regexpi(mode2{1},'\d\d\d\d')==1
   mode2{1}=  (['01-jan-' mode2{1}]);
end
if regexpi(mode2{2},'\d\d\d\d')==1
   mode2{2}=  (['31-Dec-' mode2{2}]);
end









