


 function tx4=relabel(tx)
 if ~exist('tx')
   us   =get(gcf,'userdata');  
   tx   =us.tablec;
 end


head =tx(1,:);

%xyz
kep=find(cellfun('isempty',strfind(head,'xyzMNI'))==0);
dx=tx(2:end,kep);
dx=str2num(char(dx));
co=num2cell(dx);
co=cellfun(@(co) {[ sprintf('%4.0f ',co) ]} ,co);
head=[head(1:kep-1) 'x' 'y' 'z' head(kep+1:end)];
tx=[tx(:,1:kep-1) [{'x' 'y' 'z'};co ] tx(:,kep+1:end)];

%delete columns
kep=cellfun('isempty',strfind(head,' TP'));
head=head(kep);
tx  =tx(:,kep);
kep=cellfun('isempty',strfind(head,' Lobes'));
head=head(kep);
tx  =tx(:,kep);

kep=cellfun('isempty',regexpi(head,'N$'));
head=head(kep);
tx  =tx(:,kep);


tx2  =tx(2:end,:);
% tx0  =tx2;

%HEMISP
kep=find(cellfun('isempty',strfind(head,' Hem'))==0);
tx(:,kep)=regexprep(tx(:,kep),...
    {'L C.$' 'R C.$' ' Cerebellum' 'BS.'},...
    {'L'     'R'     ''             ''});


heads2ana=head;

% heads2ana={' Labels' 'BAs+' '_BA-TAL-NGM' 'aal' ...
%     '_Eickhoff' 'IBASPM 71' 'IBASPM 116' ' Lobes' };%' Hem'  }

cols=[];
for i=1:size(tx2,2)
  if ~isempty(find( ~cellfun('isempty',strfind(heads2ana, head{i}))));
    cols(end+1,1)= i;
  end
end
icopy=setdiff( [1:size(tx2,2)]' ,cols(:)');
ieickhoff=find(~cellfun('isempty',strfind(head,'Eickhoff')));
iBA      =find(~cellfun('isempty',strfind(head,'BAs')));

%% eee
% tx=us.tablec;

 rep0={};
rep0(end+1,:)={'^Occip' '^Occipital'  };
rep0(end+1,:)={'^par'   '^parietal'  };
rep0(end+1,:)={'^front' '^frontal'  };
rep0(end+1,:)={'^temp'  '^temporal'  };
rep0(end+1,:)={'^ant'   '^anterior'  };
rep0(end+1,:)={'^post'  '^posterior'  };
rep0(end+1,:)={'^lat'   '^lateral'  };
rep0(end+1,:)={'^Mid'   '^middle'  };
rep0(end+1,:)={'^med'   '^medial'  };
rep0(end+1,:)={'^inf'   '^inferior'  };
rep0(end+1,:)={'^sup'   '^superior'  };
rep0(end+1,:)={'^orb'   '^orbital'  };
rep0(end+1,:)={'^gyr'   '^Gyrus'  };
rep0(end+1,:)={'^lo'    '^lobe'  };
rep0(end+1,:)={'^oper'    '^operculum'  };
rep0(end+1,:)={'^occipitoTemp'    '^occipitotemporal'  };
rep0(end+1,:)={'^supp'    '^supplementary'  };
 
xa=rep0(:,1);
xb=rep0(:,2);
se1= [cellfun(@(xa)  {[' ' xa(2:end) ' ']} ,xa) ... %MIDDLE
       cellfun(@(xb)  {[' ' xb(2:end) ' ']} ,xb)  ];
se2= [cellfun(@(xa)  {[ xa(2:end) '$']} ,xa) ... %END
       cellfun(@(xb)  {[xb(2:end) '']} ,xb)  ]   ;
se3= [cellfun(@(xa)   {[ xa(1:end) ' ']} ,xa) ... %START
       cellfun(@(xb)  {[xb(2:end) ' ']} ,xb)  ]; 
se3a= [cellfun(@(xa)   {[ xa(1:end) '-']} ,xa) ... %START-
       cellfun(@(xb)  {[xb(2:end) '-']} ,xb)  ]; 
   
se4= [cellfun(@(xa)  {['-' xa(2:end) ' ']} ,xa) ... %-MIDDLE
       cellfun(@(xb)  {['-' xb(2:end) ' ']} ,xb)  ];
se5= [cellfun(@(xa)  {[' ' xa(2:end) '-']} ,xa) ... % MIDDLE-
       cellfun(@(xb)  {[' ' xb(2:end) '-']} ,xb)  ] ; 
   se6= [cellfun(@(xa)  {['-' xa(2:end) '-']} ,xa) ... % -MIDDLE-
       cellfun(@(xb)  {['-' xb(2:end) '-']} ,xb)  ];
