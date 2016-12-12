function [rmsle_mat, rmsle_test_mat, models, data_matrix, test_matrix] = getSVMModelRSE_Q()
cliente_range = 500;
sizes = {25};
sizeChar = {'25'};
bimbovars = {{'producto' 'cliente'}};
rse = [];
data_matrix = {};
test_matrix = {};
models = {};
i = 1;

for siz = sizes
    data = getSampleData(cliente_range, siz{1}, 10000);
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
    data_table = data_table(trainInd,:);
    data_matrix{i} = data_table;
    j = 1;
    for vv = bimbovars 
        vv{:};
        XX = CreateQuadraticDummyVarSet(data_table, vv{:}, {}, cliente_range);
        [rowXX, colXX] = size(XX);
        XX(:,(colXX+1)) = ones(rowXX,1); 
        YY = table2array(data_table(:,'venta'));
        mdl = fitrsvm(XX,YY, 'KernelFunction','gaussian');
        train_eval = predict(mdl, XX);
        rmsle_mat(i,j) = rmsle(train_eval, YY);
        
        %TEST%
        XX_test = CreateQuadraticDummyVarSet(test_table, vv{:}, {}, cliente_range);
        [rowXX_t, colXX_t] = size(XX_test);
        XX_test(:,(colXX_t+1)) = ones(rowXX_t,1); 
        YY_test = table2array(test_table(:,'venta'));
        test_eval = predict(mdl, XX_test);
        rmsle_test_mat(i,j) = rmsle(test_eval, YY_test);
        %TEST%
        
        models{i,j} = {mdl};
        j = j + 1;
    end
    i = i + 1;
end

rmsle_mat = table(rmsle_mat(:,1), 'VariableNames', {'producto_cliente'}, 'RowNames',sizeChar);
rmsle_test_mat =  table(rmsle_test_mat(:,1), 'VariableNames', {'producto_cliente'}, 'RowNames',sizeChar);
end