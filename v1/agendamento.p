using Progress.Json.ObjectModel.*.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using progress.Lang.error.
using com.totvs.framework.api.*.

{utp/ut-api.i}
{utp/ut-api-action.i pi-metadata get /metadata/~* }
{utp/ut-api-action.i pi-driver-find get /condutor/~*/~* }
{utp/ut-api-action.i pi-driver-list get /condutor/~* }
{utp/ut-api-action.i pi-find get /~*/~* }
{utp/ut-api-action.i pi-list get /~* }
{utp/ut-api-action.i pi-create post /~* } 
{utp/ut-api-action.i pi-update put /~*/~* } 
{utp/ut-api-action.i pi-delete delete /~*/~* } 
{cstp/api/v1/services/environments.i}
{utp/ut-api-notfound.i}
{method/dbotterr.i}
{cstp/api/v1/services/bocst0197.i ttAgendamento}
{cstp/api/v1/services/bocst0081.i ttCondutor}
{cstp/api/v1/services/agendamento-metadata.i}

define variable boHandler as handle no-undo.
def new Global shared var c-seg-usuario as char format "x(12)" no-undo.


/*****************************************************************************
                          PESQUISAR AGENDAMENTO 
******************************************************************************/
procedure pi-find:
    define input  param oReq       as JsonObject           no-undo.
    define output param oRes       as JsonObject           no-undo. 
    define variable oJsonObject    as JsonObject           no-undo.
    define variable oJsonObjectRes as JsonObject           no-undo.
    define variable cPathParams    as character            no-undo.
    define variable oMsg           as JsonObject           no-undo.
    define variable aMsgArray      as JsonArray            no-undo.
    define variable cFieldList     as character            no-undo.
    define variable i              as integer              no-undo.
    define variable aArrayList     as JsonArray            no-undo.
    define variable iId            as integer              no-undo.
    define variable c-hora-ini     as character            no-undo.
    define variable c-hora-fin     as character            no-undo.
    define variable lTodos         as logical initial true no-undo.

    assign
        cPathParams  = oReq:getJsonArray("pathParams"):GetCharacter(1)
        iId          = integer(cPathParams) 
        aArrayList   = new JsonArray().
        
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0197.p persistent set boHandler.
    end.

    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).
    run emptyRowErrors    in boHandler.
    run getRowErrors      in boHandler (output table RowErrors append).
    run goToKey           in boHandler (input iId).

    if upper(return-value) = "OK":U then do:
        run getRecord in boHandler (output table ttAgendamento).

        for each ttAgendamento no-lock:
            assign
            ttAgendamento.prev_hora_inic = substring(ttAgendamento.prev_hora_inic,1,2) + ":" + substring(ttAgendamento.prev_hora_inic,3,2)
            ttAgendamento.prev_hora_fin  = substring(ttAgendamento.prev_hora_fin,1,2)  + ":" + substring(ttAgendamento.prev_hora_fin,3,2).
        end.

        assign 
            oJsonObject    = new jsonObject()
            oJsonObjectRes = new jsonObject()
            oJsonObject    = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttAgendamento:handle)
            oJsonObjectRes = oJsonObject:getJsonArray("ttAgendamento"):getJsonObject(1).
            
        for first hcm.funcionario no-lock where funcionario.cdn_funcionario = oJsonObjectRes:getinteger('condutor'):
            oJsonObjectRes:add('nome_condutor', funcionario.nom_pessoa_fisic).
        end.

        for first cst_veiculos no-lock where cst_veiculos.placa = oJsonObjectRes:getcharacter('placa'):
            oJsonObjectRes:add('modelo', cst_veiculos.modelo).
        end.

        assign oRes = JsonApiResponseBuilder:ok(oJsonObjectRes, 200).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.

        return.
    end.
    else do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorHelp", "Agendamento " + string(cPathParams) + " nÆo encontrado na base de dados!").
        oMsg:add("ErrorNumber", 1).
        oMsg:add("ErrorDescription", "Agendamento nÆo encontrado!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
   
    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.

/*****************************************************************************
                             LISTAR AGENDAMENTOS 
******************************************************************************/
procedure pi-list:
    
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable rId           as rowid                no-undo.
    define variable iReturnedRows as integer              no-undo.
    define variable iStartRow     as integer              no-undo.
    define variable iPageSize     as integer              no-undo.
    define variable iPage         as integer              no-undo.    
    define variable oRequest      as JsonAPIRequestParser no-undo.
    define variable iQtd          as integer              no-undo.
    define variable iContIni      as integer              no-undo.
    define variable iContFin      as integer              no-undo.
    define variable hasNext       as logical initial true no-undo.
    define variable hasFirst      as logical initial true no-undo.
    define variable c-hora-ini    as character            no-undo.
    define variable c-hora-fin    as character            no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable i             as integer              no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
    define variable cPlaca        as character            no-undo.
    define variable cModelo       as character            no-undo.
    define variable cCondutor     as character            no-undo.
    define variable iAgendamento  as integer              no-undo.
    define variable cSearch       as character            no-undo.
    define variable dData         as date                 no-undo.
    define variable lTodos        as logical              no-undo.

    assign
        orequest      = new JsonAPIRequestParser(oReq)
        oQueryParams  = new JsonObject()
        aJsonArray    = new JsonArray()
        aJsonArrayRes = new JsonArray()
        oQueryParams  = oReq:getJsonObject("queryParams")
        iStartRow     = oRequest:getStartRow()
        iPageSize     = oRequest:getPageSize()
        iPage         = oRequest:getPage().
        
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0197.p persistent set boHandler.
    end.

    if oQueryParams:has("todos") then
        assign lTodos = logical(oQueryParams:GetJsonArray("todos"):getJsonText(1)).
    else     
        assign lTodos = false.

    if oQueryParams:has("placa") and oQueryParams:has("modelo") and oQueryParams:has("nome_condutor") then do:
        assign 
            cPlaca    = string(oQueryParams:GetJsonArray("placa"):getJsonText(1))
            cModelo   = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1))
            cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).

        run setConstraintPlacaModeloCondutor in boHandler (input cPlaca, input cModelo, input cCondutor, input lTodos).
        run openQueryStatic                  in boHandler (input "PlacaModeloCondutor":U).
        run emptyRowErrors                   in boHandler.
        run getFirst                         in boHandler.
    end.
    else if oQueryParams:has("placa") then do:
        assign cPlaca = string(oQueryParams:GetJsonArray("placa"):getJsonText(1)).
        run setConstraintPlaca in boHandler (input cPlaca, input lTodos).
        run openQueryStatic    in boHandler (input "Placa":U).
        run emptyRowErrors     in boHandler.
        run getFirst           in boHandler.
    end.
    else if oQueryParams:has("modelo") then do:
        assign cModelo = string(oQueryParams:GetJsonArray("modelo"):getJsonText(1)).
        run setConstraintModelo in boHandler (input cModelo, input lTodos).
        run openQueryStatic     in boHandler (input "Modelo":U).
        run emptyRowErrors      in boHandler.
        run getFirst            in boHandler.
    end.
    else if oQueryParams:has("nome_condutor") then do:
        assign cCondutor = string(oQueryParams:GetJsonArray("nome_condutor"):getJsonText(1)).
        run setConstraintCondutor in boHandler (input cCondutor, input lTodos).
        run openQueryStatic     in boHandler (input "Condutor":U).
        run emptyRowErrors      in boHandler.
        run getFirst            in boHandler.
    end.
    else if oQueryParams:has("search") then do:
        assign
            cSearch = string(oQueryParams:GetJsonArray("search"):getJsonText(1))
            iAgendamento = integer(cSearch) no-error.
        if error-status:error then do:
            run setConstraintPlacaModeloCondutor in boHandler (input cSearch, input cSearch, input cSearch, input lTodos).
            run openQueryStatic in boHandler (input "Search":U).
            run emptyRowErrors  in boHandler.
            run getFirst        in boHandler.
        end.
        else do:
            run setConstraintAgendamento in boHandler (input iAgendamento, input lTodos).
            run openQueryStatic in boHandler (input "Agendamento":U).
            run emptyRowErrors  in boHandler.
            run getFirst        in boHandler.
        end.
    end.
    else if oQueryParams:has("filter") then do:
        assign
            cSearch      = string(oQueryParams:GetJsonArray("filter"):getJsonText(1))
            iAgendamento = integer(cSearch) no-error.
        if cSearch <> "" then do:
            if error-status:error then do:
                run setConstraintPlacaModeloCondutor in boHandler (input cSearch, input cSearch, input cSearch, input false).
                run openQueryStatic in boHandler (input "Filter":U).
                run emptyRowErrors  in boHandler.
                run getFirst        in boHandler.
            end.
            else do:
                run setConstraintAgendamento in boHandler (input iAgendamento, input false).
                run openQueryStatic in boHandler (input "AgendamentoFilter":U).
                run emptyRowErrors  in boHandler.
                run getFirst        in boHandler.
            end.
        end.
        else do:
            run setConstraintMain in boHandler (input false).
            run openQueryStatic   in boHandler (input "MainFilter":U).
            run emptyRowErrors    in boHandler.
            run getFirst          in boHandler.
        end.
    end.
    else if oQueryParams:has("data") then do:
        assign dData = date(oQueryParams:GetJsonArray("data"):getJsonText(1)).
        run setConstraintData in boHandler (input dData, input lTodos).
        run openQueryStatic   in boHandler (input "Data":U).
        run emptyRowErrors    in boHandler.
        run getFirst          in boHandler.
    end.
    else do:
        run setConstraintMain in boHandler (input lTodos).
        run openQueryStatic in boHandler (input "Main":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
    end.

     if return-value = "NOK" then do:
        aJsonArray = new JsonArray().
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, false).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if iStartRow > 1 then do:
        assign iContFin = iStartRow - 1.
        do iContIni = 1 to iContFin:
            run getNext in boHandler.
            if return-value = "NOK":U then do:
                run emptyRowErrors in boHandler.
                assign hasNext  = false.
                if  iStartRow > iContIni then
                    assign hasFirst = false.
                leave.
            end.
        end.
    end.
    
    if hasFirst then do:
        run getRowid in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input  rId, //parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input  no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input  iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttAgendamento //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
        ).
        if iReturnedRows < iPageSize then do:
            assign hasNext = false.
        end.
        else do:
            run getFirst in boHandler.
            do iContIni = 1 to (iPage * ipageSize):
                run getNext in boHandler.
                if return-value = "NOK":U then do:
                    run emptyRowErrors in boHandler.
                    assign hasNext = false.
                    leave.
                end.
            end.
        end.
    end.
   
    run getRowErrors in boHandler (output table RowErrors append).
    
    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:

        for each ttAgendamento no-lock:
            assign
            ttAgendamento.prev_hora_inic = substring(ttAgendamento.prev_hora_inic,1,2) + ":" + substring(ttAgendamento.prev_hora_inic,3,2)
            ttAgendamento.prev_hora_fin  = substring(ttAgendamento.prev_hora_fin,1,2)  + ":" + substring(ttAgendamento.prev_hora_fin,3,2).
        end.


        assign
            aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttAgendamento:handle).
            aJsonArrayRes = new jsonArray().
        do i = 1 to iReturnedRows:
            oJsonObject = new jsonObject().
            oJsonObject = aJsonArray:getJsonObject(i).
                    
            for first hcm.funcionario no-lock where funcionario.cdn_funcionario = oJsonObject:getinteger('condutor'):
                oJsonObject:add('nome_condutor', funcionario.nom_pessoa_fisic).
            end.

            for first cst_veiculos no-lock where cst_veiculos.placa = oJsonObject:getcharacter('placa'):
                oJsonObject:add('modelo', cst_veiculos.modelo).
            end.

            if(oJsonObject:getinteger('situacao') <> 0 and oJsonObject:getinteger('situacao') <> 4) then
                oJsonObject:add('fechado', false).
            else
                oJsonObject:add('fechado', true).
             
            oJsonObject:add('label', oJsonObject:getcharacter('placa')).
            oJsonObject:add('value', oJsonObject:getinteger('agendamento_id')).
            aJsonArrayRes:add(oJsonObject).
        end.
        assign aJsonArray = aJsonArrayRes.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch. 
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.


