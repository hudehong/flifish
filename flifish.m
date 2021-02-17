%Tested with Matlab 6.1 and Matlab R2018b
%need Image Processing Toolbox
%dependency: stormdensitymap.m

% input data format: X, Y, Frame, intensity
load cell1.csv

roi=[524 559 553 588]; % this is the region where the cell locates
scale=10; % scale up factor of STORM image
w=3; % expansion 

xo=ceil((cell1(:,1)-roi(1))*scale);
yo=ceil((cell1(:,2)-roi(3))*scale);
zo=yo*0;
densitymap=stormdensitymap(cell1,10,roi,3);
bw=densitymap>=20;
se= strel('disk',w);
bw2 = double(imdilate(bw,se));
clusterID=0;
clusterSize=0;
i=find(bw2==1);
while ~isempty(i)
    clusterID=clusterID+1;
    x=mod(i(1),size(bw2,1));
    y=(i(1)-x)/size(bw2,1)+1;
    cluster1=double(bwselect(bw2,y,x));
    iPoint=find(cluster1((yo-1)*size(bw2,1)+xo)==1);
    zo(iPoint)=clusterID;
    clusterSize(clusterID)=length(iPoint);
    bw2=bw2-cluster1;
    i=find(bw2==1);
end
figure(1)
hold on
iPoint=find(zo==0);
plot(cell1(iPoint,1),cell1(iPoint,2),'k.')
for clusterID=1:length(clusterSize)
    nrTranscripts=max(1,round(clusterSize(clusterID)/84));
    iPoint=find(zo==clusterID);
    plot(cell1(iPoint,1),cell1(iPoint,2),'r.')
end
axis(roi)
daspect([1 1 1])

figure(2)
imagesc(flipud(densitymap'))
colormap hot
axis off
daspect([1 1 1])
colorbar 

 