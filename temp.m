close(gcf);
for i=1:100; 
    for j=1:100; 
        if i~= j 
            plot( imageData.data(:,i), imageData.data(:,j), 'kx' ); 
            pause(1); 
        end
    end
end