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
runs = 1;

while(~isValid)
    runs = runs + 1;
    % Fix halting error
    if runs > 500
        Node = generateNode(robotEnv);
        return
    end

    randomPos = [0, 0];
    isValid = true;
    while(isequal(theta1, []) && isequal(theta2, []))
       randomPos = 80*rand(1,2) - 40;

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
        condition1 = ~logical(isIntersect(base, J1, T1, T2));
        condition2 = ~logical(isIntersect(base, J1, T1, T3));
        condition3 = ~logical(isIntersect(base, J1, T2, T3));
        %Check for intersections with second link
        condition4 = ~logical(isIntersect(J1, J2, T1, T2));
        condition5 = ~logical(isIntersect(J1, J2, T1, T3));
        condition6 = ~logical(isIntersect(J1, J2, T2, T3));
        
        condition = condition1 && condition2 && condition3 && condition4 && condition5 && condition6;
     
        isValid = isValid && condition;
        if isValid && i == length
           Node = [theta1, theta2];
           return
        end
    end
end

Node = [theta1, theta2];


