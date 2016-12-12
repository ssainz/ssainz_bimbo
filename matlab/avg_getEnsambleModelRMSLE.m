function [rmsle_mat, rmsle_test_mat, models] =  avg_getEnsambleModelRMSLE(N)


[rmsle_mat_a, rmsle_test_mat_a, models] =  getEnsambleModelRMSLE;

rmsle_mat_final = rmsle_mat_a;
rmsle_test_mat_final = rmsle_test_mat_a;

for i = 2:N
    [rmsle_mat_a, rmsle_test_mat_a, models] =  getEnsambleModelRMSLE;
    rmsle_mat_final = rmsle_mat_final + rmsle_mat_a;
rmsle_test_mat_final = rmsle_test_mat_final + rmsle_test_mat_a;
end
rmsle_mat = rmsle_mat_final ./ N;
rmsle_test_mat = rmsle_test_mat_final ./ N;

end
