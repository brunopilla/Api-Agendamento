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
&GLOBAL-DEFINE DBOName BOPY085
&GLOBAL-DEFINE DBOVersion 2.00
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName funcionario
&GLOBAL-DEFINE TableLabel funcionario
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

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cstp/api/v1/services/bopy085.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE agendamento AS integer     NO-UNDO.
DEFINE VARIABLE iMatricula  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cNome       AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 13.88
         WIDTH              = 40.
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
        WHEN "cdn_efp_compcao":U THEN ASSIGN pFieldValue = RowObject.cdn_efp_compcao.
        WHEN "cdn_efp_falta_compensa":U THEN ASSIGN pFieldValue = RowObject.cdn_efp_falta_compensa.
        WHEN "cdn_empresa":U THEN ASSIGN pFieldValue = RowObject.cdn_empresa.
        WHEN "cdn_estab":U THEN ASSIGN pFieldValue = RowObject.cdn_estab.
        WHEN "cod_cart_trab":U THEN ASSIGN pFieldValue = RowObject.cod_cart_trab.
        WHEN "cod_cart_trab_ant":U THEN ASSIGN pFieldValue = RowObject.cod_cart_trab_ant.
        WHEN "cod_categ_habilit":U THEN ASSIGN pFieldValue = RowObject.cod_categ_habilit.
        WHEN "cod_certif_habilit_prof":U THEN ASSIGN pFieldValue = RowObject.cod_certif_habilit_prof.
        WHEN "cod_cgc_cei":U THEN ASSIGN pFieldValue = RowObject.cod_cgc_cei.
        WHEN "cod_cta_fgts":U THEN ASSIGN pFieldValue = RowObject.cod_cta_fgts.
        WHEN "cod_digito_cta_corren":U THEN ASSIGN pFieldValue = RowObject.cod_digito_cta_corren.
        WHEN "cod_digito_cta_corren_fgts_temp":U THEN ASSIGN pFieldValue = RowObject.cod_digito_cta_corren_fgts_temp.
        WHEN "cod_docto_milit":U THEN ASSIGN pFieldValue = RowObject.cod_docto_milit.
        WHEN "cod_forma_pagto":U THEN ASSIGN pFieldValue = RowObject.cod_forma_pagto.
        WHEN "cod_fpas_func":U THEN ASSIGN pFieldValue = RowObject.cod_fpas_func.
        WHEN "cod_func_inss":U THEN ASSIGN pFieldValue = RowObject.cod_func_inss.
        WHEN "cod_id_feder":U THEN ASSIGN pFieldValue = RowObject.cod_id_feder.
        WHEN "cod_imagem":U THEN ASSIGN pFieldValue = RowObject.cod_imagem.
        WHEN "cod_livre_1":U THEN ASSIGN pFieldValue = RowObject.cod_livre_1.
        WHEN "cod_livre_2":U THEN ASSIGN pFieldValue = RowObject.cod_livre_2.
        WHEN "cod_livre_3":U THEN ASSIGN pFieldValue = RowObject.cod_livre_3.
        WHEN "cod_livre_4":U THEN ASSIGN pFieldValue = RowObject.cod_livre_4.
        WHEN "cod_pais":U THEN ASSIGN pFieldValue = RowObject.cod_pais.
        WHEN "cod_pais_localid":U THEN ASSIGN pFieldValue = RowObject.cod_pais_localid.
        WHEN "cod_pis":U THEN ASSIGN pFieldValue = RowObject.cod_pis.
        WHEN "cod_pis_ant":U THEN ASSIGN pFieldValue = RowObject.cod_pis_ant.
        WHEN "cod_portador":U THEN ASSIGN pFieldValue = RowObject.cod_portador.
        WHEN "cod_rh_ccusto":U THEN ASSIGN pFieldValue = RowObject.cod_rh_ccusto.
        WHEN "cod_senha":U THEN ASSIGN pFieldValue = RowObject.cod_senha.
        WHEN "cod_ser_cart_trab":U THEN ASSIGN pFieldValue = RowObject.cod_ser_cart_trab.
        WHEN "cod_ser_cart_trab_ant":U THEN ASSIGN pFieldValue = RowObject.cod_ser_cart_trab_ant.
        WHEN "cod_ser_docto_milit":U THEN ASSIGN pFieldValue = RowObject.cod_ser_docto_milit.
        WHEN "cod_tip_mdo":U THEN ASSIGN pFieldValue = RowObject.cod_tip_mdo.
        WHEN "cod_tit_eletral":U THEN ASSIGN pFieldValue = RowObject.cod_tit_eletral.
        WHEN "cod_unid_federac_cart_trab":U THEN ASSIGN pFieldValue = RowObject.cod_unid_federac_cart_trab.
        WHEN "cod_unid_federac_empres_ant":U THEN ASSIGN pFieldValue = RowObject.cod_unid_federac_empres_ant.
        WHEN "cod_unid_federac_rh":U THEN ASSIGN pFieldValue = RowObject.cod_unid_federac_rh.
        WHEN "cod_unid_federac_tit_eletral":U THEN ASSIGN pFieldValue = RowObject.cod_unid_federac_tit_eletral.
        WHEN "cod_unid_lotac":U THEN ASSIGN pFieldValue = RowObject.cod_unid_lotac.
        WHEN "cod_unid_negoc":U THEN ASSIGN pFieldValue = RowObject.cod_unid_negoc.
        WHEN "cod_usuar_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.cod_usuar_ult_atualiz.
        WHEN "hra_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.hra_ult_atualiz.
        WHEN "nom_abrev_pessoa_fisic":U THEN ASSIGN pFieldValue = RowObject.nom_abrev_pessoa_fisic.
        WHEN "nom_cidad_emit_tit_eletral":U THEN ASSIGN pFieldValue = RowObject.nom_cidad_emit_tit_eletral.
        WHEN "nom_pessoa_fisic":U THEN ASSIGN pFieldValue = RowObject.nom_pessoa_fisic.
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
        WHEN "dat_admis_func":U THEN ASSIGN pFieldValue = RowObject.dat_admis_func.
        WHEN "dat_admis_transf_func":U THEN ASSIGN pFieldValue = RowObject.dat_admis_transf_func.
        WHEN "dat_cart_trab":U THEN ASSIGN pFieldValue = RowObject.dat_cart_trab.
        WHEN "dat_desligto_func":U THEN ASSIGN pFieldValue = RowObject.dat_desligto_func.
        WHEN "dat_inic_valid":U THEN ASSIGN pFieldValue = RowObject.dat_inic_valid.
        WHEN "dat_livre_1":U THEN ASSIGN pFieldValue = RowObject.dat_livre_1.
        WHEN "dat_livre_2":U THEN ASSIGN pFieldValue = RowObject.dat_livre_2.
        WHEN "dat_livre_3":U THEN ASSIGN pFieldValue = RowObject.dat_livre_3.
        WHEN "dat_livre_4":U THEN ASSIGN pFieldValue = RowObject.dat_livre_4.
        WHEN "dat_mudan_clas_inss":U THEN ASSIGN pFieldValue = RowObject.dat_mudan_clas_inss.
        WHEN "dat_nascimento":U THEN ASSIGN pFieldValue = RowObject.dat_nascimento.
        WHEN "dat_opc_fgts":U THEN ASSIGN pFieldValue = RowObject.dat_opc_fgts.
        WHEN "dat_pis_pasep":U THEN ASSIGN pFieldValue = RowObject.dat_pis_pasep.
        WHEN "dat_primei_experien_func":U THEN ASSIGN pFieldValue = RowObject.dat_primei_experien_func.
        WHEN "dat_prox_avaliac_func":U THEN ASSIGN pFieldValue = RowObject.dat_prox_avaliac_func.
        WHEN "dat_refer_cargo_func":U THEN ASSIGN pFieldValue = RowObject.dat_refer_cargo_func.
        WHEN "dat_simul_desligto_func":U THEN ASSIGN pFieldValue = RowObject.dat_simul_desligto_func.
        WHEN "dat_term_contrat_trab":U THEN ASSIGN pFieldValue = RowObject.dat_term_contrat_trab.
        WHEN "dat_term_prorrog_contrat_trab":U THEN ASSIGN pFieldValue = RowObject.dat_term_prorrog_contrat_trab.
        WHEN "dat_ult_alter_ender":U THEN ASSIGN pFieldValue = RowObject.dat_ult_alter_ender.
        WHEN "dat_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.dat_ult_atualiz.
        WHEN "dat_ult_avaliac_func":U THEN ASSIGN pFieldValue = RowObject.dat_ult_avaliac_func.
        WHEN "dat_ult_exam_medic":U THEN ASSIGN pFieldValue = RowObject.dat_ult_exam_medic.
        WHEN "dat_valid_cart_trab":U THEN ASSIGN pFieldValue = RowObject.dat_valid_cart_trab.
        WHEN "dat_vencto_habilit":U THEN ASSIGN pFieldValue = RowObject.dat_vencto_habilit.
        WHEN "dat_vencto_salfam":U THEN ASSIGN pFieldValue = RowObject.dat_vencto_salfam.
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
        WHEN "cdd_cta_corren":U THEN ASSIGN pFieldValue = RowObject.cdd_cta_corren.
        WHEN "cdd_sist_fgts":U THEN ASSIGN pFieldValue = RowObject.cdd_sist_fgts.
        WHEN "cdn_local_pagto":U THEN ASSIGN pFieldValue = RowObject.cdn_local_pagto.
        WHEN "num_cart_habilit":U THEN ASSIGN pFieldValue = RowObject.num_cart_habilit.
        WHEN "qtd_dias_provis_ferias_mes_ant":U THEN ASSIGN pFieldValue = RowObject.qtd_dias_provis_ferias_mes_ant.
        WHEN "qtd_dias_provis_ferias_provndo":U THEN ASSIGN pFieldValue = RowObject.qtd_dias_provis_ferias_provndo.
        WHEN "qtd_hrs_compcao":U THEN ASSIGN pFieldValue = RowObject.qtd_hrs_compcao.
        WHEN "qtd_hrs_falta_compensa":U THEN ASSIGN pFieldValue = RowObject.qtd_hrs_falta_compensa.
        WHEN "qtd_hrs_falta_compensa_segndo":U THEN ASSIGN pFieldValue = RowObject.qtd_hrs_falta_compensa_segndo.
        WHEN "qtd_salario_multa":U THEN ASSIGN pFieldValue = RowObject.qtd_salario_multa.
        WHEN "qtd_sdo_hrs_compensa_mes_ant":U THEN ASSIGN pFieldValue = RowObject.qtd_sdo_hrs_compensa_mes_ant.
        WHEN "val_13o_adiant_fasb":U THEN ASSIGN pFieldValue = RowObject.val_13o_adiant_fasb.
        WHEN "val_adiant_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_adiant_13o_cmcac.
        WHEN "val_aliq_irf_prestdor_serv":U THEN ASSIGN pFieldValue = RowObject.val_aliq_irf_prestdor_serv.
        WHEN "val_compcao_mes":U THEN ASSIGN pFieldValue = RowObject.val_compcao_mes.
        WHEN "val_hora_compens_mes_ant":U THEN ASSIGN pFieldValue = RowObject.val_hora_compens_mes_ant.
        WHEN "val_iss_func":U THEN ASSIGN pFieldValue = RowObject.val_iss_func.
        WHEN "val_livre_1":U THEN ASSIGN pFieldValue = RowObject.val_livre_1.
        WHEN "val_livre_2":U THEN ASSIGN pFieldValue = RowObject.val_livre_2.
        WHEN "val_livre_3":U THEN ASSIGN pFieldValue = RowObject.val_livre_3.
        WHEN "val_livre_4":U THEN ASSIGN pFieldValue = RowObject.val_livre_4.
        WHEN "val_perc_adiant":U THEN ASSIGN pFieldValue = RowObject.val_perc_adiant.
        WHEN "val_perc_enquad":U THEN ASSIGN pFieldValue = RowObject.val_perc_enquad.
        WHEN "val_perc_enquad_funcao":U THEN ASSIGN pFieldValue = RowObject.val_perc_enquad_funcao.
        WHEN "val_perc_sat":U THEN ASSIGN pFieldValue = RowObject.val_perc_sat.
        WHEN "val_provis_13o_afast":U THEN ASSIGN pFieldValue = RowObject.val_provis_13o_afast.
        WHEN "val_provis_13o_afast_ant":U THEN ASSIGN pFieldValue = RowObject.val_provis_13o_afast_ant.
        WHEN "val_provis_acum_13o":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_13o.
        WHEN "val_provis_acum_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_13o_cmcac.
        WHEN "val_provis_acum_13o_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_13o_fasb.
        WHEN "val_provis_acum_13o_ferias":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_13o_ferias.
        WHEN "val_provis_acum_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_cmcac.
        WHEN "val_provis_acum_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fasb.
        WHEN "val_provis_acum_ferias_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_ferias_cmcac.
        WHEN "val_provis_acum_ferias_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_ferias_fasb.
        WHEN "val_provis_acum_fgts_13o":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fgts_13o.
        WHEN "val_provis_acum_fgts_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fgts_13o_cmcac.
        WHEN "val_provis_acum_fgts_13o_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fgts_13o_fasb.
        WHEN "val_provis_acum_fgts_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fgts_fasb.
        WHEN "val_provis_acum_fgts_ferias":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_fgts_ferias.
        WHEN "val_provis_acum_inss_13o":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_inss_13o.
        WHEN "val_provis_acum_inss_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_inss_13o_cmcac.
        WHEN "val_provis_acum_inss_13o_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_inss_13o_fasb.
        WHEN "val_provis_acum_inss_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_inss_fasb.
        WHEN "val_provis_acum_inss_ferias":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_inss_ferias.
        WHEN "val_provis_acum_pis_13o":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_13o.
        WHEN "val_provis_acum_pis_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_13o_cmcac.
        WHEN "val_provis_acum_pis_13o_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_13o_fasb.
        WHEN "val_provis_acum_pis_ferias":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_ferias.
        WHEN "val_provis_acum_pis_ferias_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_ferias_cmcac.
        WHEN "val_provis_acum_pis_ferias_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_acum_pis_ferias_fasb.
        WHEN "val_provis_adc_13o":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_13o.
        WHEN "val_provis_adc_13o_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_13o_cmcac.
        WHEN "val_provis_adc_13o_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_13o_fasb.
        WHEN "val_provis_adc_ferias":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_ferias.
        WHEN "val_provis_adc_ferias_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_ferias_cmcac.
        WHEN "val_provis_adc_ferias_fasb":U THEN ASSIGN pFieldValue = RowObject.val_provis_adc_ferias_fasb.
        WHEN "val_provis_ferias_period_aber":U THEN ASSIGN pFieldValue = RowObject.val_provis_ferias_period_aber.
        WHEN "val_provis_fgts_ferias_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_fgts_ferias_cmcac.
        WHEN "val_provis_inss_ferias_cmcac":U THEN ASSIGN pFieldValue = RowObject.val_provis_inss_ferias_cmcac.
        WHEN "val_salario_ant":U THEN ASSIGN pFieldValue = RowObject.val_salario_ant.
        WHEN "val_salario_atual":U THEN ASSIGN pFieldValue = RowObject.val_salario_atual.
        WHEN "val_salario_atual_funcao":U THEN ASSIGN pFieldValue = RowObject.val_salario_atual_funcao.
        WHEN "val_salario_simulad":U THEN ASSIGN pFieldValue = RowObject.val_salario_simulad.
        WHEN "val_salario_simulad_funcao":U THEN ASSIGN pFieldValue = RowObject.val_salario_simulad_funcao.
        WHEN "val_sdo_hrs_compensa":U THEN ASSIGN pFieldValue = RowObject.val_sdo_hrs_compensa.
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
        WHEN "cdn_admis_caged":U THEN ASSIGN pFieldValue = RowObject.cdn_admis_caged.
        WHEN "cdn_agenc_bcia_liq":U THEN ASSIGN pFieldValue = RowObject.cdn_agenc_bcia_liq.
        WHEN "cdn_agenc_fgts_temp":U THEN ASSIGN pFieldValue = RowObject.cdn_agenc_fgts_temp.
        WHEN "cdn_bco_fgts_temp":U THEN ASSIGN pFieldValue = RowObject.cdn_bco_fgts_temp.
        WHEN "cdn_bco_hrs_abdo":U THEN ASSIGN pFieldValue = RowObject.cdn_bco_hrs_abdo.
        WHEN "cdn_bco_liq":U THEN ASSIGN pFieldValue = RowObject.cdn_bco_liq.
        WHEN "cdn_campo_aux_sit_calc":U THEN ASSIGN pFieldValue = RowObject.cdn_campo_aux_sit_calc.
        WHEN "cdn_cargo_basic":U THEN ASSIGN pFieldValue = RowObject.cdn_cargo_basic.
        WHEN "cdn_cargo_basic_funcao":U THEN ASSIGN pFieldValue = RowObject.cdn_cargo_basic_funcao.
        WHEN "cdn_categ_sal":U THEN ASSIGN pFieldValue = RowObject.cdn_categ_sal.
        WHEN "cdn_circuns_milit":U THEN ASSIGN pFieldValue = RowObject.cdn_circuns_milit.
        WHEN "cdn_clas_func":U THEN ASSIGN pFieldValue = RowObject.cdn_clas_func.
        WHEN "cdn_clien_rh":U THEN ASSIGN pFieldValue = RowObject.cdn_clien_rh.
        WHEN "cdn_cta_corren":U THEN ASSIGN pFieldValue = RowObject.cdn_cta_corren.
        WHEN "cdn_cta_corren_fgts_temp":U THEN ASSIGN pFieldValue = RowObject.cdn_cta_corren_fgts_temp.
        WHEN "cdn_demis_caged":U THEN ASSIGN pFieldValue = RowObject.cdn_demis_caged.
        WHEN "cdn_forma_pagto_bco":U THEN ASSIGN pFieldValue = RowObject.cdn_forma_pagto_bco.
        WHEN "cdn_forma_pagto_fgts_temp":U THEN ASSIGN pFieldValue = RowObject.cdn_forma_pagto_fgts_temp.
        WHEN "cdn_fornecedor":U THEN ASSIGN pFieldValue = RowObject.cdn_fornecedor.
        WHEN "cdn_fpas":U THEN ASSIGN pFieldValue = RowObject.cdn_fpas.
        WHEN "cdn_funcionario":U THEN ASSIGN pFieldValue = RowObject.cdn_funcionario.
        WHEN "cdn_func_admit_caged":U THEN ASSIGN pFieldValue = RowObject.cdn_func_admit_caged.
        WHEN "cdn_func_centrdor":U THEN ASSIGN pFieldValue = RowObject.cdn_func_centrdor.
        WHEN "cdn_func_demit_caged":U THEN ASSIGN pFieldValue = RowObject.cdn_func_demit_caged.
        WHEN "cdn_localidade":U THEN ASSIGN pFieldValue = RowObject.cdn_localidade.
        WHEN "cdn_local_marcac_cartao_pto":U THEN ASSIGN pFieldValue = RowObject.cdn_local_marcac_cartao_pto.
        WHEN "cdn_niv_cargo":U THEN ASSIGN pFieldValue = RowObject.cdn_niv_cargo.
        WHEN "cdn_niv_cargo_funcao":U THEN ASSIGN pFieldValue = RowObject.cdn_niv_cargo_funcao.
        WHEN "cdn_plano_lotac":U THEN ASSIGN pFieldValue = RowObject.cdn_plano_lotac.
        WHEN "cdn_prestdor_relacdo":U THEN ASSIGN pFieldValue = RowObject.cdn_prestdor_relacdo.
        WHEN "cdn_prestdor_serv":U THEN ASSIGN pFieldValue = RowObject.cdn_prestdor_serv.
        WHEN "cdn_regiao_milit":U THEN ASSIGN pFieldValue = RowObject.cdn_regiao_milit.
        WHEN "cdn_regiao_sal":U THEN ASSIGN pFieldValue = RowObject.cdn_regiao_sal.
        WHEN "cdn_retenc_irf":U THEN ASSIGN pFieldValue = RowObject.cdn_retenc_irf.
        WHEN "cdn_sindicato":U THEN ASSIGN pFieldValue = RowObject.cdn_sindicato.
        WHEN "cdn_sit_benefic":U THEN ASSIGN pFieldValue = RowObject.cdn_sit_benefic.
        WHEN "cdn_sit_benefic_mes_seguinte":U THEN ASSIGN pFieldValue = RowObject.cdn_sit_benefic_mes_seguinte.
        WHEN "cdn_sit_calc_func":U THEN ASSIGN pFieldValue = RowObject.cdn_sit_calc_func.
        WHEN "cdn_tab_sal":U THEN ASSIGN pFieldValue = RowObject.cdn_tab_sal.
        WHEN "cdn_tab_sal_funcao":U THEN ASSIGN pFieldValue = RowObject.cdn_tab_sal_funcao.
        WHEN "cdn_tip_contrat_func":U THEN ASSIGN pFieldValue = RowObject.cdn_tip_contrat_func.
        WHEN "cdn_turma_trab":U THEN ASSIGN pFieldValue = RowObject.cdn_turma_trab.
        WHEN "cdn_turno_trab":U THEN ASSIGN pFieldValue = RowObject.cdn_turno_trab.
        WHEN "cdn_vinc_empregat":U THEN ASSIGN pFieldValue = RowObject.cdn_vinc_empregat.
        WHEN "idi_control_integr_benefic_func":U THEN ASSIGN pFieldValue = RowObject.idi_control_integr_benefic_func.
        WHEN "idi_control_integr_benefic_prox":U THEN ASSIGN pFieldValue = RowObject.idi_control_integr_benefic_prox.
        WHEN "idi_emite_cartao_pto":U THEN ASSIGN pFieldValue = RowObject.idi_emite_cartao_pto.
        WHEN "idi_forma_pagto":U THEN ASSIGN pFieldValue = RowObject.idi_forma_pagto.
        WHEN "idi_inss_em_dia":U THEN ASSIGN pFieldValue = RowObject.idi_inss_em_dia.
        WHEN "idi_model_cart_trab":U THEN ASSIGN pFieldValue = RowObject.idi_model_cart_trab.
        WHEN "idi_natur_ativid":U THEN ASSIGN pFieldValue = RowObject.idi_natur_ativid.
        WHEN "idi_orig_contratac_func":U THEN ASSIGN pFieldValue = RowObject.idi_orig_contratac_func.
        WHEN "idi_sexo":U THEN ASSIGN pFieldValue = RowObject.idi_sexo.
        WHEN "idi_sit_fasb_cmcac_func":U THEN ASSIGN pFieldValue = RowObject.idi_sit_fasb_cmcac_func.
        WHEN "idi_tip_admis_func":U THEN ASSIGN pFieldValue = RowObject.idi_tip_admis_func.
        WHEN "idi_tip_aprop_cust":U THEN ASSIGN pFieldValue = RowObject.idi_tip_aprop_cust.
        WHEN "idi_tip_calc_irf_contrtdo":U THEN ASSIGN pFieldValue = RowObject.idi_tip_calc_irf_contrtdo.
        WHEN "idi_tip_calc_iss":U THEN ASSIGN pFieldValue = RowObject.idi_tip_calc_iss.
        WHEN "idi_tip_docto_milit":U THEN ASSIGN pFieldValue = RowObject.idi_tip_docto_milit.
        WHEN "idi_tip_estatis_func":U THEN ASSIGN pFieldValue = RowObject.idi_tip_estatis_func.
        WHEN "idi_tip_func":U THEN ASSIGN pFieldValue = RowObject.idi_tip_func.
        WHEN "idi_tip_ocor_agent_nociv":U THEN ASSIGN pFieldValue = RowObject.idi_tip_ocor_agent_nociv.
        WHEN "idi_tip_pagto_13o":U THEN ASSIGN pFieldValue = RowObject.idi_tip_pagto_13o.
        WHEN "idi_tip_pagto_ferias":U THEN ASSIGN pFieldValue = RowObject.idi_tip_pagto_ferias.
        WHEN "idi_tip_prestdor_relacdo":U THEN ASSIGN pFieldValue = RowObject.idi_tip_prestdor_relacdo.
        WHEN "idi_tip_recolhto_inss_func":U THEN ASSIGN pFieldValue = RowObject.idi_tip_recolhto_inss_func.
        WHEN "idi_tip_transp":U THEN ASSIGN pFieldValue = RowObject.idi_tip_transp.
        WHEN "idi_tip_vinc_empregat":U THEN ASSIGN pFieldValue = RowObject.idi_tip_vinc_empregat.
        WHEN "num_cartao_pto":U THEN ASSIGN pFieldValue = RowObject.num_cartao_pto.
        WHEN "num_chap_cartao_pto":U THEN ASSIGN pFieldValue = RowObject.num_chap_cartao_pto.
        WHEN "num_clas_contrib_inss":U THEN ASSIGN pFieldValue = RowObject.num_clas_contrib_inss.
        WHEN "num_digito_verfdor_func":U THEN ASSIGN pFieldValue = RowObject.num_digito_verfdor_func.
        WHEN "num_faixa_sal":U THEN ASSIGN pFieldValue = RowObject.num_faixa_sal.
        WHEN "num_faixa_sal_funcao":U THEN ASSIGN pFieldValue = RowObject.num_faixa_sal_funcao.
        WHEN "num_livre_1":U THEN ASSIGN pFieldValue = RowObject.num_livre_1.
        WHEN "num_livre_2":U THEN ASSIGN pFieldValue = RowObject.num_livre_2.
        WHEN "num_livre_3":U THEN ASSIGN pFieldValue = RowObject.num_livre_3.
        WHEN "num_livre_4":U THEN ASSIGN pFieldValue = RowObject.num_livre_4.
        WHEN "num_niv_insal":U THEN ASSIGN pFieldValue = RowObject.num_niv_insal.
        WHEN "num_niv_pericul":U THEN ASSIGN pFieldValue = RowObject.num_niv_pericul.
        WHEN "num_niv_sal":U THEN ASSIGN pFieldValue = RowObject.num_niv_sal.
        WHEN "num_niv_sal_funcao":U THEN ASSIGN pFieldValue = RowObject.num_niv_sal_funcao.
        WHEN "num_pessoa_fisic":U THEN ASSIGN pFieldValue = RowObject.num_pessoa_fisic.
        WHEN "num_reg_func":U THEN ASSIGN pFieldValue = RowObject.num_reg_func.
        WHEN "num_relogio_pto":U THEN ASSIGN pFieldValue = RowObject.num_relogio_pto.
        WHEN "num_secao_tit_eletral":U THEN ASSIGN pFieldValue = RowObject.num_secao_tit_eletral.
        WHEN "num_seq_niv_hier_funcnal":U THEN ASSIGN pFieldValue = RowObject.num_seq_niv_hier_funcnal.
        WHEN "num_zona_tit_eletral":U THEN ASSIGN pFieldValue = RowObject.num_zona_tit_eletral.
        WHEN "qti_avos_13o_calc_ant":U THEN ASSIGN pFieldValue = RowObject.qti_avos_13o_calc_ant.
        WHEN "qti_avos_13o_salario":U THEN ASSIGN pFieldValue = RowObject.qti_avos_13o_salario.
        WHEN "qti_avos_fgts_13o":U THEN ASSIGN pFieldValue = RowObject.qti_avos_fgts_13o.
        WHEN "qti_avos_fgts_13o_ant":U THEN ASSIGN pFieldValue = RowObject.qti_avos_fgts_13o_ant.
        WHEN "qti_depend_irf":U THEN ASSIGN pFieldValue = RowObject.qti_depend_irf.
        WHEN "qti_depend_salfam":U THEN ASSIGN pFieldValue = RowObject.qti_depend_salfam.
        WHEN "qti_dias_contrat_trab":U THEN ASSIGN pFieldValue = RowObject.qti_dias_contrat_trab.
        WHEN "qti_dias_prorrog_contrat_trab":U THEN ASSIGN pFieldValue = RowObject.qti_dias_prorrog_contrat_trab.
        WHEN "qti_dom_perdido_mes_seguinte":U THEN ASSIGN pFieldValue = RowObject.qti_dom_perdido_mes_seguinte.
        WHEN "qti_dom_perdido_seguinte_aux":U THEN ASSIGN pFieldValue = RowObject.qti_dom_perdido_seguinte_aux.
        WHEN "qti_fer_perdido_mes_ant_aux":U THEN ASSIGN pFieldValue = RowObject.qti_fer_perdido_mes_ant_aux.
        WHEN "qti_fer_perdido_mes_seguinte":U THEN ASSIGN pFieldValue = RowObject.qti_fer_perdido_mes_seguinte.
        WHEN "qti_livre_3":U THEN ASSIGN pFieldValue = RowObject.qti_livre_3.
        WHEN "qti_livre_4":U THEN ASSIGN pFieldValue = RowObject.qti_livre_4.
        WHEN "qti_meses_nao_optan_fgts":U THEN ASSIGN pFieldValue = RowObject.qti_meses_nao_optan_fgts.
        WHEN "qti_meses_trab_ant":U THEN ASSIGN pFieldValue = RowObject.qti_meses_trab_ant.
        WHEN "qti_pto_avaliac_func":U THEN ASSIGN pFieldValue = RowObject.qti_pto_avaliac_func.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice fncnr_id
  Parameters:  
               retorna valor do campo cdn_empresa
               retorna valor do campo cdn_estab
               retorna valor do campo cdn_funcionario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn_empresa LIKE funcionario.cdn_empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn_estab LIKE funcionario.cdn_estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn_funcionario LIKE funcionario.cdn_funcionario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn_empresa = RowObject.cdn_empresa
           pcdn_estab = RowObject.cdn_estab
           pcdn_funcionario = RowObject.cdn_funcionario.

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
        WHEN "log_ativ_calc_ppr":U THEN ASSIGN pFieldValue = RowObject.log_ativ_calc_ppr.
        WHEN "log_ativ_prov_calc_ppr":U THEN ASSIGN pFieldValue = RowObject.log_ativ_prov_calc_ppr.
        WHEN "log_atualiz_movto_prestdor_serv":U THEN ASSIGN pFieldValue = RowObject.log_atualiz_movto_prestdor_serv.
        WHEN "log_calcula_folha_normal":U THEN ASSIGN pFieldValue = RowObject.log_calcula_folha_normal.
        WHEN "log_calcula_provis_ferias_13o":U THEN ASSIGN pFieldValue = RowObject.log_calcula_provis_ferias_13o.
        WHEN "log_calcula_rescis":U THEN ASSIGN pFieldValue = RowObject.log_calcula_rescis.
        WHEN "log_calc_contrib_previd":U THEN ASSIGN pFieldValue = RowObject.log_calc_contrib_previd.
        WHEN "log_carg_epm":U THEN ASSIGN pFieldValue = RowObject.log_carg_epm.
        WHEN "log_consid_calc_folha_compl":U THEN ASSIGN pFieldValue = RowObject.log_consid_calc_folha_compl.
        WHEN "log_consid_calc_ppr":U THEN ASSIGN pFieldValue = RowObject.log_consid_calc_ppr.
        WHEN "log_consid_calc_ptoelet":U THEN ASSIGN pFieldValue = RowObject.log_consid_calc_ptoelet.
        WHEN "log_consid_carg_turno_trab":U THEN ASSIGN pFieldValue = RowObject.log_consid_carg_turno_trab.
        WHEN "log_consid_integr_ptoelet":U THEN ASSIGN pFieldValue = RowObject.log_consid_integr_ptoelet.
        WHEN "log_consid_movto_agric":U THEN ASSIGN pFieldValue = RowObject.log_consid_movto_agric.
        WHEN "log_consid_rais":U THEN ASSIGN pFieldValue = RowObject.log_consid_rais.
        WHEN "log_contrat_desativ":U THEN ASSIGN pFieldValue = RowObject.log_contrat_desativ.
        WHEN "log_contrib_sindic_em_dia":U THEN ASSIGN pFieldValue = RowObject.log_contrib_sindic_em_dia.
        WHEN "log_contrib_sindic_em_dia_ant":U THEN ASSIGN pFieldValue = RowObject.log_contrib_sindic_em_dia_ant.
        WHEN "log_correc_visual":U THEN ASSIGN pFieldValue = RowObject.log_correc_visual.
        WHEN "log_descta_contrib_sindic":U THEN ASSIGN pFieldValue = RowObject.log_descta_contrib_sindic.
        WHEN "log_descta_palim":U THEN ASSIGN pFieldValue = RowObject.log_descta_palim.
        WHEN "log_estudan":U THEN ASSIGN pFieldValue = RowObject.log_estudan.
        WHEN "log_func_qualifdo":U THEN ASSIGN pFieldValue = RowObject.log_func_qualifdo.
        WHEN "log_func_sindlz":U THEN ASSIGN pFieldValue = RowObject.log_func_sindlz.
        WHEN "log_gerad_integr_educnal":U THEN ASSIGN pFieldValue = RowObject.log_gerad_integr_educnal.
        WHEN "log_gerad_rat_func":U THEN ASSIGN pFieldValue = RowObject.log_gerad_rat_func.
        WHEN "log_integr_benefic_mes_compl":U THEN ASSIGN pFieldValue = RowObject.log_integr_benefic_mes_compl.
        WHEN "log_integr_benefic_seg_compl":U THEN ASSIGN pFieldValue = RowObject.log_integr_benefic_seg_compl.
        WHEN "log_livre_1":U THEN ASSIGN pFieldValue = RowObject.log_livre_1.
        WHEN "log_livre_2":U THEN ASSIGN pFieldValue = RowObject.log_livre_2.
        WHEN "log_livre_3":U THEN ASSIGN pFieldValue = RowObject.log_livre_3.
        WHEN "log_livre_4":U THEN ASSIGN pFieldValue = RowObject.log_livre_4.
        WHEN "log_motorista":U THEN ASSIGN pFieldValue = RowObject.log_motorista.
        WHEN "log_optan_fgts":U THEN ASSIGN pFieldValue = RowObject.log_optan_fgts.
        WHEN "log_pend_calc_ppr":U THEN ASSIGN pFieldValue = RowObject.log_pend_calc_ppr.
        WHEN "log_recebe_13o_salario":U THEN ASSIGN pFieldValue = RowObject.log_recebe_13o_salario.
        WHEN "log_recebe_adiant_normal":U THEN ASSIGN pFieldValue = RowObject.log_recebe_adiant_normal.
        WHEN "log_recebe_ferias":U THEN ASSIGN pFieldValue = RowObject.log_recebe_ferias.
        WHEN "log_recebe_insal":U THEN ASSIGN pFieldValue = RowObject.log_recebe_insal.
        WHEN "log_recebe_pericul":U THEN ASSIGN pFieldValue = RowObject.log_recebe_pericul.
        WHEN "log_recebe_rat_ppr":U THEN ASSIGN pFieldValue = RowObject.log_recebe_rat_ppr.
        WHEN "log_recolhe_fgts":U THEN ASSIGN pFieldValue = RowObject.log_recolhe_fgts.
        WHEN "log_recolhe_inss":U THEN ASSIGN pFieldValue = RowObject.log_recolhe_inss.
        WHEN "log_recolhe_irf":U THEN ASSIGN pFieldValue = RowObject.log_recolhe_irf.
        WHEN "log_salario_tabdo":U THEN ASSIGN pFieldValue = RowObject.log_salario_tabdo.
        WHEN "log_salario_tab_funcao":U THEN ASSIGN pFieldValue = RowObject.log_salario_tab_funcao.
        WHEN "log_simul_integr_benefic":U THEN ASSIGN pFieldValue = RowObject.log_simul_integr_benefic.
        WHEN "log_tempo_parcial":U THEN ASSIGN pFieldValue = RowObject.log_tempo_parcial.
        WHEN "log_usa_inss":U THEN ASSIGN pFieldValue = RowObject.log_usa_inss.
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
  Purpose:     Reposiciona registro com base no °ndice fncnr_id
  Parameters:  
               recebe valor do campo cdn_empresa
               recebe valor do campo cdn_estab
               recebe valor do campo cdn_funcionario
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcdn_funcionario LIKE funcionario.cdn_funcionario NO-UNDO.

    FIND FIRST bffuncionario WHERE 
      bffuncionario.cdn_funcionario = pcdn_funcionario NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffuncionario THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffuncionario)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} no-lock
        where {&TableName}.dat_desligto_func = ?.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMatricula DBOProgram 
PROCEDURE openQueryMatricula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.cdn_funcionario = iMatricula
        and   {&TableName}.dat_desligto_func = ?.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   open query {&QueryName} for each {&TableName} no-lock 
        where {&TableName}.nom_pessoa_fisic matches("*" + cNome + "*")
        and {&TableName}.dat_desligto_func = ?.

    return "OK":U.
END PROCEDURE.

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMatricula DBOProgram 
PROCEDURE setConstraintMatricula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pMatricula AS integer   NO-UNDO.
    assign
        iMatricula = pMatricula.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNome      AS character NO-UNDO.
    assign
        cNome = pNome.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