/*****************************************************************************
                             CADASTRAR AGENDAMENTO 
******************************************************************************/
procedure pi-create:
    define input  param oReq as JsonObject            no-undo.
    define output param oRes as JsonObject            no-undo.
    define variable oRequest as JsonAPIRequestParser  no-undo.
    define variable oPayload as JsonObject            no-undo.
    define variable oMsg     as JsonObject            no-undo.
    define variable pType    as char initial "Create" no-undo.
   
    assign 
        oRequest = new JsonAPIRequestParser(oReq)
        oPayload = oRequest:getPayload().
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0197.p persistent set boHandler.
    end.

    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    
    create ttAgendamento.

    ttAgendamento.agendamento_id = next-value(seq_agendam_veic).
    
    find first ttAgendamento no-lock no-error.
    
    if oPayload:has('placa':U) then do:
        ttAgendamento.placa = oPayload:getCharacter('placa').
        IF oPayload:getCharacter('placa') = "AOA6173" THEN
        DO:
            ASSIGN
            ttAgendamento.situacao = 2
            ttAgendamento.aprovador = "Sistema"
            ttAgendamento.consideracoes_aprov = "Libera‡Æo Autom tica - Ve¡culo Manuten‡Æo"
            ttAgendamento.dt_aprov = TODAY
            ttAgendamento.hr_aprov = STRING(TIME,"HH:MM:SS").
        END.
    end.
    if oPayload:has('condutor':U) then do:
        ttAgendamento.condutor = oPayload:getInteger('condutor').
    end.
    if oPayload:has('prev_data_inic':U) then do:
        ttAgendamento.prev_data_inic = oPayload:getDate('prev_data_inic').
    end.
    if oPayload:has('prev_hora_inic':U) then do:
        ttAgendamento.prev_hora_inic = substring(oPayload:getCharacter('prev_hora_inic'),1,2) + substring(oPayload:getCharacter('prev_hora_inic'),4,2).
    end.
    if oPayload:has('prev_data_fin':U) then do:
        ttAgendamento.prev_data_fin = oPayload:getDate('prev_data_fin').
    end.
    if oPayload:has('prev_hora_fin':U) then do:
        ttAgendamento.prev_hora_fin = substring(oPayload:getCharacter('prev_hora_fin'),1,2) + substring(oPayload:getCharacter('prev_hora_fin'),4,2).
    end.
    if oPayload:has('destino':U) then do:
        ttAgendamento.destino = oPayload:getCharacter('destino').
    end.
    if oPayload:has('motivo':U) then do:
        ttAgendamento.motivo = oPayload:getCharacter('motivo').
    end.
    
    assign
    ttAgendamento.user_agendamento = c-seg-usuario
    ttAgendamento.dt_agendamento   = TODAY
    ttAgendamento.hr_agendamento   = STRING(TIME,"HH:MM:SS").

    run setRecord      in boHandler (input table ttAgendamento).
    run validateRecord in boHandler (input pType).
    run getRowErrors   in boHandler (output table RowErrors append).
    
    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:
        run createRecord       in boHandler.
        run createPendenciaMLA in boHandler (input pType).
        run getRowErrors       in boHandler (output table RowErrors append).

        if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
            assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
        end.
        else do:
            oMsg = new JSONObject().
            oMsg:add("code", 2).
            oMsg:add("message", "Solicita‡Æo de Aprova‡Æo Enviada!").
            oMsg:add("detailedMessage", "O agendamento " + string(ttAgendamento.agendamento_id) + " foi submetido … aprova‡Æo!").
            assign oRes = JsonApiResponseBuilder:ok(oMsg, 201).
        end.
    end.
    
    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally:
        if valid-handle(boHandler) then
            run destroy in boHandler.
        delete procedure boHandler no-error. 
    end finally. 
    
