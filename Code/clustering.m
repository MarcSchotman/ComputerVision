function [x_pieces, y_pieces] = clustering(pieces, x_points,  y_points, x_im, y_im)


%start point of cluster centers
cluster_centers = rand(pieces,2);
cluster_centers(:,1) = cluster_centers(:,1) * x_im;

cluster_centers(:,2) = cluster_centers(:,2) * y_im;

for n =1:15
clear struct
for i = 1:length(x_points)
    
    
    
    
    %Finding nearest nabour
    s = sqrt((cluster_centers(:,1)-x_points(i)).^2 + (cluster_centers(:,2) - y_points(i)).^2);
    
    nearest_cluster = find(s ==min(s));
    
    [struct.cluster(nearest_cluster).x(i)] = x_points(i); 
    [struct.cluster(nearest_cluster).y(i)] = y_points(i); 
    
       
    
end
%calculate new cluster points
for i= 1:pieces
   
    if isempty(struct.cluster(i).x)
        %if no closest nabaurs were find it gets assigned a new random spot
        %since there should be exactly 'pieces' amount of clusters 
        cluster_centers(i,1) = rand(1) * x_im;
        cluster_centers(i,2) = rand(1) * y_im;
    else
        x = find(struct.cluster(i).x(:) ~=0);
        x = struct.cluster(i).x(x);

        y = find(struct.cluster(i).y(:) ~=0);
        y = struct.cluster(i).y(y);

        cluster_centers(i,1) = sum(x)/length(x);
        cluster_centers(i,2) = sum(y)/length(y);
    end

    
end
end

x_pieces = cluster_centers(:,1);
y_pieces = cluster_centers(:,2);

    

 
 end