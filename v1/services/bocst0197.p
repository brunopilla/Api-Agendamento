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
&GLOBAL-DEFINE DBOName BOCST0197
&GLOBAL-DEFINE DBOVersion 2.00 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cst_veiculos_agendamento
&GLOBAL-DEFINE TableLabel Agendamento
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
      
{cstp/api/v1/services/bocst0197.i RowObject}



/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

//DEFINE QUERY {&QueryName}
//  FOR {&TableName} FIELDS (placa condutor) SCROLLING.

/* define query {&QueryName} for */
/*     {&TableName},             */
/*     funcionario scrolling.    */


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable iAgendamento   as integer   no-undo. 
define variable cPlaca         as character no-undo.
define variable cModelo        as character no-undo.
define variable cCondutor      as character no-undo.
define variable cMatriculaList as character no-undo.
define variable cPlacaList     as character no-undo.
define variable dData          as date      no-undo.
define variable lTodos         as logical   no-undo.
define variable veiculo        as character no-undo.



/* mla */
def temp-table tt-mla-chave /*Temp-table com as chaves do documento*/
    field valor as char format "x(20)" extent 10.

define temp-table tt-erro      no-undo
    field i-sequen as integer
    field cd-erro  as integer
    field mensagem as character.

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
         HEIGHT             = 29.59
         WIDTH              = 45.88.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign
        rowObject.agendamento_id = next-value(seq_agendam_veic).
        rowObject.prev_hora_inic = "0000".
        rowObject.prev_hora_fin  = "0000".
    
    return "OK".

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
    if can-find (first cst_veiculos_checklist no-lock
        where cst_veiculos_checklist.agendamento_id = RowObject.agendamento_id) then do:

        {method/svc/errors/inserr.i
            &ErrorNumber="112"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorDescription="Agendamento n∆o pode ser exclu°do!"
            &ErrorHelp="Agendamento possui hist¢rico com checklists de rotas."}
    end.

    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPendenciaMLA DBOProgram 
PROCEDURE createPendenciaMLA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter pType as char no-undo.

IF RowObject.placa <> "AOA6173" THEN DO:

    empty temp-table tt-mla-chave.
    empty temp-table tt-erro.  

/* chave agendamento ve°culos */
    create tt-mla-chave.
    assign tt-mla-chave.valor[1] = string(RowObject.agendamento_id).

    find first mla-usuar-aprov
        where mla-usuar-aprov.cod-usuar = c-seg-usuario no-lock no-error.

    if not avail mla-usuar-aprov then
        {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Usu†rio " + c-seg-usuario + " n∆o cadastrado no MLA!"
                &ErrorHelp="N∆o Ç poss°vel gerar a pendància de aprovaá∆o!"}.

    for first funcionario 
        fields(cod_rh_ccusto) no-lock
        where funcionario.cdn_funcionario = RowObject.condutor:
    end.


    run lap/mlaapi001.p (INPUT 501,/* 21 = avaliaá∆o de crÇdito / 5 = cotaá∆o de materiais / 2 = solicitaá∆o de compras total / 501 = Agendamento */
                     INPUT if pType = "Create":U then 1 else 2, /* inclus∆o / update */
                     INPUT RowObject.motivo + " - " + RowObject.destino,     /* motivo - destino */
                     INPUT 0,               /* valor */
                     INPUT 0,               /* moeda */
                     INPUT c-seg-usuario,   /* user transaá∆o */
                     INPUT c-seg-usuario,   /* user doc */ 
                     INPUT funcionario.cod_rh_ccusto,
                     INPUT "",              /* item */
                     INPUT "",              /* refer */
                     INPUT "001",           /* empresa*/
                     INPUT "103",           /* estab */
                     INPUT TABLE tt-mla-chave,
                     OUTPUT TABLE tt-erro).

    if can-find(first tt-erro) then do:
        for each tt-erro.

            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Erro na geraá∆o da pendància de aprovaá∆o!"
                &ErrorHelp=string(tt-erro.cod-erro) + "-" + tt-erro.mensagem}.
        end.
    end.
END.

        /*:T--- Verifica ocorrància de erros ---*/
if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
      return "NOK":U.
       
return "OK":U.


