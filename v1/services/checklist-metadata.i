procedure pi-metadata:
    define input  param oReq     as JsonObject no-undo.
    define output param oRes     as JsonObject no-undo.
    define variable oMetadata    as JsonObject no-undo.
    define variable aJsonArray   as JsonArray  no-undo.
    define variable aJsonArray2  as JsonArray  no-undo.
    define variable aJsonArray3  as JsonArray  no-undo.
    define variable oJsonObject  as JsonObject no-undo.
    define variable oJsonObject2 as JsonObject no-undo.
    define variable oJsonObject3 as JsonObject no-undo.
    define variable oQueryParams as JsonObject no-undo.
    define variable aType        as JsonArray  no-undo.

    assign
        oQueryParams = new JsonObject()
        oQueryParams = oReq:getJsonObject("queryParams").
        aType        = oQueryParams:getJsonArray("type").

/*****************************************************************************
                              LISTAR CHECKLIST
******************************************************************************/

    if aType:GetJsonText(1) = "list" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'list').
        oMetadata:add('autoRouter', true).
        oMetadata:add('title', 'Checklist').
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'In¡cio').
                oJsonObject:add('link', '/home').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('label', 'Checklist').
            aJsonArray:add(oJsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('items', aJsonArray ).
        oMetadata:add('breadcrumb', ojsonObject).
            oJsonObject = new jsonObject().
            oJsonObject:add('detail', 'checklist/detail/:id').
            oJsonObject:add('edit', 'checklist/edit/:id').
            oJsonObject:add('new', 'checklist/new').
            oJsonObject:add('remove', true).
        oMetadata:add('actions', ojsonObject).
        oMetadata:add('keepFilters', true).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'agendamento_id').
                oJsonObject:add('label', 'Agendamento').
                oJsonObject:add('key', true).
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'tipo').
                oJsonObject:add('key', true).
                oJsonObject:add('label', 'Tipo Checklist').
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Sa¡da').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'Retorno').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_condutor').
                oJsonObject:add('label', 'Condutor').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Ve¡culo').
                oJsonObject:add('filter', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_avaliador').
                oJsonObject:add('label', 'Avaliador').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'dt_checklist').
                oJsonObject:add('label', 'Data').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyyy').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'hr_checklist').
                oJsonObject:add('label', 'Hora').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'observacoes').
                oJsonObject:add('label', 'Anota‡äes').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'km').
                oJsonObject:add('label', 'Km').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('duplicate', true).
                ojsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                        oJsonObject2:add('color', 'color-09').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                        oJsonObject2:add('color', 'color-11').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
               ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                oJsonObject:add('type', 'label').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                oJsonObject:add('type', 'label').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Diant.').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Tras.').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua limpadores').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                   aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                   aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                   aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Ext.').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Int.').
                ojsonObject:add('tag', true).
                oJsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('labels', aJsonArray2).
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', ajsonArray).
    end.
    
