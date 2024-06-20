/*****************************************************************************
                        METADADOS DIµRIO DE BORDO
******************************************************************************/
procedure pi-logbook-metadata:
    define input  param oReq     as JsonObject no-undo.
    define output param oRes     as JsonObject no-undo.
    define variable oMetadata    as JsonObject no-undo.
    define variable aJsonArray   as JsonArray  no-undo.
    define variable aJsonArray2  as JsonArray  no-undo.
    define variable oJsonObject  as JsonObject no-undo.
    define variable oJsonObject2 as JsonObject no-undo.
    define variable oQueryParams as JsonObject no-undo.
    define variable aType        as JsonArray  no-undo.

    assign
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams").
        aType        = oQueryParams:getJsonArray("type").

    if aType:GetJsonText(1) = "list" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'list').
        oMetadata:add('autoRouter', true).
        oMetadata:add('title', 'Di rio de Bordo').
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'In¡cio').
                oJsonObject:add('link', '/home').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'Di rio de Bordo').
            aJsonArray:add(oJsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('items', aJsonArray ).
        oMetadata:add('breadcrumb', ojsonObject).
          /*oJsonObject = new jsonObject().
            oJsonObject:add('detail', 'diario/detail/:id').
        oMetadata:add('actions', ojsonObject).*/
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agendamento_id').
                oJsonObject:add('key', true).
                oJsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'tipo').
                oJsonObject:add('key', true).
                oJsonObject:add('visible', false).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'placa').
                oJsonObject:add('label', 'Placa').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Ve¡culo').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'dt_checklist').
                oJsonObject:add('label', 'Data Sa¡da').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyyy').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                 oJsonObject = new jsonObject().
                oJsonObject:add('property', 'hr_checklist').
                oJsonObject:add('label', 'Hora Sa¡da').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'dt_final').
                oJsonObject:add('label', 'Data Retorno').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyyy').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'hr_final').
                oJsonObject:add('label', 'Hora Retorno').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'km').
                oJsonObject:add('label', 'Km Inicial').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'km_final').
                oJsonObject:add('label', 'Km Final').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_condutor').
                oJsonObject:add('label', 'Condutor').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'destino').
                oJsonObject:add('label', 'Destino').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'motivo').
                oJsonObject:add('label', 'Motivo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'observacoes').
                oJsonObject:add('label', 'Anota‡äes Sa¡da').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'observacoesRetorno').
                oJsonObject:add('label', 'Anota‡äes Retorno').
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', ajsonArray).
    end.

    assign oRes = JsonApiResponseBuilder:ok(oMetadata, 200).

end procedure.
