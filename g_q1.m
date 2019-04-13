% Code to grade Q1. 
% Last modified: 9 Apr 2019

nTestCase = 100;
robotEnv = M_TwoLinkArm([]);
L = robotEnv.L1 + robotEnv.L2;
Lmin = robotEnv.L1 - robotEnv.L2;

% Random locations of hand tips
randTipXs = 2*L*rand([1, nTestCase]) - L;
randTipYs = 2*L*rand([1, nTestCase]) - L;

dist = sqrt(randTipXs.^2 + randTipYs.^2);

isPass = ones(1, nTestCase);
for i=1:nTestCase   
   tipX = randTipXs(i);
   tipY = randTipYs(i);
   [theta1, theta2] = q_inverseKinematic(robotEnv, [tipX, tipY]);
   
   if isempty(theta1) || isempty(theta2) % check for reachability
       if dist(i) <= L && dist(i) >= Lmin
           isPass(i) = 0;       
       end
   else 
       if dist(i) > L || dist(i) < Lmin % check for reachability
           isPass(i) = 0;
       else % check for consistency
           [~, ~, tipX2, tipY2] = robotEnv.forwardKinematic(theta1, theta2);

           if max(abs(tipX - tipX2), abs(tipY - tipY2)) > 1e-4
               isPass(i) = 0;
           end
       end
   end
end

fprintf('You pass %d out of %d tests\n', sum(isPass), nTestCase);
