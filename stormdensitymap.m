%function to reconstruct STORM image from single molecule position data
%densitymap=stormdensitymap(traj,scale,roi,w)
%traj is the single position x y data array
%scale is image magnification scale, for example, scale=10;
%roi is the data range of single molecule position, for example, roi=[1 100 1 100];
%w is the width in new scale. If a molecule is within the distance of w,
%the molecule is counted.

%written by Dehong Hu on May 26, 2019


function densitymap=stormdensitymap(traj,scale,roi,w)

densitymap=zeros((roi(2)-roi(1))*scale,(roi(4)-roi(3))*scale);
spot=zeros(2*w+1);
for i=-w:w
    for j=-w:w
        if i*i+j*j<=w*w
            spot(i+w+1,j+w+1)=1;
        end
    end
end
i=find(traj(:,1)>roi(1)+(w+1)/scale&traj(:,1)<roi(2)-(1+w)/scale&traj(:,2)>roi(3)+(1+w)/scale&traj(:,2)<roi(4)-(1+w)/scale);
traj1=traj(i,:);
for i=1:size(traj1,1)
    xo=ceil((traj1(i,1)-roi(1))*scale);
    yo=ceil((traj1(i,2)-roi(3))*scale);
    densitymap(xo-w:xo+w,yo-w:yo+w)=densitymap(xo-w:xo+w,yo-w:yo+w)+spot;
end