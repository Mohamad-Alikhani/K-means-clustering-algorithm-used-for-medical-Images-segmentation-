function segmentedImage = KMeans(featureImageIn, numberofClusters, clusterCentersIn)

% Get the dimensions of the input feature image
[M, N, noF] = size(featureImageIn);

% some initialization
if (nargin == 3) && (~isempty(clusterCentersIn))
    NofRadomization = 1;
else
    NofRadomization = 5;    % Should be greater than one
end

segmentedImage = zeros(M, N); %initialize. This will be the output
BestDfit = 1e10;  % Just a big number!
minDistance=[];
rowDistance=[];
totalDistance=[];
optimumDistance=0;
optimumRandNum=0;

newClusterCenters=zeros(numberofClusters,1);
% run KMeans NofRadomization times
for KMeanNo = 1 : NofRadomization
    % randomize if clusterCentersIn was empty
    if NofRadomization>1
        clusterCentersIn = rand(numberofClusters, noF); %randomize initialization
        for i=1 : M
            for j=1 : N
                for k=1 : numberofClusters
                    minValue(k) = norm(reshape(featureImageIn(i,j,:),1,noF)-clusterCentersIn(k,:));             
                    
                end
                [value,index] = min(minValue);   
                minDistance(j)=value;
            end
            rowDistance(i)=sum(minDistance); 
        end
        totalDistance(KMeanNo)=sum(rowDistance);
        clusterCentersInTemp{KMeanNo}=clusterCentersIn;
        minDistance=[];
        rowDistance=[];
    end
    [optimumDistance,optimumRandNum]=min(totalDistance)
    optimumRandomization=cell2mat(clusterCentersInTemp(1,optimumRandNum))   
end

iter=15;
while ~(iter==0)
    segmentedImage = zeros(M,N);
    for i=1:numberofClusters
       cluster{i} = zeros(162,198,noF);
    end
    Size=ones(1,numberofClusters);
    for i=1 : M
        for j=1 : N
            for k = 1 : numberofClusters
                minValue(k) = norm(reshape(featureImageIn(i,j,:),1,noF)-optimumRandomization(k,:));
            end
            [value,index] = min(minValue);
            
            cluster{index}(i,j,:)=featureImageIn(i,j,:);
            Size(index)=Size(index)+1;
            
        end
        
    end
    for i=1 : numberofClusters
        cluster_2D{i}= sum(cluster{i}(:,:,1:noF),noF)/noF;
        cluster_2D{i}(cluster_2D{i}~=0)=0.1*i;
    end
    segmentedImage=sum(cat(3,cluster_2D{:}),3);
    
    for i=1 : numberofClusters
        newCenter{i}=reshape((sum(sum(cluster{i},1),2)/Size(i)),1,noF);
    end

    iter=iter-1;
    
    optimumRandomization =cat(1,newCenter{1:end});
    optimumRandomization
end  
     
   
