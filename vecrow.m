function f = vecrow(y)

[r,c] = size(y);
for i = 1:r
    f((i-1)*c +1: i*c) = y(i,:);
end

