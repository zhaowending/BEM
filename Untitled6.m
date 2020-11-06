na=size(alpha);
for ii=1:na(1)
    for jj=1:na(2)
        if (imag(alpha(ii,jj)) ~=0)
           fprintf('the complex in (%f, %f) is num %f\n',ii,jj,alpha(ii,jj)); 
           alpha(ii,jj)
           alpha(jj,ii)
        end
    end 
end 