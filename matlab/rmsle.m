function out = rmsle(v1, v2)
[row1, col1] = size(v1);
[row2, col2] = size(v2);
out = 1;
if (col1 == col2 ) && ( row1 == row2 )
    %remove NaN
    v1(isnan(v2)) = [];
    v2(isnan(v2)) = [];
    v2(isnan(v1)) = [];
    v1(isnan(v1)) = [];
    %v1
    %v2
    if row1 == 1
        v1 = v1';
        v2 = v2';
        row1 = col1;
    end
    temp = (log(v1 + 1) - log(v2 + 1));
    out = sqrt((temp' * temp) / row1);
end 
end