/*****************************************************************************
                               DETALHAR CHECKLIST
******************************************************************************/

    if aType:GetJsonText(1) = "detail" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'detail').
        oMetadata:add('title', 'Visualiza‡Æo do Checklist').
            oJsonObject = new jsonObject().
            ojsonObject:add('back','/checklist').
            ojsonObject:add('edit','/checklist/edit/:id').
            ojsonObject:add('remove','/checklist').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Checklist').
                    ojsonObject2:add('link','/checklist').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Detalhes').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agendamento_id').
                ojsonObject:add('label','Agendamento').
                ojsonObject:add('key', true).
                ojsonObject:add('divider','Dados Gerais').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','tipo').
                ojsonObject:add('tag', true).
                ojsonObject:add('key', true).
                ojsonObject:add('label','Tipo Checklist').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Sa¡da').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'Retorno').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'placa').
                oJsonObject:add('label', 'Placa').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'modelo').
                oJsonObject:add('label', 'Ve¡culo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'condutor').
                oJsonObject:add('label', 'ID Condutor').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'destino').
                oJsonObject:add('label', 'Itiner rio').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'motivo').
                oJsonObject:add('label', 'Motivo').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','dt_checklist').
                ojsonObject:add('label','Data Checklist').
                oJsonObject:add('type', 'date').
                oJsonObject:add('format', 'dd/MM/yyyy').
                oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-calendar').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','hr_checklist').
                ojsonObject:add('label','Hora Checklist').
                 oJsonObject:add('tag', true).
                ojsonObject:add('icon','po-icon po-icon-clock').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Observa‡äes').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                        oJsonObject2:add('color', 'color-07').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                        oJsonObject2:add('color', 'color-08').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                        oJsonObject2:add('color', 'color-09').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                        oJsonObject2:add('color', 'color-10').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                        oJsonObject2:add('color', 'color-11').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('divider','Check-List').
                ojsonObject:add('tag', true).
                oJsonObject:add('labels', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Diant.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Tras.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua limpadores').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Ext.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Int.').
                ojsonObject:add('tag', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                     aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_condutor').
                oJsonObject:add('label', 'Condutor').
                oJsonObject:add('divider', 'Respons veis').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                oJsonObject:add('property', 'nome_avaliador').
                oJsonObject:add('label', 'Avaliador').
            aJsonArray:add(oJsonObject).
        oMetadata:add('fields', aJsonArray).
    end.

/*****************************************************************************
                            CADASTRAR CHECKLIST
******************************************************************************/

    if aType:GetJsonText(1) = "create" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'create').
        oMetadata:add('title', 'Novo Checklist').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/checklist').
            ojsonObject:add('saveNew', 'metadata-new/').
            ojsonObject:add('cancel','/checklist').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Checklist').
                    ojsonObject2:add('link','/checklist').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Novo').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agendamento_id').
                ojsonObject:add('label','Agendamento').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('searchService', '{&environment}agendamento').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'agendamento_id').
                        oJsonObject2:add('label', 'Agendamento').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        ojsonObject2:add('property', 'situacao').
                        ojsonObject2:add('label', 'Status').
                        ojsonObject2:add('width', '150px').
                        ojsonObject2:add('type', 'subtitle').
                            aJsonArray3 = new jsonArray().
                                oJsonObject3 = new jsonObject().
                                oJsonObject3:add('value', 2).
                                oJsonObject3:add('label', '2 - Agendamento Aprovado').
                                oJsonObject3:add('color', 'color-10').
                                oJsonObject3:add('content', 'AA').
                            aJsonArray3:add(oJsonObject3).
                                oJsonObject3 = new jsonObject().
                                oJsonObject3:add('value', 3).
                                oJsonObject3:add('label', '3 - Rota Iniciada').
                                oJsonObject3:add('color', 'color-03').
                                oJsonObject3:add('content', 'RI').
                            aJsonArray3:add(oJsonObject3).
                        oJsonObject2:add('subtitles', aJsonArray3).
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'placa').
                        oJsonObject2:add('label', 'Placa').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'modelo').
                        oJsonObject2:add('label', 'Modelo').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'nome_condutor').
                        oJsonObject2:add('label', 'Condutor').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'prev_data_inic').
                        oJsonObject2:add('label', 'Data Sa¡da').
                        oJsonObject2:add('format', 'dd/MM/yyyy').
                        oJsonObject2:add('type', 'date').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'prev_hora_inic').
                        oJsonObject2:add('label', 'Hora Sa¡da').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'prev_data_fin').
                        oJsonObject2:add('label', 'Data Retorno').
                        oJsonObject2:add('type', 'date').
                        oJsonObject2:add('format', 'dd/MM/yyyy').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'prev_hora_fin').
                        oJsonObject2:add('label', 'Hora Retorno').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'destino').
                        oJsonObject2:add('label', 'Destino').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'aprovador').
                        oJsonObject2:add('label', 'Aprovado por:').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('agendamento_id').
                    aJsonArray2:add('modelo').
                    aJsonArray2:add('nome_condutor').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'modelo').
                ojsonObject:add('fieldValue', 'agendamento_id').
                ojsonObject:add('divider','Dados Gerais do Checklist').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','tipo').
                ojsonObject:add('label','Tipo Checklist').
                ojsonObject:add('key', true).
                ojsonObject:add('required', true).
                ojsonObject:add('duplicate', true).
                ojsonObject:add('type', 'select').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Sa¡da').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'Retorno').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','dt_checklist').
                ojsonObject:add('label','Data').
                ojsonObject:add('type', 'date').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','hr_checklist').
                ojsonObject:add('label','Hor rio').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('type','time').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
                ojsonObject:add('type', 'number').
                ojsonObject:add('maxLength', 7).
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Anota‡äes').
                ojsonObject:add('rows', 4).
                ojsonObject:add('gridColumns', 12).
                ojsonObject:add('maxLength', 100).
                ojsonObject:add('type', 'textarea').
                ojsonObject:add('optional', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','avaliador').
                ojsonObject:add('label','Avaliador').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('searchService', '{&environment}checklist/avaliador').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'cdn_funcionario').
                        oJsonObject2:add('label', 'Avaliador').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'nom_pessoa_fisic').
                        oJsonObject2:add('label', 'Nome').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('cdn_funcionario').
                    aJsonArray2:add('nom_pessoa_fisic').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'nom_pessoa_fisic').
                ojsonObject:add('fieldValue', 'cdn_funcionario').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('required', true).
                ojsonObject:add('divider','Situa‡Æo Atual do Ve¡culo (Check-List)').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Dianteiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Traseiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua Limpador Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Externos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Interno').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).    
        oMetadata:add('fields', aJsonArray).
    end.