end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePendenciaMLA DBOProgram 
PROCEDURE deletePendenciaMLA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
empty temp-table tt-mla-chave.
empty temp-table tt-erro.  

IF RowObject.placa <> "AOA6173" THEN
DO:


/* chave agendamento ve°culos */
create tt-mla-chave.
assign tt-mla-chave.valor[1] = string(RowObject.agendamento_id).

find first mla-usuar-aprov
     where mla-usuar-aprov.cod-usuar = c-seg-usuario no-lock no-error.

if not avail mla-usuar-aprov then
    {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Usu†rio " + c-seg-usuario + " n∆o cadastrado no MLA!"
                &ErrorHelp="N∆o Ç poss°vel gerar a pendància de aprovaá∆o!"}.
         
for first funcionario 
    fields(cod_rh_ccusto) no-lock
    where funcionario.cdn_funcionario = RowObject.condutor:
end.


run lap/mlaapi001.p (INPUT 501,                         /* 21 = avaliaá∆o de crÇdito / 5 = cotaá∆o de materiais / 2 = solicitaá∆o de compras total / 501 = Agendamento */
                     INPUT 3,                           /* exclus∆o */
                     INPUT string(RowObject.destino),   /* motivo - destino */
                     INPUT 0,               /* valor */
                     INPUT 0,               /* moeda */
                     INPUT c-seg-usuario,   /* user transaá∆o */
                     INPUT c-seg-usuario,   /* user doc */ 
                     INPUT funcionario.cod_rh_ccusto,
                     INPUT "",              /* item */
                     INPUT "",              /* refer */
                     INPUT "001",           /* empresa*/
                     INPUT "103",           /* estab */
                     INPUT TABLE tt-mla-chave,
                     OUTPUT TABLE tt-erro).

if not can-find(first tt-erro) then do:

    MESSAGE "Pendància de Aprovaá∆o ELIMINADA com SUCESSO!!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
end.
else do:

    for each tt-erro.

        {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Erro na eliminaá∆o da pendància de aprovaá∆o!"
                &ErrorHelp=string(tt-erro.cod-erro) + "-" + tt-erro.mensagem}.
    end.
