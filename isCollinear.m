function tf = isCollinear(P)

tol = 0;

tf = rank(bsxfun(@minus, P, P(1,:)), tol) < 2;