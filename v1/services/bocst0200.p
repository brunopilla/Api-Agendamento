&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCST0200
&GLOBAL-DEFINE DBOVersion 2.00
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cst_veiculos_checklist
&GLOBAL-DEFINE TableLabel checklist
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

{utp/ut-glob.i}

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cstp/api/v1/services/bocst0200.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable agendamento              as integer   no-undo.
define variable cPlaca                   as character no-undo.
define variable cModelo                  as character no-undo.
define variable cCondutor                as character no-undo.
define variable cMatriculaList           as character no-undo.
define variable cPlacaList               as character no-undo.
define variable cAgendamentoListPlaca    as character no-undo.
define variable cAgendamentoListCondutor as character no-undo.
define variable dData                    as date      no-undo.

define new global shared variable v_cod_usuar_corren as character no-undo.

define buffer bf-cst_movtopta for cst_movtopta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 29.13
         WIDTH              = 43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if RowObject.tipo = 1 then do:

        find first cst_veiculos_agendamento 
            where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id exclusive-lock no-error.

        if avail cst_veiculos_agendamento then
            update cst_veiculos_agendamento.situacao = 3.
        else
            {method/svc/errors/inserr.i
                 &ErrorNumber="200"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorDescription="AGENDAMENTO n∆o encontrado!"
                 &ErrorHelp="Verifique se este AGENDAMENTO j† foi cadastrado no sistema."}
    
        find first cst_veiculos
            where cst_veiculos.placa = cst_veiculos_agendamento.placa exclusive-lock no-error.

        if avail cst_veiculos then
            update cst_veiculos.disponivel       = false
                   cst_veiculos.agua_limp        = RowObject.agua_limp        
                   cst_veiculos.agua_rad         = RowObject.agua_rad         
                   cst_veiculos.alarme           = RowObject.alarme           
                   cst_veiculos.buzina           = RowObject.buzina           
                   cst_veiculos.cambio           = RowObject.cambio           
                   cst_veiculos.chave_roda       = RowObject.chave_roda       
                   cst_veiculos.cintos           = RowObject.cintos           
                   cst_veiculos.combustivel      = RowObject.combustivel      
                   cst_veiculos.documentos       = RowObject.documentos       
                   cst_veiculos.embreagem        = RowObject.embreagem        
                   cst_veiculos.estepe           = RowObject.estepe           
                   cst_veiculos.extintor         = RowObject.extintor         
                   cst_veiculos.farol_alto       = RowObject.farol_alto       
                   cst_veiculos.farol_baixo      = RowObject.farol_baixo      
                   cst_veiculos.freio            = RowObject.freio            
                   cst_veiculos.km               = RowObject.km               
                   cst_veiculos.lataria          = RowObject.lataria          
                   cst_veiculos.limpadores       = RowObject.limpadores       
                   cst_veiculos.limp_ext         = RowObject.limp_ext         
                   cst_veiculos.limp_int         = RowObject.limp_int         
                   cst_veiculos.luz_re           = RowObject.luz_re           
                   cst_veiculos.macaco           = RowObject.macaco           
                   cst_veiculos.oleo_freio       = RowObject.oleo_freio       
                   cst_veiculos.oleo_motor       = RowObject.oleo_motor       
                   cst_veiculos.parabrisa        = RowObject.parabrisa        
                   cst_veiculos.parachoque_diant = RowObject.parachoque_diant 
                   cst_veiculos.parachoque_tras  = RowObject.parachoque_tras  
                   cst_veiculos.pintura          = RowObject.pintura          
                   cst_veiculos.pneus            = RowObject.pneus            
                   cst_veiculos.retrov_ext       = RowObject.retrov_ext       
                   cst_veiculos.retrov_int       = RowObject.retrov_int       
                   cst_veiculos.setas            = RowObject.setas            
                   cst_veiculos.triangulo        = RowObject.triangulo.
            else
                {method/svc/errors/inserr.i
                    &ErrorNumber="200"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="VE÷CULO n∆o encontrado!"
                    &ErrorHelp="Verifique se este VE÷CULO j† foi cadastrado no sistema."}
            
        run createMovtoPortaria.
    end.
    else if RowObject.tipo = 2 then do:
    
        find first cst_veiculos_agendamento
             where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id exclusive-lock no-error.

        if avail cst_veiculos_agendamento then
            update cst_veiculos_agendamento.situacao = 4.
        else   
            {method/svc/errors/inserr.i
                &ErrorNumber="200"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="AGENDAMENTO n∆o encontrado!"
                &ErrorHelp="Verifique se este AGENDAMENTO j† foi cadastrado no sistema."}
        
        find first cst_veiculos 
             where cst_veiculos.placa = cst_veiculos_agendamento.placa exclusive-lock no-error.

        if avail cst_veiculos then
            update cst_veiculos.disponivel       = true
                   cst_veiculos.agua_limp        = RowObject.agua_limp        
                   cst_veiculos.agua_rad         = RowObject.agua_rad         
                   cst_veiculos.alarme           = RowObject.alarme           
                   cst_veiculos.buzina           = RowObject.buzina           
                   cst_veiculos.cambio           = RowObject.cambio           
                   cst_veiculos.chave_roda       = RowObject.chave_roda       
                   cst_veiculos.cintos           = RowObject.cintos           
                   cst_veiculos.combustivel      = RowObject.combustivel      
                   cst_veiculos.documentos       = RowObject.documentos       
                   cst_veiculos.embreagem        = RowObject.embreagem        
                   cst_veiculos.estepe           = RowObject.estepe           
                   cst_veiculos.extintor         = RowObject.extintor         
                   cst_veiculos.farol_alto       = RowObject.farol_alto       
                   cst_veiculos.farol_baixo      = RowObject.farol_baixo      
                   cst_veiculos.freio            = RowObject.freio            
                   cst_veiculos.km               = RowObject.km               
                   cst_veiculos.lataria          = RowObject.lataria          
                   cst_veiculos.limpadores       = RowObject.limpadores       
                   cst_veiculos.limp_ext         = RowObject.limp_ext         
                   cst_veiculos.limp_int         = RowObject.limp_int         
                   cst_veiculos.luz_re           = RowObject.luz_re           
                   cst_veiculos.macaco           = RowObject.macaco           
                   cst_veiculos.oleo_freio       = RowObject.oleo_freio       
                   cst_veiculos.oleo_motor       = RowObject.oleo_motor       
                   cst_veiculos.parabrisa        = RowObject.parabrisa        
                   cst_veiculos.parachoque_diant = RowObject.parachoque_diant 
                   cst_veiculos.parachoque_tras  = RowObject.parachoque_tras  
                   cst_veiculos.pintura          = RowObject.pintura          
                   cst_veiculos.pneus            = RowObject.pneus            
                   cst_veiculos.retrov_ext       = RowObject.retrov_ext       
                   cst_veiculos.retrov_int       = RowObject.retrov_int       
                   cst_veiculos.setas            = RowObject.setas            
                   cst_veiculos.triangulo        = RowObject.triangulo.
        else
            {method/svc/errors/inserr.i
                &ErrorNumber="200"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="VE÷CULO n∆o encontrado!"
                &ErrorHelp="Verifique se este VE÷CULO j† foi cadastrado no sistema."}
        
    end.
      
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if RowObject.tipo = 1 then do:
        find first cst_movtopta
             where cst_movtopta.agendamento_id = RowObject.agendamento_id exclusive-lock no-error.
        
        if avail cst_movtopta then
            delete cst_movtopta.
       
    
            /*:T--- Verifica ocorrància de erros ---*/
        if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
            return "NOK":U.
    end.
           
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSetRecord DBOProgram 
PROCEDURE afterSetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign
        RowObject.hr_checklist = replace(RowObject.hr_checklist,":","").

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if RowObject.tipo = 1 then do:
        if can-find( first cst_veiculos_checklist no-lock
            where cst_veiculos_checklist.agendamento_id = RowObject.agendamento_id
            and   cst_veiculos_checklist.tipo = 2) then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Checklist de SA÷DA n∆o pode ser exclu°do!"
                &ErrorHelp="CHECKLIST DE SA÷DA j† possui CHECKLIST DE RETORNO cadastrado."}
        end.
        else do:
            find first cst_veiculos_agendamento 
                where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id no-error.
            if avail cst_veiculos_agendamento then
                update cst_veiculos_agendamento.situacao = 2.
            else
                {method/svc/errors/inserr.i
                    &ErrorNumber="200"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="AGENDAMENTO n∆o encontrado!"
                    &ErrorHelp="Erro ao atualizar o status do Agendamento."}

            find first cst_veiculos where cst_veiculos.placa = cst_veiculos_agendamento.placa exclusive-lock no-error.
            if avail cst_veiculos then
                update cst_veiculos.dispon°vel = true.
            else 
                {method/svc/errors/inserr.i
                    &ErrorNumber="200"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="VE÷CULO n∆o encontrado!"
                    &ErrorHelp="Erro ao atualizar o status do ve°culo."}
        end.
    end.
    
    if RowObject.tipo = 2 then do:
        find first cst_veiculos_agendamento
            where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id exclusive-lock no-error.
        if avail cst_veiculos_agendamento then
            update cst_veiculos_agendamento.situacao = 3.
        else
            {method/svc/errors/inserr.i
                    &ErrorNumber="200"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="AGENDAMENTO n∆o encontrado!"
                    &ErrorHelp="Erro ao atualizar o status do Agendamento."}

        find first cst_veiculos
            where cst_veiculos.placa = cst_veiculos_agendamento.placa exclusive-lock no-error.
        if avail cst_veiculos then
            update cst_veiculos.disponivel = false.
        else
            {method/svc/errors/inserr.i
                    &ErrorNumber="200"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Ve°culo n∆o encontrado!"
                    &ErrorHelp="Erro ao atualizar o status do Ve°culo."}
    end.
    

    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeGetBatchRecords DBOProgram 