end procedure.
 

/*****************************************************************************
                            ATUALIZAR AGENDAMENTO 
******************************************************************************/
procedure pi-update:
    define input  param oReq    as JsonObject            no-undo.                                                                   
    define output param oRes    as JsonObject            no-undo.                                                                   
    define variable oRequest    as JsonAPIRequestParser  no-undo.                                                                   
    define variable oPayload    as JsonObject            no-undo.                                                                   
    define variable oMsg        as JsonObject            no-undo.
    define variable aMsgArray   as JsonArray             no-undo.
    define variable pType       as char initial "Update" no-undo.                                                                   
    define variable cPathParams as character             no-undo.
    define variable lTodos      as logical initial true  no-undo.
                                                                                                                                  
    assign 
        oRequest  = new JsonAPIRequestParser(oReq)                                                                            
        oPayload  = oRequest:getPayload()                                                                                     
        cPathParams = oRequest:getPathParams():GetCharacter(1).                                                          
                                                                                                                                  
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0197.p persistent set boHandler.
    end.                                                                
    
    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).                                                                        
    run emptyRowErrors    in boHandler.                                                                                              
    run goToKey           in boHandler (input cPathParams).                                                                                   
                                                                                                                                  
    if return-value = "NOK" then do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorHelp", "Agendamento " + cPathParams  + " nÆo encontrado na base de dados!").
        oMsg:add("ErrorNumber", 1).
        oMsg:add("ErrorDescription", "Agendamento nÆo encontrado!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.                                                                                                               
    end.

    run getRecord in boHandler (output table ttAgendamento).
    find first ttAgendamento no-lock no-error.
   
    if ttAgendamento.situacao <> 1 then do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorNumber", 2).
        oMsg:add("ErrorDescription", "Agendamento nÆo pode ser alterado!").
        oMsg:add("ErrorHelp", "Somente agendamentos com status 'Pendente de Aprova‡Æo' podem ser alterados!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 400).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.                                                                                                               
    end. 

    if oPayload:has('placa':U) then do:
        ttAgendamento.placa = oPayload:getCharacter('placa').
    end.
    if oPayload:has('condutor':U) then do:
        ttAgendamento.condutor = oPayload:getInteger('condutor').
    end.
    if oPayload:has('prev_data_inic':U) then do:
        ttAgendamento.prev_data_inic = oPayload:getDate('prev_data_inic').
    end.
    if oPayload:has('prev_hora_inic':U) then do:
        ttAgendamento.prev_hora_inic = substring(oPayload:getCharacter('prev_hora_inic'),1,2) + substring(oPayload:getCharacter('prev_hora_inic'),4,2).
    end.
    if oPayload:has('prev_data_fin':U) then do:
        ttAgendamento.prev_data_fin = oPayload:getDate('prev_data_fin').
    end.
    if oPayload:has('prev_hora_fin':U) then do:
        ttAgendamento.prev_hora_fin = substring(oPayload:getCharacter('prev_hora_fin'),1,2) + substring(oPayload:getCharacter('prev_hora_fin'),4,2).
    end.
    if oPayload:has('destino':U) then do:
        ttAgendamento.destino = oPayload:getCharacter('destino').
    end.
    if oPayload:has('motivo':U) then do:
        ttAgendamento.motivo = oPayload:getCharacter('motivo').
    end.
    
    run setRecord      in boHandler (input table ttAgendamento).
    run validateRecord in boHandler (input pType).
    run getRowErrors   in boHandler (output table RowErrors append).

    if not can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        run updateRecord in boHandler.
        run getRowErrors in boHandler (output table RowErrors append).
    end.
    
    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).

        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.
   
    else do :
        oMsg = new JSONObject().
        oMsg:add("code", 3).
        oMsg:add("message", "Agendamento Atualizado!").
        oMsg:add("detailedMessage", "Agendamento " + string(ttAgendamento.agendamento_id)  + " atualizado com sucesso!").
        assign oRes = JsonApiResponseBuilder:ok(oMsg, 200). 

        run createPendenciaMLA in boHandler (input pType).

        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.


/*****************************************************************************
                             ELIMINAR AGENDAMENTO 
******************************************************************************/
procedure pi-delete:
    define input  param oReq    as JsonObject           no-undo.
    define output param oRes    as JsonObject           no-undo.
    define variable aJsonArray  as JsonArray            no-undo.
    define variable cPathParams as character            no-undo.
    define variable oMsg        as JsonObject           no-undo.
    define variable aMsgArray   as JsonArray            no-undo.
    define variable oRequest    as JsonAPIRequestParser no-undo.
    define variable lTodos      as logical initial true no-undo.
    
    assign 
        oRequest  = new JsonAPIRequestParser(oReq)
        cPathParams = oRequest:getPathParams():GetCharacter(1).

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0197.p persistent set boHandler.
    end.

    run setConstraintMain in boHandler (input lTodos).
    run openQueryStatic   in boHandler (input "Main":U).
    run emptyRowErrors    in boHandler.
    run goToKey           in boHandler (input cPathParams).
    
    if return-value = "OK" then do:
        run deleteRecord       in boHandler.
        run getRowErrors       in boHandler (output table RowErrors append).   
    end.
    else do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorHelp", "Agendamento " + cPathParams  + " nÆo encontrado na base de dados!").
        oMsg:add("ErrorNumber", 1).
        oMsg:add("ErrorDescription", "Agendamento nÆo encontrado!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.
    
    if can-find(first RowErrors 
                where upper(RowErrors.ErrorSubType) = 'ERROR':U 
                and RowErrors.ErrorNumber <> 10
                and RowErrors.ErrorNumber <> 3
                and RowErrors.ErrorNumber <> 8) then do:
        assign oRes = JsonApiResponseBuilder:asError (temp-table RowErrors:handle).

        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.
    else do:
        assign oRes = JsonApiResponseBuilder:empty(204).
        run deletePendenciaMLA in boHandler.

        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.


/*****************************************************************************
                               LISTAR CONDUTORES 
******************************************************************************/
procedure pi-driver-list:
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable rId           as rowid                no-undo.
    define variable iReturnedRows as integer              no-undo.
    define variable iStartRow     as integer              no-undo.
    define variable iContIni      as integer              no-undo.
    define variable iContFin      as integer              no-undo.
    define variable hasNext       as logical initial true no-undo.
    define variable hasFirst      as logical initial true no-undo.
    define variable iPageSize     as integer              no-undo.
    define variable iPage         as integer              no-undo.
    define variable oRequest      as JsonAPIRequestParser no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable i             as integer              no-undo.
    define variable iLength       as integer              no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable cSearch       as character            no-undo.
    define variable iMatricula    as integer              no-undo.
   
    assign
        orequest     = new JsonAPIRequestParser(oReq)
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams")
        iStartRow    = oRequest:getStartRow()
        iPageSize    = oRequest:getPageSize()
        iPage        = oRequest:getPage().

    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0081.p persistent set boHandler.
    end.

    if oQueryParams:has("filter") then do:
        assign cSearch = string(oQueryParams:GetJsonArray("filter"):getJsonText(1)).
        if cSearch <> "" then do:     
            iMatricula = integer(cSearch) no-error.
            if error-status:error then do:
                run setConstraintNome in boHandler (input cSearch).
                run openQueryStatic   in boHandler (input "Nome":U).
                run emptyRowErrors    in boHandler.
                run getFirst          in boHandler.
            end.
            else do:
                run setConstraintMatricula in boHandler (input iMatricula).
                run openQueryStatic        in boHandler (input "Matricula":U).
                run emptyRowErrors         in boHandler.
                run getFirst               in boHandler.
            end.
        end.
        else do:
            run openQueryStatic in boHandler (input "Main":U).
            run emptyRowErrors  in boHandler.
            run getFirst        in boHandler.
        end.
    end.
    else do:
        run openQueryStatic in boHandler (input "Main":U).
        run emptyRowErrors  in boHandler.
        run getFirst        in boHandler.
    end.

    if iStartRow > 1 then do:
        assign iContFin = iStartRow - 1.
        do iContIni = 1 to iContFin:
            run getNext in boHandler.
            if return-value = "NOK":U then do:
                run emptyRowErrors in boHandler.
                assign hasNext  = false.
                if iStartRow > iContIni then
                    assign hasFirst = false.
                leave.
            end.
        end.
    end.
    
    if hasFirst then do:
        run getRowid in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input rId,//parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttCondutor //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
        ).

        if iReturnedRows < iPageSize then do:
            assign hasNext = false.
        end.
        else do:
            run getFirst in boHandler.
            do iContIni = 1 to (iPage * ipageSize):
                run getNext in boHandler.
                if return-value = "NOK":U then do:
                    run emptyRowErrors in boHandler.
                    assign hasNext = false.
                    leave.
                end.
            end.
        end.
    end.
   
    run getRowErrors in boHandler (output table RowErrors append).

    if valid-handle(boHandler) then
        run destroy in boHandler.

    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:
        assign
        aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttCondutor:handle).
        aJsonArrayRes = new jsonArray().
        do i = 1 to iReturnedRows:
            oJsonObject = new jsonObject().
            oJsonObject = aJsonArray:getJsonObject(i).
                    
            for first funcionario
            fields (nom_pessoa_fisic)
            no-lock
            where funcionario.cdn_funcionario = oJsonObject:getinteger('cdn_funcionario'):
                oJsonObject:add('nom_pessoa_fisic', funcionario.nom_pessoa_fisic).
            end.
                
            oJsonObject:add('label', oJsonObject:getcharacter('nom_pessoa_fisic')).
            oJsonObject:add('value', oJsonObject:getinteger('cdn_funcionario')).
            aJsonArrayRes:add(oJsonObject).
        end.
        assign aJsonArray = aJsonArrayRes.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.


