% close(gcf);  
% for i=1:40; 
%     for j=1:40;
%         for k=1:40
%             if (i ~= j && i ~= k && j~=k ) 
%                 plot3( berkeley_data.data(:,i), berkeley_data.data(:,j), berkeley_data.data(:,k), 'bo' ); 
%                 pause(0.01);
%             end
%         end
%     end
% end


close(gcf);  
for i=1:40; 
    for j=1:40;
            if (i ~= j ) 
                plot( berkeley_data.data(:,i), berkeley_data.data(:,j), 'bo' ); 
                pause(1);
            end
    end
end