PROCEDURE beforeGetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign
        RowObject.hr_checklist  = substring(RowObject.hr_checklist,1,2) + ":" + substring(RowObject.hr_checklist,3,2).

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeGetRecord DBOProgram 
PROCEDURE beforeGetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign
        RowObject.hr_checklist  = substring(RowObject.hr_checklist,1,2) + ":" + substring(RowObject.hr_checklist,3,2).

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createMovtoPortaria DBOProgram 
PROCEDURE createMovtoPortaria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var nro-cont-vei like cst_movtopta.nro-movto init 0 no-undo.

find last bf-cst_movtopta no-lock no-error.
    if avail bf-cst_movtopta then assign nro-cont-vei = bf-cst_movtopta.nro-movto + 1.
    else nro-cont-vei = 1.

find first cst_veiculos_agendamento 
     where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id no-lock no-error.

find first cst_movtopta
     where cst_movtopta.agendamento_id = cst_veiculos_agendamento.agendamento_id no-lock no-error.

if avail cst_movtopta then do:

    {method/svc/errors/inserr.i
                 &ErrorNumber="112"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorDescription="MOVTO PORTARIA j† foi criado para o Agendamento!"
                 &ErrorHelp="N∆o foi poss°vel gerar o movimento de portaria para esse agendamento!"}
