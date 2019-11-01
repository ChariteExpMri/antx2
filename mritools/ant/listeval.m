

function out=listeval(p,ro)

% eval([name '=an;']);
%  ro=an;
% ro=rmfield(ro,'ls');

% eval([name '=ro;']);

% p=struct2list(ro)
% eval(['p=struct2list(' name ')']);


v=1:size(p,1);
for i=1:size(p,1)
    
    if ~isnan(v(i))
        try
            d=p{v(i)};
            eval(d);
            s=1;
            n=0;
        catch
            n=1;
            s=0;
            while s==0
                try
                    d=[d ';' p{v(i+n)}];
                    eval(d);
                    s=1;
                catch
                    n=n+1;
                end
                
            end
        end
        v(i:i+n)=nan;
    end
end
eval(['out' '=' ro ';']);

% varn=who
% varn(strcmp(varn,'varn'))=[]
% varn(strcmp(varn,'ans'))=[]
% 
% for i=1:length(varn)
%     if isstruct()
%     
% end




% 
% 
% 
%     'an.inf99='*** CONFIGURATION PARAMETERS   ***              ';'
%     'an.inf100='===================================';'
%     'an.inf1='% DEFAULTS         ';'
%     'an.project='testData-study1';'
%     'an.datpath='O:\TOMsampleData\study2\dat';'
%     'an.voxsize=[0.07  0.07  0.07];'
%     'an.inf2='% WARPING         ';'
%     'an.wa.refTPM={ 'O:\TOM\mritools\ant\templateBerlin_hres\_b1grey.nii' '
%     '               'O:\TOM\mritools\ant\templateBerlin_hres\_b2white.nii' '
%     '               'O:\TOM\mritools\ant\templateBerlin_hres\_b3csf.nii' };'
%     'an.wa.ano='O:\TOM\mritools\ant\templateBerlin_hres\ANO.nii';'
%     'an.wa.avg='O:\TOM\mritools\ant\templateBerlin_hres\AVGT.nii';'
%     'an.wa.fib='O:\TOM\mritools\ant\templateBerlin_hres\FIBT.nii';'
%     'an.wa.refsample='O:\TOM\mritools\ant\templateBerlin_hres\_sample.nii';'
%     'an.wa.create_gwc=[1];'
%     'an.wa.create_anopcol=[1];'
%     'an.wa.cleanup=[0];'
%     'an.wa.usePCT=[2];'
%     'an.wa.usePriorskullstrip=[1];'
%     'an.wa.elxParamfile={ 'O:\TOM\mritools\elastix\paramfiles\Par0025affine.txt' '
%     '                     'O:\TOM\mritools\elastix\paramfiles\Par0033bspline_EM2.txt' };'
%     'an.wa.elxMaskApproach=[1];'
%     'an.wa.tf_ano=[1];'
%     'an.wa.tf_anopcol=[1];'
%     'an.wa.tf_avg=[1];'
%     'an.wa.tf_refc1=[1];'
%     'an.wa.tf_t2=[1];'
%     'an.wa.tf_c1=[1];'
%     'an.wa.tf_c2=[1];'
%     'an.wa.tf_c3=[1];'
%     'an.wa.tf_c1c2mask=[1];'
%     'an.templatepath='O:\TOMsampleData\study2\templates';'
%     'an.configfile='O:\TOMsampleData\study2\proj_study2.m';'
%     'an.mdirs={ 'O:\TOMsampleData\study2\dat\s20150908_FK_C1M02_1_3_1' '
%     '           'O:\TOMsampleData\study2\dat\s20150908_FK_C1M04_1_3_1' '
%     '           'O:\TOMsampleData\study2\dat\sbla1' '
%     '           'O:\TOMsampleData\study2\dat\sbla2' };'
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% mnext=1;
% for i=1:size(p,1)
%     
%     if i==mnext
%         d=p{i};
%         try
%             eval(d);
%             s=1;
%             mnext=i+1;
%         catch
%             
%             s=0;
%             n=1;
%             dum=char(p(i));
%             while s==0
%                 dum=[dum ';' char(p(i+n))  ];
%                 try
%                     
%                     eval(  [dum] );
%                     s=1;
%                     mnext=i+1;
%                     dum
%                 catch
%                     n=n+1;
%                 end
%             end
%         end
%     end
%     
% end
%    
% % out=ro;
% eval(['out' '=' ro ';']);
% 
%         
%         
        
    




