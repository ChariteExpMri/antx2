%get excelindex (Az,BB...)
function xls_idx = xlsindex(idx)

xls_idx = [];
while idx>0    
   xls_idx = [char(mod(idx-1,26)+65), xls_idx];
   if mod(idx,26)
      idx  = fix(idx/26);
   else
      idx  = fix(idx/26)-1;
   end  
end