end.
else do:

    create cst_movtopta.
    assign cst_movtopta.nro-movto    = nro-cont-vei
           cst_movtopta.emissor      = 1 /* brazilian */
           cst_movtopta.cod-estabel  = "103" /* matriz */
           cst_movtopta.placa        = cst_veiculos_agendamento.placa
           cst_movtopta.tp-movto     = 4 /* veiculos empresa */
           cst_movtopta.dt-chegada   = today
           cst_movtopta.hr-chegada   = string(time,"HH:MM:SS")
           cst_movtopta.user-chegada = c-seg-usuario
    
           cst_movtopta.cod-motorista     = ?
           cst_movtopta.pedido            = ?
           cst_movtopta.tp-carga          = ?
           cst_movtopta.lib-embalagem     = "Sim"
           cst_movtopta.lib-compras       = "Sim"
           cst_movtopta.lib-qualidade     = "Sim"
           cst_movtopta.lib-recebimento   = "Sim"
           cst_movtopta.prioridade-rec    = ?
           cst_movtopta.lib-expedicao     = "Sim"
           cst_movtopta.lib-recepcao      = "Sim"
           cst_movtopta.lib-carregamento  = "Sim"
           cst_movtopta.lib-saida         = "Sim"
           cst_movtopta.lib-fat           = "Sim"
    
           cst_movtopta.agendamento_id    = RowObject.agendamento_id
           cst_movtopta.observacao        = cst_veiculos_agendamento.destino + " - " + cst_veiculos_agendamento.motivo.
