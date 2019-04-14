bool = isConnected(node1, node2);

theta11 = node1(1);
theta21 = node1(2);

theta12 = node2(1);
theta22 = node2(2);

condition1 = abs(theta11 - theta12) < pi/18;
condition2 = abs(theta21 - theta22) < pi/18;

bool = condition1 & condition2;