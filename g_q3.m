% Some testing environments. We will use different environments to grade your homework.
% obstacles is m*6 matrix for m triangular obstacles
% each row is the list of coordinate of the obstacle: X1 Y1 X2 Y2 X3 Y3
% obstacles = [10 -20, 20, -30, 25, -10; 
%              -10, 10, -20, 20, -15, 10];          


testEnvs = struct();

testId = 1;
testEnvs(testId).obstacles = [];
testEnvs(testId).startXY = [30, 0];
testEnvs(testId).endXY = [-10, 0];

testId = 2;
testEnvs(testId).obstacles = [10 -20, 20, -30, 25, -10; 
                              -10, 10, -20, 20, -15, 10]; 
testEnvs(testId).startXY = [30, 0];
testEnvs(testId).endXY = [-10, 0];


isFails = zeros(1, length(testEnvs));
for i = 1:length(testEnvs)
    fprintf('---> Test case %d/%d\n', i, length(testEnvs));
    robotEnv = M_TwoLinkArm(testEnvs(i).obstacles);

    % we call your planner code to create a planner
    K = 1000;
    [Node, Edge] =  q_createPlanner(robotEnv, K); 

    % we call your plan code to find a plan
    [theta1s, theta2s] = q_plan(Node, Edge, testEnvs(i).startXY, testEnvs(i).endXY);

    % Check if the trajectory is started at the deired start and end points
    [~, ~, startX2, startY2] = robotEnv.forwardKinematic(theta1s(1), theta2s(1));
    [~, ~, endX2, endY2] = robotEnv.forwardKinematic(theta1s(end), theta2s(end));

    desire  = cat(2, testEnvs(i).startXY, testEnvs(i).endXY);
    actual = [startX2, startY2, endX2, endY2];
    
    if sum(abs(desire - actual)) > 1e-3
        fprintf('Fail: your path do not start or end at the desired locations.\n');
        isFails(i) = 1;
    else
        isFails(i) = robotEnv.execute(theta1s, theta2s, 1);
    end        
end

fprintf('\n=======>You pass %d out of %d tests\n', length(testEnvs) - sum(isFails), length(testEnvs));