function Node =  generateNode(robotEnv)
% Node = [theta1, theta2]
% obstacles: m*6 matrix for m obstacles
% obstacles(i,:) is the coordinates of the i^th triangular obstacle: X1, Y1, X2, Y2, X3, Y3
% Make sure there are no collisions!

L1 = robotEnv.L1;
L2 = robotEnv.L2;
theta1 = [];
theta2 = [];
isValid = false;
obstacles = robotEnv.obstacles;

while(~isValid)
    randomPos = [0, 0];
    isValid = true;
    while(isequal(theta1, []) && isequal(theta2, []))
       randomPos = 80*rand(2,1) - 40;

       [theta1, theta2] = q_inverseKinematic(robotEnv, randomPos);
    end
    
    [length, ~] = size(obstacles);
    base = [0,0];
    J1 = [L1*cos(theta1), L1*sin(theta1)];
    J2 = randomPos;
    for i=1:length
        obstacle = obstacles(i,:);
        % Triangle points
        T1 = [obstacle(1), obstacle(2)];
        T2 = [obstacle(3), obstacle(4)];
        T3 = [obstacle(5), obstacle(6)];
        
        %Check for intersections with first link
        condition1 = ~isIntersect(base, J1, T1, T2);
        condition2 = ~isIntersect(base, J1, T1, T3);
        condition3 = ~isIntersect(base, J1, T2, T3);
        %Check for intersections with second link
        condition4 = ~isIntersect(J1, J2, T1, T2);
        condition5 = ~isIntersect(J1, J2, T1, T3);
        condition6 = ~isIntersect(J1, J2, T2, T3);
        %Check for intersections between first and second link
        condition7 = ~isIntersect(base, J1, J1, J2);
        
        condition = condition1 & condition2 & condition3 & condition4 & condition5 & condition6 & condition7;
        isValid = isValid & condition;
    end
end

Node = [theta1, theta2];