end.

        /*:T--- Verifica ocorrància de erros ---*/
if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
      return "NOK":U.
       
return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "hr_checklist":U THEN ASSIGN pFieldValue = RowObject.hr_checklist.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt_checklist":U THEN ASSIGN pFieldValue = RowObject.dt_checklist.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "agendamento_id":U THEN ASSIGN pFieldValue = RowObject.agendamento_id.
        WHEN "agua_limp":U THEN ASSIGN pFieldValue = RowObject.agua_limp.
        WHEN "agua_rad":U THEN ASSIGN pFieldValue = RowObject.agua_rad.
        WHEN "alarme":U THEN ASSIGN pFieldValue = RowObject.alarme.
        WHEN "avaliador":U THEN ASSIGN pFieldValue = RowObject.avaliador.
        WHEN "buzina":U THEN ASSIGN pFieldValue = RowObject.buzina.
        WHEN "cambio":U THEN ASSIGN pFieldValue = RowObject.cambio.
        WHEN "chave_roda":U THEN ASSIGN pFieldValue = RowObject.chave_roda.
        WHEN "cintos":U THEN ASSIGN pFieldValue = RowObject.cintos.
        WHEN "combustivel":U THEN ASSIGN pFieldValue = RowObject.combustivel.
        WHEN "documentos":U THEN ASSIGN pFieldValue = RowObject.documentos.
        WHEN "embreagem":U THEN ASSIGN pFieldValue = RowObject.embreagem.
        WHEN "estepe":U THEN ASSIGN pFieldValue = RowObject.estepe.
        WHEN "extintor":U THEN ASSIGN pFieldValue = RowObject.extintor.
        WHEN "farol_alto":U THEN ASSIGN pFieldValue = RowObject.farol_alto.
        WHEN "farol_baixo":U THEN ASSIGN pFieldValue = RowObject.farol_baixo.
        WHEN "freio":U THEN ASSIGN pFieldValue = RowObject.freio.
        WHEN "km":U THEN ASSIGN pFieldValue = RowObject.km.
        WHEN "lataria":U THEN ASSIGN pFieldValue = RowObject.lataria.
        WHEN "limpadores":U THEN ASSIGN pFieldValue = RowObject.limpadores.
        WHEN "limp_ext":U THEN ASSIGN pFieldValue = RowObject.limp_ext.
        WHEN "limp_int":U THEN ASSIGN pFieldValue = RowObject.limp_int.
        WHEN "luz_re":U THEN ASSIGN pFieldValue = RowObject.luz_re.
        WHEN "macaco":U THEN ASSIGN pFieldValue = RowObject.macaco.
        WHEN "oleo_freio":U THEN ASSIGN pFieldValue = RowObject.oleo_freio.
        WHEN "oleo_motor":U THEN ASSIGN pFieldValue = RowObject.oleo_motor.
        WHEN "parabrisa":U THEN ASSIGN pFieldValue = RowObject.parabrisa.
        WHEN "parachoque_diant":U THEN ASSIGN pFieldValue = RowObject.parachoque_diant.
        WHEN "parachoque_tras":U THEN ASSIGN pFieldValue = RowObject.parachoque_tras.
        WHEN "pintura":U THEN ASSIGN pFieldValue = RowObject.pintura.
        WHEN "pneus":U THEN ASSIGN pFieldValue = RowObject.pneus.
        WHEN "retrov_ext":U THEN ASSIGN pFieldValue = RowObject.retrov_ext.
        WHEN "retrov_int":U THEN ASSIGN pFieldValue = RowObject.retrov_int.
        WHEN "setas":U THEN ASSIGN pFieldValue = RowObject.setas.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "triangulo":U THEN ASSIGN pFieldValue = RowObject.triangulo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pk
  Parameters:  
               retorna valor do campo agendamento_id
               retorna valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pagendamento_id LIKE cst_veiculos_checklist.agendamento_id NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo LIKE cst_veiculos_checklist.tipo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pagendamento_id = RowObject.agendamento_id
           ptipo = RowObject.tipo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice pk
  Parameters:  
               recebe valor do campo agendamento_id
               recebe valor do campo tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pagendamento_id LIKE cst_veiculos_checklist.agendamento_id NO-UNDO.
    DEFINE INPUT PARAMETER ptipo LIKE cst_veiculos_checklist.tipo NO-UNDO.

    FIND FIRST bfcst_veiculos_checklist WHERE 
        bfcst_veiculos_checklist.agendamento_id = pagendamento_id AND 
        bfcst_veiculos_checklist.tipo = ptipo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcst_veiculos_checklist THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcst_veiculos_checklist)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAgendamento DBOProgram 
