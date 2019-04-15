function index = findClosestNode(Node, target)

closestIndex = 1;
closestDistance = Inf;
L1 = 20;
L2 = 10;
[~,length] = size(Node);

for i=1:length
    node = Node(:,i);
    theta1 = node(1);
    theta2 = node(2);
    
    x = L1*cos(theta1) + L2;
    y = 0;
    
    newDistance = distance(target, [x,y]);
    
    if (newDistance < closestDistance)
        closestDistance = newDistance;
        closestIndex = i;
    end
end

index = closestIndex;