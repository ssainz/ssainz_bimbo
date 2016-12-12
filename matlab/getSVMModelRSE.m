function [rmsle_mat, models, data_matrix, test_matrix] = getSVMModelRSE()

sizes = {10, 20,30, 40, 50, 60};
sizeChar = {'10', '20','30', '40', '50', '60'};
bimbovars = {'agencia','canal', 'ruta','cliente','producto'};
rse = [];
data_matrix = {};
test_matrix = {};
models = {};
i = 1;

for siz = sizes
    data = getSampleData(1000, siz{1}, 10000);
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
    %NOT CUT TRAIN SET: data_table = data_table(cut_len+1:total_len,:);
    %data_table = data_table(trainInd,:);
    data_matrix{i} = data_table;
    j = 1;
    for vv = bimbovars 
        mdl = fitrsvm(data_table,  'venta', 'PredictorNames', vv, 'CategoricalPredictors', vv,'KernelFunction','gaussian');
        test = predict(mdl, data_table);
        rmsle_mat(i,j) = rmsle(test, data_table.venta);
        models{i,j} = {mdl};
        j = j + 1;
    end
    mdl = fitrsvm(data_table,  'venta', 'PredictorNames', {'semana'},'KernelFunction','gaussian');
    test = predict(mdl, data_table);
    rmsle_mat(i,j) = rmsle(test, data_table.venta);
    models(i,j) = {mdl};
    i = i + 1;
end

rmsle_mat = table(rmsle_mat(:,1), rmsle_mat(:,2), rmsle_mat(:,3), rmsle_mat(:,4), rmsle_mat(:,5), rmsle_mat(:,6), 'VariableNames', {'agencia' 'canal' 'ruta' 'cliente' 'producto' 'samana'}, 'RowNames',sizeChar);

end