/*****************************************************************************
                          PESQUISAR CONDUTOR 
******************************************************************************/
procedure pi-driver-find:
    define input  param oReq       as JsonObject           no-undo.
    define output param oRes       as JsonObject           no-undo. 
    define variable oJsonObject    as JsonObject           no-undo.
    define variable cPathParams    as character            no-undo.
    define variable oMsg           as JsonObject           no-undo.
    define variable aMsgArray      as JsonArray            no-undo.
    define variable iId            as integer              no-undo.
    define variable oRequest       as JsonAPIRequestParser no-undo.
    define variable oJsonObjectRes as JsonObject           no-undo.
    
    assign 
        oJsonObject    = new JsonObject()
        oJsonObjectRes = new JsonObject()
        oRequest      = new JsonAPIRequestParser(oReq)
        cPathParams   = oRequest:getPathParams():GetCharacter(2)
        iId = integer(cPathParams).
    
    if not valid-handle(boHandler) then do:
        run {&prefix}services/bocst0081.p persistent set boHandler.
    end.
    
    run openQueryStatic in boHandler (input "Main":U).
    run emptyRowErrors  in boHandler.
    run getRowErrors    in boHandler (output table RowErrors append).
    run goToKey         in boHandler (input iId).

    if upper(return-value) = "OK":U then do:
        run getRecord in boHandler (output table ttCondutor).
        assign 
            oJsonObject = JsonAPIUtils:ConvertTempTableToJsonObject(temp-table ttCondutor:handle)
            oJsonObjectRes = oJsonObject:getJsonArray("ttCondutor"):getJsonObject(1).

        for first hcm.funcionario 
        fields (nom_pessoa_fisic)
        no-lock
        where funcionario.cdn_funcionario = oJsonObjectRes:getinteger('cdn_funcionario'):
            oJsonObjectRes:add('nom_pessoa_fisic', funcionario.nom_pessoa_fisic).
        end.

        oJsonObjectRes:add('label', oJsonObjectRes:getcharacter('nom_pessoa_fisic')).
        oJsonObjectRes:add('value', oJsonObjectRes:getinteger('cdn_funcionario')).
            
        oRes = JsonApiResponseBuilder:ok(oJsonObjectRes, 200).
        if valid-handle(boHandler) then
        run destroy in boHandler.
        return.
    end.
    else do:
        assign
            aMsgArray = new JsonArray()
            oMsg      = new JsonObject().
        
        oMsg:add("ErrorHelp", "Condutor " + string(cPathParams) + " nÆo encontrado na base de dados!").
        oMsg:add("ErrorNumber", 1).
        oMsg:add("ErrorDescription", "Condutor nÆo encontrado!").
        oMsg:add("ErrorSubType", "error").
        aMsgArray:Add(oMsg).
        assign oRes = JsonApiResponseBuilder:asError(aMsgArray, 404).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch.
    
    finally: delete procedure boHandler no-error. end finally.

end procedure.