rep=[se1;se2;se3;se3a; se4;se5;se6];
   

 
rep(end+1,:)={'-L$' ''  };
rep(end+1,:)={'-R$' ''  };
rep(end+1,:)={' L$' ''  };
rep(end+1,:)={' R$' ''  };
rep(end+1,:)={' R C.$' 'R'  };
rep(end+1,:)={' L C.$' 'L'  };
rep(end+1,:)={' BS.$' 'Brainstem'  }; 
rep(end+1,:)={' iHem$' 'interhemispheric'  };
%specific
rep(end+1,:)={' ^Th-' 'Thalamus'  };
rep(end+1,:)={'Th-' 'Thalamus '  };
rep(end+1,:)={' ^Amyg ' 'Amygdala '  };



pre={'orbital' 'lateral' 'ventral'  'temporal' 'middle' 'medial'...
    'inferior' 'superior' };


% tx3(:,icopy)=tx2( :,icopy);
tx3={};
for i=1:length(cols)
    c=cols(i);
    tx3(:,i)= regexprep(tx2(:,c), rep(:,1)',rep(:,2)','ignorecase');

   if strcmp(head(cols(i)),'x') | strcmp(head(cols(i)),'y') | strcmp(head(cols(i)),'z')  
       continue
   end  
       
       
    for j=1:size(tx3(:,i),1)
        try
            for k=1:length(pre)
                if ~isempty(strfind(tx3{j,i},pre{k}))
                    tx3{j,i}= [pre{k} ' ' regexprep(tx3{j,i},pre{k},'')];
                end
            end
        end
        if c~=ieickhoff
            try
                tx3(j,i)={[upper(tx3{j,i}(1)) lower(tx3{j,i}(2:end)) ]};
            end
        end
        if c~=iBA
            tx3{j,i}= [  regexprep(tx3{j,i},'Ba','')];
        end
        try
            tx3{j,i}= [  regexprep(tx3{j,i},'-',' ')];
            tx3{j,i}=  regexprep(tx3{j,i},{'    ', '   ','  '},{' ',' ',' '});
        end
    end
   
    
end

tx3=[head(cols); tx3];



% %xyz
% kep=find(cellfun('isempty',strfind(head,'xyzMNI'))==0);
% dx=tx(2:end,kep);
% dx=str2num(char(dx));
% co=num2cell(dx);
% co=cellfun(@(co) {[ sprintf('%5.0f',co) ]} ,co);
% head=[head(1:kep-1) 'x' 'y' 'z' head(kep+1:end)];
% tx=[tx(:,1:kep-1) [{'x' 'y' 'z'};co ] tx(:,kep+1:end)];








tx4={};
tx4(:,cols)=tx3;
tx4(:,icopy)=tx(:,icopy);




%-------------BA-----------------------
head2=tx4(1,:);
b1=find(cellfun('isempty',strfind(head2,' BAs+'))==0);
b2=find(cellfun('isempty',strfind(head2,'_BA-TAL-NGM'))==0);
nonempt=find(~cellfun('isempty',tx4(:,[b1]))==1);
for i=2:size(tx4,1);
    if  isempty(   tx4{i,b1}  );
        if ~isempty(tx4{i,b2}   );
             tx4{i,b1}=['*' tx4{i,b2}  ];
        end
    end
end
tx4(2:end,b1)=regexprep(tx4(2:end,b1),{'BA' },'');
tx4(1,b1)={'BA'};
tx4(:,b2)=[];

%-------------resort-----------------------
head2=tx4(1,:);

tx4(1,:)=regexprep(tx4(1,:),{' Hem'  '_Eickhoff' 'aal' 'stats'  },{'Hem'  'Eickhoff' 'AAL' 'Stats'} );

%delete this
tx4( :, strcmp(tx4(1,:),'Hem')) =[];

%resort
i1=  find(strcmp(tx4(1,:),'BA')) ;
idef=setdiff(1:size(tx4,2), i1);
tx4=tx4(:,[ idef i1 ]);
% 
% try
% tx4=tx4(:, [ 7 9:12  13 [1 3 2] [4:6] 8]);
% catch
%    try
%      tx4=tx4(:, [ 4 6:9  10 [1:3]  5]);  %label hem xyz BA
%        
%    catch
%       disp('bug resort'); 
%    end
%     
% end

% tx4=tx4([])


% dx=tx4(:,b2)
% dx(nonempt)={''}
% % dx=regexprep(tx4(empt,b2),' ','')
% ds=regexprep(dx,'.*\d$','*')
% dz=tx4(:,b1)





