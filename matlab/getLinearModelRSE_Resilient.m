function [data_matrix, rmsle_mat,rmsle_mat_test, test_matrix] = getLinearModelRSE_Resilient()
%cliente_size = 1000;
cliente_size = 500;
sizes = {10, 20, 40};
sizeChar = {'10', '20','40'};
%sizes = {10};
%sizeChar = {'10'};
bimbovars = {'agencia','canal', 'ruta','cliente','producto'};
data_matrix = {};
test_matrix = {};
models = {};
i = 1;

for siz = sizes
    data = getSampleData(cliente_size, siz{1}, 10000);
    data_mat = cell2mat(data);
    %normalize week from 3 - 9 to values between 0 - 1:
    data_mat(:,2) = (data_mat(:,2) - 3) / 6;
    %add entry for the max values of each matrix.
    total_len = size(data_mat, 1);
    %id, Semana, Agencia_ID, Canal_ID, Ruta_SAK, Cliente_ID, Producto_ID, Venta_Adjusted
    %data_mat(total_len+1,:) = [1 1 533 10 3604 100000 1800 1] ;
    %class(data_mat)
    %size(data_mat)
    data_table = table(data_mat(:,1),data_mat(:,2),data_mat(:,3),data_mat(:,4),data_mat(:,5),data_mat(:,6),data_mat(:,7),data_mat(:,8), 'VariableNames', {'id', 'semana', 'agencia','canal', 'ruta','cliente','producto','venta'});
    total_len = size(data_mat, 1);
    [trainInd,valInd,testInd] = dividerand(total_len,0.5,0,0.5);
    %cut_len = floor(total_len / 2);
    %test_table = data_table(1:cut_len,:);
    test_table = data_table(testInd,:);
    test_matrix{i}=test_table;
    %data_table = data_table(cut_len+1:total_len,:);
    data_table = data_table(trainInd,:);
    data_matrix{i} = data_table;
    j = 1;
    for vv = bimbovars 
        array_dummy_var = createDummyVarSet(data_table, vv, {}, cliente_size);
        %vv
        yy = table2array(data_table(:,8));
        B = linearRegression(array_dummy_var, yy);
        %size(B)
        %size(array_dummy_var)
        evaluationMod = array_dummy_var * B;
        rmsle_mat(i,j) = rmsle(evaluationMod, yy);
        models{i,j} = {B};
        
        %TEST Eval
        array_dummy_var_test = createDummyVarSet(test_table, vv, {},cliente_size);
        evaluationModTest = array_dummy_var_test * B;
        yy_test = table2array(test_table(:,8));
        rmsle_mat_test(i,j) = rmsle(evaluationModTest, yy_test);
        %TEST Eval
        
        j = j + 1;
    end
    
    array_dummy_var = createDummyVarSet(data_table, {}, {'semana'}, cliente_size);
    yy = table2array(data_table(:,8));
    B = linearRegression(array_dummy_var, yy);
    %size(B)
    %size(array_dummy_var)
    evaluationMod = array_dummy_var * B;
    rmsle_mat(i,j) = rmsle(evaluationMod, yy);
    models(i,j) = {B};
    
    %TEST
    array_dummy_var_test = createDummyVarSet(test_table, {}, {'semana'},cliente_size);
    evaluationModTest = array_dummy_var_test * B;
    yy_test = table2array(test_table(:,8));
    rmsle_mat_test(i,j) = rmsle(evaluationModTest, yy_test);
    %TEST
    
    i = i + 1;
end

rmsle_mat = table(rmsle_mat(:,1), rmsle_mat(:,2), rmsle_mat(:,3), rmsle_mat(:,4), rmsle_mat(:,5), rmsle_mat(:,6), 'VariableNames', {'agencia' 'canal' 'ruta' 'cliente' 'producto' 'samana'}, 'RowNames',sizeChar);
rmsle_mat_test = table(rmsle_mat_test(:,1), rmsle_mat_test(:,2), rmsle_mat_test(:,3), rmsle_mat_test(:,4), rmsle_mat_test(:,5), rmsle_mat_test(:,6), 'VariableNames', {'agencia' 'canal' 'ruta' 'cliente' 'producto' 'samana'}, 'RowNames',sizeChar);

end