end.
END.
        /*:T--- Verifica ocorrància de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
      RETURN "NOK":U.
       
RETURN "OK":U.

end procedure.

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
        WHEN "destino":U THEN ASSIGN pFieldValue = RowObject.destino.
        WHEN "motivo":U THEN ASSIGN pFieldValue = RowObject.motivo.
        WHEN "placa":U THEN ASSIGN pFieldValue = RowObject.placa.
        WHEN "prev_hora_fin":U THEN ASSIGN pFieldValue = RowObject.prev_hora_fin.
        WHEN "prev_hora_inic":U THEN ASSIGN pFieldValue = RowObject.prev_hora_inic.
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
        WHEN "prev_data_fin":U THEN ASSIGN pFieldValue = RowObject.prev_data_fin.
        WHEN "prev_data_inic":U THEN ASSIGN pFieldValue = RowObject.prev_data_inic.
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
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "condutor":U THEN ASSIGN pFieldValue = RowObject.condutor.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pagendamento_id LIKE cst_veiculos_agendamento.agendamento_id NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pagendamento_id = RowObject.agendamento_id.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pagendamento_id LIKE cst_veiculos_agendamento.agendamento_id NO-UNDO.

    FIND FIRST bfcst_veiculos_agendamento WHERE 
        bfcst_veiculos_agendamento.agendamento_id = pagendamento_id NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcst_veiculos_agendamento THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcst_veiculos_agendamento)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToVeiculos DBOProgram 
PROCEDURE linkToVeiculos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pHBOVeiculos     as handle    no-undo.
    define variable        cVeiculoCorrente as character no-undo.

    run getKey                in pHBOVeiculos   (output cVeiculoCorrente).
    run setConstraintVeiculos in this-procedure (input  cVeiculoCorrente).

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
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.agendamento_id = iAgendamento.
    else
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.agendamento_id = iAgendamento
            and   {&TableName}.situacao <> 0
            and   {&TableName}.situacao <> 4 by {&TableName}.prev_data_inic desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAgendamentoFilter DBOProgram 
PROCEDURE openQueryAgendamentoFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock 
        where  {&TableName}.agendamento_id = iAgendamento
        and   ({&TableName}.situacao = 2
        or     {&TableName}.situacao = 3) 
        by     {&TableName}.prev_data_inic desc.

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
        and   cst_hierarquia_func.condutor        = true:

            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.

    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock
            where lookup(string({&TableName}.condutor), cMatriculaList) > 0
            by {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock
            where lookup(string({&TableName}.condutor), cMatriculaList) > 0
            and   {&TableName}.situacao <> 0
            and   {&TableName}.situacao <> 4
            by    {&TableName}.prev_data_inic desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock 
            where  {&TableName}.prev_data_inic <= dData 
            and    {&TableName}.prev_data_fin  >= dData
            by     {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock 
            where  {&TableName}.prev_data_inic <= dData 
            and    {&TableName}.prev_data_fin  >= dData
            and    {&TableName}.situacao <> 0
            and    {&TableName}.situacao <> 4
            by     {&TableName}.prev_data_inic desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDynamic DBOProgram 
PROCEDURE openQueryDynamic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFilter DBOProgram 
PROCEDURE openQueryFilter :
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
        for each cst_hierarquia_func no-lock 
            where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
            and   cst_hierarquia_func.condutor = true: 
            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.
    
    open query {&QueryName} for each {&TableName} no-lock 
        where ({&TableName}.situacao = 2
        or    {&TableName}.situacao = 3)
        and   ({&TableName}.placa matches("*" + cPlaca + "*") 
        or lookup({&TableName}.placa, cPlacaList) > 0
        or lookup(string({&TableName}.condutor), cMatriculaList) > 0)
        by {&TableName}.prev_data_inic desc.

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
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock.
    else
        open query {&QueryName} for each {&TableName} no-lock
            where {&TableName}.situacao <> 4
            and   {&TableName}.situacao <> 0 by {&TableName}.prev_data_inic desc.
    
    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMainFilter DBOProgram 
PROCEDURE openQueryMainFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.situacao = 2
        or    {&TableName}.situacao = 3
        by    {&TableName}.prev_data_inic desc.
    
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

    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock
            where lookup({&TableName}.placa, cPlacaList) > 0
            by {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock
            where lookup({&TableName}.placa, cPlacaList) > 0
            and   {&TableName}.situacao <> 0
            and   {&TableName}.situacao <> 4
            by    {&TableName}.prev_data_inic desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlaca DBOProgram 
PROCEDURE openQueryPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.placa matches("*" + cPlaca + "*")
            by {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.placa matches("*" + cPlaca + "*")
            and   {&TableName}.situacao <> 0
            and   {&TableName}.situacao <> 4
            by    {&TableName}.prev_data_inic desc.

    return "OK":U.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlacaModeloCondutor DBOProgram 
PROCEDURE openQueryPlacaModeloCondutor :
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
        for each cst_hierarquia_func no-lock 
            where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario 
            and   cst_hierarquia_func.condutor        = true: 
            if cMatriculaList <> "" then
                cMatriculaList = cMatriculaList + "," + string(cst_hierarquia_func.cdn_funcionario).
            else
                cMatriculaList = string(cst_hierarquia_func.cdn_funcionario).
        end.
    end.
    
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.placa matches("*" + cPlaca + "*") 
            and   lookup({&TableName}.placa, cPlacaList) > 0
            and   lookup(string({&TableName}.condutor), cMatriculaList) > 0
            by {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock 
            where {&TableName}.placa matches("*" + cPlaca + "*") 
            and   lookup({&TableName}.placa, cPlacaList) > 0
            and   lookup(string({&TableName}.condutor), cMatriculaList) > 0
            and   {&TableName}.situacao <> 0
            and   {&TableName}.situacao <> 4
            by {&TableName}.prev_data_inic desc.  

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
  cNome
  cModelo
  
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
    
    if ltodos then
        open query {&QueryName} for each {&TableName} no-lock 
        where ({&TableName}.placa matches("*" + cPlaca + "*") 
        or lookup({&TableName}.placa, cPlacaList) > 0
        or lookup(string({&TableName}.condutor), cMatriculaList) > 0)
        by {&TableName}.prev_data_inic desc.
    else
        open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.situacao <> 4
        and   {&TableName}.situacao <> 0
        and   ({&TableName}.placa matches("*" + cPlaca + "*") 
        or lookup({&TableName}.placa, cPlacaList) > 0
        or lookup(string({&TableName}.condutor), cMatriculaList) > 0)
        by {&TableName}.prev_data_inic desc.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVeiculos DBOProgram 
PROCEDURE openQueryVeiculos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock 
        where cst_veiculos_agendamento.placa = veiculo
        by {&TableName}.prev_data_inic desc.
                                                      
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
    define input parameter pAgendamento as integer no-undo.
    define input parameter pTodos       as logical no-undo.

    assign
        iAgendamento = pAgendamento
        lTodos       = pTodos.

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
    define input parameter pTodos    as logical   no-undo.
    
    assign
        cCondutor = pCondutor
        lTodos    = pTodos.
    
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
    define input parameter pData  as date    no-undo.
    define input parameter pTodos as logical no-undo.

    assign
        dData  = pData
        lTodos = pTodos.

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
    define input parameter pTodos as logical no-undo.

    assign lTodos = pTodos.

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
    define input parameter pTodos  as logical   no-undo.

    assign
        cModelo = pModelo
        ltodos  = pTodos.

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
    define input parameter pTodos as logical   no-undo.

    assign
        cPlaca = pPlaca
        lTodos = pTodos.    

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlacaModeloCondutor DBOProgram 
PROCEDURE setConstraintPlacaModeloCondutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pPlaca    as character no-undo.
    define input parameter pModelo   as character no-undo.
    define input parameter pCondutor as character no-undo.
    define input parameter pTodos    as logical   no-undo.

    assign
        cModelo   = pModelo
        cPlaca    = pPlaca
        cCondutor = pCondutor
        lTodos    = pTodos.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVeiculos DBOProgram 
PROCEDURE setConstraintVeiculos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pVeiculoCorrente AS character NO-UNDO.
    assign veiculo = pVeiculoCorrente.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQueryFieldList DBOProgram 
PROCEDURE setQueryFieldList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    //define input parameter pFieldList as character no-undo.

    //assign cFieldList = pFieldList.

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
   
    define input parameter pType as char no-undo.

    define buffer agendamento for cst_veiculos_agendamento.
    
    define variable c-hora-ini           as char     no-undo.
    define variable c-hora-fin           as char     no-undo.
    define variable dt-ini               as datetime no-undo.
    define variable dt-fin               as datetime no-undo.
    define variable dt-ini-agd           as datetime no-undo.
    define variable dt-fin-agd           as datetime no-undo.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
   

    if pType = "Create":U or pType = "Update":U then do: 

        if RowObject.condutor = 0 then
            {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o CONDUTOR!"
                &ErrorHelp="Informe uma matr°cula v†lida para o campo condutor."}
        else do:
        
            for first cst_hierarquia_func
                fields(veiculos_permitidos)
                no-lock
                where cst_hierarquia_func.cdn_funcionario = RowObject.condutor:
            end.
           
            if lookup(RowObject.placa, cst_hierarquia_func.veiculos_permitidos, ";") = 0 then do:

                {method/svc/errors/inserr.i
                &ErrorNumber="112"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="VE÷CULO n∆o permitido para o CONDUTOR!"
                &ErrorHelp= "Escolha outro ve°culo ou entre em contato com o RH para solicitar a inclus∆o deste na lista de ve°culos permitidos (csfp015)."}
            end.
        end.
        if RowObject.prev_data_inic = ? then
            {method/svc/errors/inserr.i
                &ErrorNumber="113"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para DATA SA÷DA!"
                &ErrorHelp="Informe a data prevista para sa°da."}
                        
        if RowObject.prev_hora_inic = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="114"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o HORA SA÷DA!"
                &ErrorHelp="Informe o hor†rio previsto para sa°da."}
                        
        if RowObject.prev_data_fin = ? then
            {method/svc/errors/inserr.i
                &ErrorNumber="115"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o DATA RETORNO!"
                &ErrorHelp="Informe a data prevista para retorno."}
                        
        if RowObject.prev_hora_fin = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="116"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o HORA RETORNO"
                &ErrorHelp="Informe o hor†rio previsto para retorno."}
                        
        assign 
            c-hora-ini = replace(RowObject.prev_hora_inic,":","")
            c-hora-fin = replace(RowObject.prev_hora_fin,":","").
        
        if (length(c-hora-ini) <> 4) then
            {method/svc/errors/inserr.i
                &ErrorNumber="117"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA SA÷DA!"
                &ErrorHelp="Informe um hor†rio de sa°da v†lido com 4 d°gitos (de 00:00 a 23:59)."}
                        
        if (length(c-hora-fin) <> 4) then
            {method/svc/errors/inserr.i
                &ErrorNumber="117"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA RETORNO!"
                &ErrorHelp="Informe um hor†rio de sa°da v†lido com 4 d°gitos (de 00:00 a 23:59)."}                
            
        if (int(substring(c-hora-ini,1,2)) > 23 ) or
           (int(substring(c-hora-ini,3,2)) > 59 ) then
            {method/svc/errors/inserr.i
                &ErrorNumber="118"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA SA÷DA!"
                &ErrorHelp="Informe um hor†rio de sa°da v†lido (de 00:00 a 23:59)."}
        
        if (int(substring(c-hora-fin,1,2)) > 23 ) or
           (int(substring(c-hora-fin,3,2)) > 59 ) then
            {method/svc/errors/inserr.i
                &ErrorNumber="119"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo HORA RETORNO!"
                &ErrorHelp="Informe um hor†rio de retorno v†lido (de 00:00 a 23:59)."}
          
        if RowObject.destino = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="120"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo DESTINO!"
                &ErrorHelp="Informe o destino/itiner†rio da rota."}
                        
        if RowObject.motivo = "" then
            {method/svc/errors/inserr.i
                &ErrorNumber="121"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo MOTIVO!"
                &ErrorHelp="O campo MOTIVO n∆o pode ser branco."}
                        
        for first funcionario 
            fields(funcionario.cdn_funcionario
                   funcionario.cod_categ_habilit 
                   funcionario.dat_vencto_habilit) no-lock
            where funcionario.cdn_funcionario = RowObject.condutor:
        end.
             
        if not avail funcionario then
            {method/svc/errors/inserr.i
                &ErrorNumber="122"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Valor inv†lido para o campo CONDUTOR!"
                &ErrorHelp="Digite um n£mero de matr°cula v†lido para o campo condutor"}
    
        for first cst_hierarquia_func 
            fields(cst_hierarquia_func.condutor) no-lock
            where cst_hierarquia_func.cdn_funcionario = funcionario.cdn_funcionario,
            first cst_veiculos 
            fields(cst_veiculos.cod_categ_habilit) no-lock
            where cst_veiculos.placa = RowObject.placa:
            
            if (cst_hierarquia_func.condutor = false) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="123"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Condutor n∆o autorizado!"
                    &ErrorHelp="O funcion†rio indicado n∆o est† cadastrado como CONDUTOR no programa CSFP015. Entre em contato com o RH para solicitar a permiss∆o para dirgir os ve°culos da empresa."}
            
            if (length(trim(funcionario.cod_categ_habilit)) = 0) then 
                {method/svc/errors/inserr.i
                    &ErrorNumber="124"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Condutor n∆o autorizado!"
                    &ErrorHelp="A categoria da CNH do CONDUTOR n∆o est† cadastrada. Entre em contato com o RH para solicitar a atualizaá∆o dos dados do condutor"}
            
            if (substring(trim(funcionario.cod_categ_habilit), length(trim(funcionario.cod_categ_habilit))) < trim(cst_veiculos.cod_categ_habilit))
                or (trim(funcionario.cod_categ_habilit) = "ACC") then
                {method/svc/errors/inserr.i
                    &ErrorNumber="125"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Condutor n∆o autorizado!"
                    &ErrorHelp="A categoria da CNH do CONDUTOR n∆o Ç compat°vel com a categoria do ve°culo selecionado. Entre em contato com o RH para solicitar a atualizaá∆o dos dados do condutor."}
            
            if (funcionario.dat_vencto_habilit = ?) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="126"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Condutor n∆o autorizado!"
                    &ErrorHelp="A data de vencimento da CNH do CONDUTOR n∆o est† cadastrada. Entre em contato com o RH para solicitar a atualizaá∆o dos dados do condutor."}
            
            if (funcionario.dat_vencto_habilit < today ) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="127"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Condutor n∆o autorizado!"
                    &ErrorHelp="A data de vencimento da CNH do CONDUTOR no sistema est† expirada. Entre em contato com o RH para solicitar a atualizaá∆o dos dados do condutor."}
        end.

        assign 
            c-hora-ini = replace(RowObject.prev_hora_inic,":","") + "00"
            c-hora-fin = replace(RowObject.prev_hora_fin,":","")  + "00" 
            dt-ini     = datetime(string(RowObject.prev_data_inic,"99-99-9999") + " " + string(c-hora-ini,"99:99:99"))
            dt-fin     = datetime(string(RowObject.prev_data_fin,"99-99-9999")  + " " + string(c-hora-fin,"99:99:99")).
        
        if(dt-ini <= now) then
            {method/svc/errors/inserr.i
                &ErrorNumber="128"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Data Sa°da inv†lida!"
                &ErrorHelp="A Data/Hora de Sa°da deve ser maior ou igual Ö Data/Hora Atual."}
        else if (dt-fin <= dt-ini) then
            {method/svc/errors/inserr.i
                &ErrorNumber="129"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorDescription="Data Retorno inv†lida!"
                &ErrorHelp="A Data/Hora de Retorno deve ser maior que a Data/Hora de Sa°da."}
    end.
    
    assign 
        c-hora-ini = replace(RowObject.prev_hora_inic,":","") + "00"
        c-hora-fin = replace(RowObject.prev_hora_fin,":","")  + "00"
        dt-ini     = datetime(string(RowObject.prev_data_inic,"99-99-9999") + " " + string(c-hora-ini,"99:99:99"))
        dt-fin     = datetime(string(RowObject.prev_data_fin,"99-99-9999")  + " " + string(c-hora-fin,"99:99:99")).
    
    if pType = "Create":U then do:

        for each agendamento
        fields(prev_hora_inic prev_hora_fin prev_data_inic prev_data_fin)
        no-lock 
        where agendamento.situacao <> 4 
        and agendamento.placa = RowObject.placa:

            assign
                c-hora-ini = replace(agendamento.prev_hora_inic,":","") + "00"
                c-hora-fin = replace(agendamento.prev_hora_fin,":","")  + "00" 
                dt-ini-agd = datetime(string(agendamento.prev_data_inic,"99-99-9999") + " " + string(c-hora-ini,"99:99:99"))
                dt-fin-agd = datetime(string(agendamento.prev_data_fin,"99-99-9999")  + " " + string(c-hora-fin,"99:99:99")).

            if(dt-ini >= dt-ini-agd and dt-ini <= dt-fin-agd) or
              (dt-fin >= dt-ini-agd and dt-fin <= dt-fin-agd) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="130"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Data/Hora conflitante!"
                    &ErrorHelp="O ve°culo possui um agendamento prÇvio conflitante com a data/hora escolhida. Verifique a agenda do ve°culo e escolha um novo hor†rio."}
        end.
    end.
    
    if pType = "Update":U then do:
        
        for first agendamento no-lock 
            where agendamento.situacao       <> 4
            and   agendamento.placa          =  RowObject.placa 
            and   agendamento.agendamento_id <> RowObject.agendamento_id:

            assign
                c-hora-ini = replace(agendamento.prev_hora_inic,":","") + "00"
                c-hora-fin = replace(agendamento.prev_hora_fin,":","") + "00" 
                dt-ini-agd = datetime(string(agendamento.prev_data_inic,"99-99-9999") + " " + string(c-hora-ini,"99:99:99"))
                dt-fin-agd = datetime(string(agendamento.prev_data_fin,"99-99-9999") + " " + string(c-hora-fin,"99:99:99")).

            if(dt-ini >= dt-ini-agd and dt-ini <= dt-fin-agd) or
              (dt-fin >= dt-ini-agd and dt-fin <= dt-fin-agd) then
                {method/svc/errors/inserr.i
                    &ErrorNumber="131"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorDescription="Data/Hora conflitante!"
                    &ErrorHelp="O ve°culo possui um agendamento prÇvio conflitante com a data/hora escolhida. Verifique a agenda do ve°culo e escolha um novo hor†rio."}
        end.
    end.
          
            /*:T--- Verifica ocorrància de erros ---*/
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    else
        return "OK":U.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

