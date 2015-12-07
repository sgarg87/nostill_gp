function interpolateSurface(positions,values,mode,minLimit,maxLimit)
if (~exist('mode','var'))
    mode=1
end
if (~exist('minLimit','var'))
    minLimit=min(values);
end
if (~exist('maxLimit','var'))
    maxLimit=max(values);
end
if(maxLimit == minLimit)
    maxLimit = 1.1*minLimit;
end

[xi yi zi] = computeSurface(positions,values);
if mode==1
    surf(xi,yi,zi);
elseif mode==2
     %  colormap(gray);
   pcolor(xi,yi,zi);
   colorbar;
     %caxis([minLimit maxLimit]);
     %hc = colorbar;
     %set(hc,'YLim',[minLimit maxLimit]);
     %caxis(hc,[minLimit maxLimit]);
elseif mode==3
    [tmp,h] = contour(xi,yi,zi,[.1:.1:1]);
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
     text_handle = clabel(tmp,h);
     set(text_handle,'BackgroundColor',[1 1 .6],'Edgecolor',[.7 .7 .7])
elseif mode==4
    [cs,h] = contour(xi,yi,zi);
    clabel(cs,h,'fontsize',15);%,'labelspacing',72);
end

function [xi yi zi] = computeSurface(positions, values)

num_nodes = size(positions,1);
x = positions(:,1);
y = positions(:,2);
z = values;

maxx = max(positions(:,1));
minx = min(positions(:,1));

maxy = max(positions(:,2));
miny = min(positions(:,2));

grid_size = 30;
[xi yi] = meshgrid(minx:(maxx-minx)/grid_size:maxx,miny:(maxy-miny)/grid_size:maxy);



%zin = griddata(x,y,z,xi,yi,'nearest');
zi = griddata(x,y,z,xi,yi,'cubic');
% zi = griddata(x,y,z,xi,yi,'nearest');

%wrongs = find(isnan(zi));
%zi(wrongs) = zin(wrongs);








