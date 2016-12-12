function [rmsle_mat, rmsle_test_mat, models, data_matrix, test_matrix] = avg_getSVMModelRSE_Q(N)

0
[rmsle_mat_a, rmsle_test_mat_a, models, data_matrix, test_matrix] = getSVMModelRSE_Q;
1
rmsle_mat_final = table2array(rmsle_mat_a);
rmsle_test_mat_final = table2array(rmsle_test_mat_a);

for i = 2:N
    [rmsle_mat_a, rmsle_test_mat_a, models, data_matrix, test_matrix] = getSVMModelRSE_Q;
    rmsle_mat_final = rmsle_mat_final + table2array(rmsle_mat_a);
    rmsle_test_mat_final = rmsle_test_mat_final + table2array(rmsle_test_mat_a);
    i
end

rmsle_mat = rmsle_mat_final ./ N;
rmsle_test_mat = rmsle_test_mat_final ./ N;

end