PROCEDURE linkToAgendamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pHBOAgendamento      as handle  no-undo.
    define variable        iAgendamentoCorrente as integer no-undo.

    run getKey in pHBOAgendamento (output iAgendamentoCorrente).

    run setConstraintAgendamento in this-procedure (input iAgendamentoCorrente).

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAgendamento DBOProgram 
PROCEDURE openQueryAgendamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock 
        where cst_veiculos_checklist.agendamento_id = agendamento.

    return "OK":U.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCondutor DBOProgram 
PROCEDURE openQueryCondutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true:

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListCondutor <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.

    open query {&QueryName} for each {&TableName} no-lock
        where lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCondutorDiario DBOProgram 
PROCEDURE openQueryCondutorDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true:

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListCondutor <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.

    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.tipo =1 
        and   lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDataDiario DBOProgram 
PROCEDURE openQueryDataDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.dt_checklist = dData.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDiario DBOProgram 
PROCEDURE openQueryDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.tipo = 1
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
    by {&TableName}.dt_checklist desc.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModelo DBOProgram 
PROCEDURE openQueryModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock 
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.

    open query {&QueryName} for each {&TableName} no-lock
        where lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModeloCondutor DBOProgram 
PROCEDURE openQueryModeloCondutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock 
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true: 

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListCondutor <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        and   lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModeloCondutorDiario DBOProgram 
PROCEDURE openQueryModeloCondutorDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields(cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true: 

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListCondutor <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.tipo = 1 
        and   lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        and   lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModeloDiario DBOProgram 
PROCEDURE openQueryModeloDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.

    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.tipo = 1
        and lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlacaDiario DBOProgram 
PROCEDURE openQueryPlacaDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock
    where cst_veiculos.placa matches("*" + cPlaca + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id) 
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.

    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.tipo = 1
        and   lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlacaModelo DBOProgram 
PROCEDURE openQueryPlacaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock 
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and cst_hierarquia_func.condutor = true: 

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:
        
        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        or    lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySearch DBOProgram 
PROCEDURE openQuerySearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each cst_veiculos
    fields (placa)
    no-lock
    where cst_veiculos.modelo matches("*" + cModelo + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true: 

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        or    lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySearchDiario DBOProgram 
PROCEDURE openQuerySearchDiario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each cst_veiculos
    fields (placa)
    no-lock
    where cst_veiculos.modelo matches("*" + cModelo + "*")
    or    cst_veiculos.placa  matches("*" + cPlaca + "*"):

        if cPlacaList <> "" then
            cPlacaList = cPlacaList + "," + cst_veiculos.placa.
        else
            cPlacaList = cst_veiculos.placa.
    end.

    for each funcionario
    fields (cdn_funcionario)
    no-lock 
    where funcionario.nom_pessoa_fisic matches("*" + cCondutor + "*"):

        for each cst_hierarquia_func
        fields (cdn_funcionario)
        no-lock 
        where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
        and   cst_hierarquia_func.condutor = true: 

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.placa), cPlacaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListPlaca = cAgendamentoListPlaca + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListPlaca = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    for each cst_veiculos_agendamento
    fields (agendamento_id)
    no-lock
    where lookup(string(cst_veiculos_agendamento.condutor), cMatriculaList) > 0:

        if cAgendamentoListPlaca <> "" then
            cAgendamentoListCondutor = cAgendamentoListCondutor + "," + string(cst_veiculos_agendamento.agendamento_id).
        else
            cAgendamentoListCondutor = string(cst_veiculos_agendamento.agendamento_id).
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.tipo = 1
        and   (lookup(string({&TableName}.agendamento_id), cAgendamentoListPlaca) > 0
        or     lookup(string({&TableName}.agendamento_id), cAgendamentoListCondutor) > 0)
        by {&TableName}.dt_checklist desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveAnexo DBOProgram 
PROCEDURE saveAnexo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {cstp/api/v1/services/environments.i}

    define input param cFileName    as character no-undo.
    define input param cFileContent as longchar  no-undo.
    define input param iMatricula   as integer   no-undo.
    
    define variable    arq-anexo    as character no-undo.
    define variable    binaryFile   as memptr    no-undo.
    define variable    cSufix       as character no-undo.
    define variable    iDotIndex    as integer   no-undo.
    define variable    cNewFileName as character no-undo.

    assign iDotIndex    = r-index(cFileName,".").
    assign cSufix       = " (" + string(day(today)) + "-" + string(month(today)) + "-" + string(year(today)) + "-" + replace(string(time,"HH:MM:SS"),":","") + ")" + substring(cFileName,iDotIndex).
    assign cNewFileName = "Condutor " + string(iMatricula) + cSufix.
    assign arq-anexo    = "{&path}" + cNewFileName.
    assign binaryFile   = base64-decode(cFileContent).

    copy-lob from binaryFile to file arq-anexo.
    
    if search(arq-anexo) = ? then do:
    
        {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Anexo Inv†lido!"
                &ErrorHelp="O arquivo n∆o foi encontrado!"}.
                
        return "NOK":U.
    end.
    else do:

        for first funcionario
        fields (cdn_empresa cdn_estab)
        no-lock
        where funcionario.cdn_funcionario = iMatricula.
        end.

        create cst_funcionario_anexos.
        assign cst_funcionario_anexos.cdn_empresa     = funcionario.cdn_empresa
               cst_funcionario_anexos.cdn_estab       = funcionario.cdn_estab
               cst_funcionario_anexos.cdn_funcionario = iMatricula
               cst_funcionario_anexos.dt-arquivo      = today
               cst_funcionario_anexos.hr-arquivo      = string(time,"HH:MM:SS")
               cst_funcionario_anexos.user-arquivo    = v_cod_usuar_corren
               cst_funcionario_anexos.user-os-arquivo = os-getenv("username")
               cst_funcionario_anexos.nome-arquivo    = "{&rede}ERP\_custom\producao\cstp\api\checklist\" + cNewFileName.
    end.                                                                                                                    
    return "OK":U.
                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAgendamento DBOProgram 
PROCEDURE setConstraintAgendamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter iAgendamentoCorrente as integer no-undo.

    assign agendamento = iAgendamentoCorrente.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCondutor DBOProgram 
PROCEDURE setConstraintCondutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pCondutor as character no-undo.

    assign
        cCondutor = pCondutor.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData DBOProgram 
PROCEDURE setConstraintData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pData as date no-undo.

    assign
        dData = pData.
        
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintModelo DBOProgram 
PROCEDURE setConstraintModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pModelo as character no-undo.

    assign
        cModelo = pModelo.
        
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintModeloCondutor DBOProgram 
PROCEDURE setConstraintModeloCondutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pModelo   as character no-undo.
    define input parameter pCondutor as character no-undo.

    assign
        cModelo   = pModelo
        cCondutor = pCondutor.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlaca DBOProgram 
PROCEDURE setConstraintPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pPlaca as character no-undo.

    assign
        cPlaca = pPlaca.
        
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSearch DBOProgram 
PROCEDURE setConstraintSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pModelo   as character no-undo.
    define input parameter pCondutor as character no-undo.
    define input parameter pPlaca    as character no-undo.

    assign
        cModelo   = pModelo
        cPlaca    = pPlaca
        cCondutor = pCondutor.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pType as character no-undo.
    
    define buffer checklist for cst_veiculos_checklist.

    define variable c-hora     as character no-undo.
    define variable dt-date    as datetime  no-undo.
    define variable dt-ini-agd as datetime  no-undo.
    define variable dt-fin-agd as datetime  no-undo.
    define variable c-hora-ini as character no-undo.
    define variable c-hora-fin as character no-undo.
    define variable dt-ini     as datetime  no-undo.
    define variable dt-fin     as datetime  no-undo.

        /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/
        /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
              include: method/svc/errors/inserr.i ---*/
        /*:T--- Inclua aqui as validaá‰es ---*/

    if pType = "Create":U then do:   
        if can-find (first checklist no-lock 
           where checklist.agendamento_id = RowObject.agendamento_id
           and   checklist.tipo = RowObject.tipo) then 
            {method/svc/errors/inserr.i
                 &ErrorNumber="112"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorDescription="AGENDAMENTO j† foi cadastrado com este TIPO!"
                 &ErrorHelp="Verifique se este CHECKLIST ja foi cadastrado no sistema."}
                 
        if RowObject.tipo = 1 then do:
            for first cst_veiculos_agendamento 
                fields(cst_veiculos_agendamento.agendamento_id
                       cst_veiculos_agendamento.placa)no-lock 
                where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id,
                first cst_veiculos
                fields(cst_veiculos.placa 
                       cst_veiculos.disponivel) no-lock
                where cst_veiculos.placa = cst_veiculos_agendamento.placa
                and   cst_veiculos.disponivel = false:
                {method/svc/errors/inserr.i
                     &ErrorNumber="112"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorDescription="VE÷CULO encontra-se INDISPON÷VEL!"
                     &ErrorHelp="Verifique se o ve°culo possui pendància de CHECKLIST DE RETORNO no sistema."}
            end.
            for first cst_veiculos_agendamento 
                fields(cst_veiculos_agendamento.agendamento_id
                       cst_veiculos_agendamento.situacao)no-lock 
                where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id
                and   cst_veiculos_agendamento.situacao <> 2:
                {method/svc/errors/inserr.i
                     &ErrorNumber="112"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorDescription="AGENDAMENTO n∆o autorizado!"
                     &ErrorHelp="Verifique se o agendamento foi aprovado!"}
            end.
        end.
        if RowObject.tipo = 2 then do:
            if not can-find (first checklist no-lock
                where checklist.agendamento_id = RowObject.agendamento_id
                and   checklist.tipo = 1) then
                 {method/svc/errors/inserr.i
                    &ErrorNumber="112"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Checklist RETORNO n∆o permitido antes do checklist SA÷DA!"
                    &ErrorHelp="Para incluir um checklist de RETORNO, Ç necess†rio ter um checklist de SA÷DA cadastrado previamente."}
                    
            for first cst_veiculos_agendamento 
                fields(cst_veiculos_agendamento.agendamento_id
                       cst_veiculos_agendamento.situacao)no-lock 
                where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id
                and   cst_veiculos_agendamento.situacao <> 3:
                {method/svc/errors/inserr.i
                     &ErrorNumber="112"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorDescription="AGENDAMENTO n∆o autorizado!"
                     &ErrorHelp="Verifique se o agendamento est† em Rota!"}
            end.
        end.
    end.

    if pType = "Create":U or pType = "Update":U then do:

        if not can-find (first cst_veiculos_agendamento no-lock 
            where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id) then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Numero AGENDAMENTO n∆o foi encontrado!"
                &ErrorHelp="Verifique se o numero do agendamento foi digitado corretamente."}
                 
        if RowObject.agendamento_id = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo No.AGENDAMENTO!"
                &ErrorHelp="Informe o N£mero do Agendamento."}
                 
        if RowObject.tipo = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo TIPO!"
                &ErrorHelp="Informe o Tipo do Checklist (Sa°da / Retorno)."}                      
       
        if RowObject.avaliador = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo AVALIADOR!"
                &ErrorHelp="Informe a matr°cula do avaliador respons†vel por este checklist."}
                    
        if RowObject.dt_checklist = ? then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo DATA!"
                &ErrorHelp="Informe a data do checklist."}
                    
        if RowObject.hr_checklist = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA!"
                &ErrorHelp="Informe o hor†rio do checklist."}
                    
        assign 
            c-hora = replace(RowObject.hr_checklist,":","").

        if (length(c-hora) <> 4) then
            {method/svc/errors/inserr.i
                &ErrorNumber="117"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA!"
                &ErrorHelp="Informe um hor†rio v†lido entre 00:00 e 23:59."}
        
        if (int(substring(c-hora,1,2)) > 23 ) or
           (int(substring(c-hora,3,2)) > 59 ) then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA!"
                &ErrorHelp="Informe um hor†rio v†lido entre 00:00 e 23:59."}            
                    
        if RowObject.km = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo KM!"
                &ErrorHelp="Informe a Quilometragem atual do ve°culo."}     
        
        assign
            c-hora  = replace(RowObject.hr_checklist,":","") + "00"
            dt-date = datetime(string(RowObject.dt_checklist,"99-99-9999") + " " + string(c-hora,"99:99:99")).
    
        if RowObject.tipo = 1 then do:
            for first cst_veiculos_agendamento 
                fields(cst_veiculos_agendamento.agendamento_id
                       cst_veiculos_agendamento.prev_hora_inic
                       cst_veiculos_agendamento.prev_hora_fin
                       cst_veiculos_agendamento.prev_data_inic
                       cst_veiculos_agendamento.prev_data_fin) no-lock 
                where cst_veiculos_agendamento.agendamento_id = RowObject.agendamento_id:
            end.
            assign
                c-hora-ini = replace(cst_veiculos_agendamento.prev_hora_inic,":","") + "00"
                c-hora-fin = replace(cst_veiculos_agendamento.prev_hora_fin,":","") + "00" 
                dt-ini-agd = datetime(string(cst_veiculos_agendamento.prev_data_inic,"99-99-9999") + " " + string(c-hora-ini,"99:99:99"))
                dt-fin-agd = datetime(string(cst_veiculos_agendamento.prev_data_fin,"99-99-9999") + " " + string(c-hora-fin,"99:99:99")).
            if(dt-date > dt-fin-agd) or
              ((dt-date + 1200000) < dt-ini-agd) then //tolerancia de 20 min antes do hor†rio agendado
                {method/svc/errors/inserr.i
                    &ErrorNumber="112"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Data/Hora inv†lida!"
                    &ErrorHelp="Checklist de sa°da n∆o pode ser iniciado fora do hor†rio agendado."}
        end.
        if RowObject.tipo = 2 then do:
            for first checklist 
                fields(checklist.agendamento_id 
                       checklist.hr_checklist 
                       checklist.dt_checklist) no-lock 
                where checklist.agendamento_id = RowObject.agendamento_id:
            end.
            assign
                c-hora-ini = replace(checklist.hr_checklist,":","") + "00"
                dt-ini-agd = datetime(string(checklist.dt_checklist,"99-99-9999") + " " + string(c-hora-ini,"99:99:99")).
            if (dt-date <= dt-ini-agd) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="112"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Data/Hora inv†lida!"
                    &ErrorHelp="Data/hora Checklist de retorno n∆o pode ser menor ou igual Ö data/hora checklist de sa°da."}
        end.
    end.
    
        /*:T--- Verifica ocorrància de erros ---*/
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
        
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

