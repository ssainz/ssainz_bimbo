function [rmsle_mat_avg, rmsle_test_mat_avg, rmsle_mat_a, rmsle_mat_test_a, net_mat, tr_mat] = avg_evaluateNN_Q(numberOfNetworks, numberOfTries )

[rmsle_mat_a, rmsle_mat_test_a, net_mat, tr_mat] = evaluateNN_Q(numberOfNetworks);

rmsle_mat_final = sort(rmsle_mat_a);
rmsle_mat_test_final = sort(rmsle_mat_test_a);

for i = 2:numberOfTries
    [rmsle_mat_a, rmsle_mat_test_a, net_mat, tr_mat] = evaluateNN_Q(numberOfNetworks);
    rmsle_mat_final = rmsle_mat_final + sort(rmsle_mat_a);
    rmsle_mat_test_final = rmsle_mat_test_final + sort(rmsle_mat_test_a);
    i
end

rmsle_mat_avg = rmsle_mat_final ./ numberOfTries;
rmsle_test_mat_avg = rmsle_mat_test_final ./ numberOfTries;
end