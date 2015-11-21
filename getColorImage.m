function imageResult = getColorImage(dataImage)
[datarow,datacolumn] = size(dataImage);
imageResult = zeros(datarow,datacolumn,3);
for i=1:datarow
    for j=1:datacolumn          %                R 分量              G分量                 B分量
        if(dataImage(i,j)==1)      
            imageResult(i,j,1)=0;imageResult(i,j,2)=0; imageResult(i,j,3)=0;
        elseif(dataImage(i,j)==2)  
            imageResult(i,j,1)=255;imageResult(i,j,2)=0; imageResult(i,j,3)=0;
        elseif(dataImage(i,j)==3)  
            imageResult(i,j,1)=128;imageResult(i,j,2)=128; imageResult(i,j,3)=128;
        elseif(dataImage(i,j)==4)  
            imageResult(i,j,1)=255;imageResult(i,j,2)=0; imageResult(i,j,3)=255;
        elseif(dataImage(i,j)==5)  
            imageResult(i,j,1)=0;imageResult(i,j,2)=255; imageResult(i,j,3)=0;
        end
    end
end