/*****************************************************************************
                              EDITAR CHECKLIST
******************************************************************************/

    if aType:GetJsonText(1) = "edit" then do:
        oMetadata = new jsonObject().
        oMetadata:add('version', 1).
        oMetadata:add('type', 'edit').
        oMetadata:add('title', 'Editando Checklist').
            oJsonObject = new jsonObject().
            ojsonObject:add('save','/checklist').
            ojsonObject:add('cancel','/checklist').
        oMetadata:add('actions', oJsonObject).
            oJsonObject = new jsonObject().
                aJsonArray = new jsonArray().
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','In¡cio').
                    ojsonObject2:add('link','/home').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Checklist').
                    ojsonObject2:add('link','/checklist').
                aJsonArray:add(oJsonObject2).
                    oJsonObject2 = new jsonObject().
                    ojsonObject2:add('label','Editando').
                aJsonArray:add(oJsonObject2).
            oJsonObject:add('items', aJsonArray).
        oMetadata:add('breadcrumb', oJsonObject).
            aJsonArray = new jsonArray().
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agendamento_id').
                ojsonObject:add('label','Agendamento').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('disabled', true).
                 ojsonObject:add('type', 'number').
                ojsonObject:add('searchService', '{&environment}agendamento').
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('agendamento_id').
                    aJsonArray2:add('modelo').
                    aJsonArray2:add('nome_condutor').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'modelo').
                ojsonObject:add('fieldValue', 'agendamento_id').
                ojsonObject:add('divider','Dados Gerais do Checklist').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','tipo').
                ojsonObject:add('label','Tipo Checklist').
                ojsonObject:add('key', true).
                ojsonObject:add('disabled', true).
                ojsonObject:add('type', 'label').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Sa¡da').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'Retorno').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','dt_checklist').
                ojsonObject:add('label','Data').
                ojsonObject:add('type', 'date').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','hr_checklist').
                ojsonObject:add('label','Hor rio').
                ojsonObject:add('type', 'time').
                ojsonObject:add('format','HH:mm').
                ojsonObject:add('icon','po-icon po-icon-clock').
                ojsonObject:add('required', true).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','km').
                ojsonObject:add('label','Km').
                ojsonObject:add('type', 'number').
                ojsonObject:add('required', true).
                ojsonObject:add('maxLength', 7).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','combustivel').
                ojsonObject:add('label','Combust¡vel').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Reserva').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', '1/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', '1/2').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 4).
                        oJsonObject2:add('label', '3/4').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 5).
                        oJsonObject2:add('label', 'Completo').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','observacoes').
                ojsonObject:add('label','Anota‡äes').
                ojsonObject:add('rows', 4).
                ojsonObject:add('gridColumns', 12).
                ojsonObject:add('type', 'textarea').
                ojsonObject:add('optional', true).
                ojsonObject:add('maxLength', 100).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','avaliador').
                ojsonObject:add('label','Avaliador').
                ojsonObject:add('gridColumns', 7).
                ojsonObject:add('required', true).
                ojsonObject:add('searchService', '{&environment}checklist/avaliador').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'cdn_funcionario').
                        oJsonObject2:add('label', 'Avaliador').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('property', 'nom_pessoa_fisic').
                        oJsonObject2:add('label', 'Nome').
                    aJsonArray2:add(oJsonObject2).
                ojsonObject:add('columns', aJsonArray2).
                    aJsonArray2 = new jsonArray().
                    aJsonArray2:add('cdn_funcionario').
                    aJsonArray2:add('nom_pessoa_fisic').
                ojsonObject:add('format', aJsonArray2).
                ojsonObject:add('fieldLabel', 'nom_pessoa_fisic').
                ojsonObject:add('fieldValue', 'cdn_funcionario').
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_ext').
                ojsonObject:add('label','Limpeza Externa').
                ojsonObject:add('divider','Situa‡Æo Atual do Ve¡culo (Check-List)').
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limp_int').
                ojsonObject:add('label','Limpeza Interna').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pneus').
                ojsonObject:add('label','Pneus').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','estepe').
                ojsonObject:add('label','Estepe').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','pintura').
                ojsonObject:add('label','Pintura').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','lataria').
                ojsonObject:add('label','Lataria').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_diant').
                ojsonObject:add('label','Parachoque Dianteiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parachoque_tras').
                ojsonObject:add('label','Parachoque Traseiro').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_alto').
                ojsonObject:add('label','Farol Alto').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','farol_baixo').
                ojsonObject:add('label','Farol Baixo').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','setas').
                ojsonObject:add('label','Setas').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','luz_re').
                ojsonObject:add('label','Luz de R‚').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_limp').
                ojsonObject:add('label','Agua Limpador Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','agua_rad').
                ojsonObject:add('label','Agua Radiador').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','embreagem').
                ojsonObject:add('label','Embreagem').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cambio').
                ojsonObject:add('label','Cƒmbio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_freio').
                ojsonObject:add('label','Flu¡do Freio').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','oleo_motor').
                ojsonObject:add('label','àleo Motor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','parabrisa').
                ojsonObject:add('label','Parabrisa').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','alarme').
                ojsonObject:add('label','Alarme').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','buzina').
                ojsonObject:add('label','Buzina').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','cintos').
                ojsonObject:add('label','Cintos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','documentos').
                ojsonObject:add('label','Documentos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','extintor').
                ojsonObject:add('label','Extintor').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','limpadores').
                ojsonObject:add('label','Limpadores').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','macaco').
                ojsonObject:add('label','Macaco').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','chave_roda').
                ojsonObject:add('label','Chave Roda').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_ext').
                ojsonObject:add('label','Retrovisores Externos').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).
                oJsonObject = new jsonObject().
                ojsonObject:add('property','retrov_int').
                ojsonObject:add('label','Retrovisor Interno').
                ojsonObject:add('required', true).
                    aJsonArray2 = new jsonArray().
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 1).
                        oJsonObject2:add('label', 'Ruim').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 2).
                        oJsonObject2:add('label', 'M‚dio').
                    aJsonArray2:add(oJsonObject2).
                        oJsonObject2 = new jsonObject().
                        oJsonObject2:add('value', 3).
                        oJsonObject2:add('label', 'Bom').
                    aJsonArray2:add(oJsonObject2).
                oJsonObject:add('options', aJsonArray2).
            aJsonArray:add(oJsonObject).    
        oMetadata:add('fields', aJsonArray).
    end.
    
    assign oRes = JsonApiResponseBuilder:ok(oMetadata, 200).

end procedure.
