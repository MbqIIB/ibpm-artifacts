<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.Hashtable" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.rmi.PortableRemoteObject" %>
<%@ page import="javax.security.auth.login.LoginException" %>
<%@ page import="com.ibm.bpe.api.BusinessFlowManager" %>
<%@ page import="com.ibm.bpe.api.BusinessFlowManagerHome" %>
<%@ page import="com.ibm.task.api.HumanTaskManager" %>
<%@ page import="com.ibm.task.api.HumanTaskManagerHome" %>
<%@ page import="com.ibm.websphere.security.WSSecurityException" %>

<%@ page import="java.rmi.RemoteException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>

<%@ page import="javax.ejb.EJBException" %>

<%@ page import="com.ibm.bpe.api.AttributeInfo" %>
<%@ page import="com.ibm.bpe.api.BusinessFlowManager" %>
<%@ page import="com.ibm.bpe.api.EngineNotAuthorizedException" %>
<%@ page import="com.ibm.bpe.api.EngineParameterNullException" %>
<%@ page import="com.ibm.bpe.api.Entity" %>
<%@ page import="com.ibm.bpe.api.EntityInfo" %>
<%@ page import="com.ibm.bpe.api.EntityResultSet" %>
<%@ page import="com.ibm.bpe.api.FilterOptions" %>
<%@ page import="com.ibm.bpe.api.InvalidParameterException" %>
<%@ page import="com.ibm.bpe.api.UserDoesNotExistException" %>
<%@ page import="com.ibm.bpe.api.UserRegistryException" %>
<%@ page import="com.ibm.bpe.api.WorkItemManagerException" %>
<%@ page import="com.ibm.task.api.HumanTaskManager" %>
<%@ page import="com.ibm.task.api.NotAuthorizedException" %>
<%@ page import="com.ibm.task.api.ParameterNullException" %>
<%@ page import="com.ibm.task.api.UnexpectedFailureException" %>
<%@ page import="com.ibm.task.core.QueryResultSetImpl" %>

<%@ page import="teste.Teste1" %>

<%@page import="com.ibm.bpe.api.ProcessTemplateData" %>
<%@page import="com.ibm.bpe.api.ClientObjectWrapper" %>
<%@page import="commonj.sdo.DataObject" %>
<%@page import="com.ibm.bpe.api.PIID" %>


<%@page import="java.io.FileInputStream" %>
<%@page import="commonj.sdo.helper.XMLDocument" %>
<%@page import="commonj.sdo.helper.XMLHelper" %>
<%@page import="commonj.sdo.helper.XSDHelper" %>


<%@page import="com.ibm.task.api.LocalHumanTaskManagerHome" %>
<%@page import="com.ibm.task.api.LocalHumanTaskManager" %>

<%@page import="com.ibm.task.api.TKIID" %>
<%@page import="com.ibm.task.api.Task" %>

<%@page import="com.ibm.task.api.QueryResultSet" %>
<%@page import="com.ibm.bpe.api.AdminAuthorizationOptions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
TEste <br><br><br>

<%
		System.out.println("Iniciando EJBTest");
		
		Hashtable<String,String> env = new Hashtable<String, String>();
		env.put(Context.INITIAL_CONTEXT_FACTORY,"com.ibm.websphere.naming.WsnInitialContextFactory");
		env.put(Context.PROVIDER_URL, "iiop://localhost:2809/");
		System.out.println("EJBTest");
		try {
			
			InitialContext icBfm = new InitialContext(env);
			BusinessFlowManagerHome bfmHome = (BusinessFlowManagerHome) PortableRemoteObject.narrow(
			icBfm.lookup("com/ibm/bpe/api/BusinessFlowManagerHome"),BusinessFlowManagerHome.class);
			BusinessFlowManager bfm = bfmHome.create();
			
			InitialContext icHtm = new InitialContext(env);
			HumanTaskManagerHome htmHome = (HumanTaskManagerHome) PortableRemoteObject.narrow(
			icHtm.lookup("com/ibm/task/api/HumanTaskManagerHome"),HumanTaskManagerHome.class);
			HumanTaskManager htm = htmHome.create();			
			
			Teste1 t = new Teste1();
			t.autenticar();
			System.out.println(" BEGIN ");
			
			Hashtable input = new Hashtable();
				
			TKIID tkiid = null;
			TKIID tkiid2 = null;
			
			String usuarioLogado = "admin1";
			String numeroOcorrencia = "9991000111";
			
			AdminAuthorizationOptions authOpts = null;
			if (bfm.isBusinessProcessAdministrator()) {
				authOpts = new AdminAuthorizationOptions(usuarioLogado);
			}else{
				throw new Exception("Usuário não é administrador do BFM, ou seja, não faz parte da role 'BPESystemAdministrator' ");
			}
/*			
			FilterOptions filterOpts = new FilterOptions();
			filterOpts.setLocale(new Locale("en","US"));
			filterOpts.setThreshold(new Integer(20));
			filterOpts.setDistinctRows(true);
			filterOpts.setSelectedAttributes(" VALUE ");
		//	filterOpts.setQueryCondition(" ID_OCORRENCIA = '"+numeroOcorrencia+"' ");
		//	filterOpts.setQueryCondition(" QUERY_PROPERTY1.STRING_VALUE = '9991000111' ");
		//filterOpts.setDistinctRows(true);
		//out.print("======> "+filterOpts.isDistinctRows());
		
		
			out.println("<BR><BR><BR> FULL <BR><BR><BR>");
			FilterOptions filterOpts1 = new FilterOptions();
			filterOpts1.setLocale(new Locale("en","US"));
			filterOpts1.setDistinctRows(Boolean.TRUE);
			filterOpts1.setSelectedAttributes(" PA_VALUE ");
		//	filterOpts1.setQueryCondition(" NAME = 'TratarOcorrencia$TratarOcorrencia_TratarOcorrencia' ");
		//	filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED)");
			
		
	//AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED) 
		 
		 
			out.print("NUM: "+bfm.queryRowCount("BP4.FULL", filterOpts1, authOpts, null)+"<BR><BR>");
		
			com.ibm.bpe.api.EntityResultSet ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("PA_VALUE")+"<br>");
	            }
	        }	

			out.println("<BR><br> -------------------- <br> ");
*/			
 			
// recuperarOcorrenciaPorUsuarioLista :: BP4.RECUP_OCORREN_USU_LISTA.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorUsuarioLista <BR>");
out.println("<BR> FULL <BR>");
FilterOptions filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_CLAIMED AND WI.REASON = REASON_OWNER ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			com.ibm.bpe.api.EntityResultSet ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("TKIID")+"<br>");
	            }
	        }
			
			out.println("<BR> QUERYTABLE <BR>");

			com.ibm.bpe.api.EntityResultSet ers = bfm.queryEntities("BP4.RECUP_OCORREN_USU", null, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("TKIID")+
							    "[2]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR> QUERY <BR>");

			QueryResultSetImpl result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE = TASK.STATE.STATE_CLAIMED AND WORK_ITEM.REASON = WORK_ITEM.REASON.REASON_OWNER ",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getOID(1)+
							"[2]: "+result.getString(4)+"<br>");			
			}
		
// recuperarOcorrenciaPorUsuarioCount :: BP4.RECUP_OCORREN_USU_LISTA
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorUsuarioCount <BR>");
out.println("<BR> FULL <BR>");

filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setSelectedAttributes(" TKIID ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_CLAIMED AND WI.REASON = REASON_OWNER ");

out.println("[1]: "+bfm.queryEntityCount("BP4.FULL", filterOpts1, authOpts, null));

			out.println("<BR> QUERYTABLE <BR>");

FilterOptions filterOpts = new FilterOptions();
filterOpts.setDistinctRows(Boolean.TRUE);
			int count = bfm.queryEntityCount("BP4.RECUP_OCORREN_USU", filterOpts, authOpts, null);
			out.println("[1]: "+count);

			out.println("<BR> QUERY <BR>");

			 result = (QueryResultSetImpl) htm.query("COUNT(DISTINCT TASK.TKIID)",
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE = TASK.STATE.STATE_CLAIMED AND WORK_ITEM.REASON = WORK_ITEM.REASON.REASON_OWNER ",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(1));			
			}


 			
// recuperarOcorrenciaPorCelulaUsuarioListaPendencia :: BP4.RECUP_OCO_CEL_USU_PEND.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorCelulaUsuarioListaPendencia <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED, STATE_FINISHED) AND PI_STATE <> STATE_FINISHED ");

			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.RECUP_OCO_CEL_USU_PEND", null, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			result = (QueryResultSetImpl) htm.query("DISTINCT QUERY_PROPERTY1.STRING_VALUE",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND PROCESS_INSTANCE.STATE <> PROCESS_INSTANCE.STATE.STATE_FINISHED AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED, TASK.STATE.STATE_FINISHED)",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}


 			
// recuperarOcorrenciaPorCelulaUsuarioListaPendenciaCount :: BP4.RECUP_OCO_CEL_USU_PEND.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorCelulaUsuarioListaPendenciaCount <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED, STATE_FINISHED) AND PI_STATE <> STATE_FINISHED ");		
	
out.println("[1]: "+bfm.queryRowCount("BP4.FULL", filterOpts1, authOpts, null));

			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 count = bfm.queryRowCount("BP4.RECUP_OCO_CEL_USU_PEND", filterOpts, authOpts, null);
			
			out.println("[1]: "+count);		

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("COUNT(DISTINCT QUERY_PROPERTY1.STRING_VALUE)",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND PROCESS_INSTANCE.STATE <> PROCESS_INSTANCE.STATE.STATE_FINISHED AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED, TASK.STATE.STATE_FINISHED)",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}


	
			
// recuperarOcorrenciaAbertaLista :: BP4.RECUP_OCO_ABERTA.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaAbertaLista <BR>");
out.println("<BR> FULL <BR>");
filterOpts1 = new FilterOptions();
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_READY AND NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ");		
	
bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.RECUP_OCO_ABERTA", null, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE = TASK.STATE.STATE_READY AND TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento'",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}

	

 			
// recuperarOcorrenciaAbertaCount :: BP4.RECUP_OCO_ABERTA.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaAbertaCount <BR>");
out.println("<BR> FULL <BR>");
filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_READY AND NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ");		
			out.println("[1]: " + bfm.queryRowCount("BP4.FULL", filterOpts1, authOpts, null));


			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 count = bfm.queryEntityCount("BP4.RECUP_OCO_ABERTA", null, authOpts, null);
			out.println("[1]: "+count);			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("COUNT(DISTINCT TASK.TKIID)",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE = TASK.STATE.STATE_READY AND TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento'",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}


 			
// solicitarTarefa :: BP4.SOLICITAR_TAREFA.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> solicitarTarefa <BR>");
out.println("<BR> FULL <BR>");
filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_READY AND NAME <> 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ");

			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.SOLICITAR_TAREFA", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK , QUERY_PROPERTY4.TIMESTAMP_VALUE AS DATA_VENCIMENTO_PRIORIZACAO, QUERY_PROPERTY5.TIMESTAMP_VALUE AS DATA_ABERTURA",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND QUERY_PROPERTY4.NAME = 'DATA_VENCIMENTO_PRIORIZACAO' AND QUERY_PROPERTY5.NAME = 'DATA_ABERTURA' AND TASK.STATE = TASK.STATE.STATE_READY AND NOT TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}



// recuperarListaOcorrenciaPendenteWorkbasket :: BP4.RECUP_LIST_OCO_PEND_WB.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarListaOcorrenciaPendenteWorkbasket <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_READY AND NAME <> 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			
			ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			
			ers = bfm.queryEntities("BP4.RECUP_LIST_OCO_PEND_WB", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK , QUERY_PROPERTY4.TIMESTAMP_VALUE AS DATA_VENCIMENTO_PRIORIZACAO, QUERY_PROPERTY5.TIMESTAMP_VALUE AS DATA_ABERTURA",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND QUERY_PROPERTY4.NAME = 'DATA_VENCIMENTO_PRIORIZACAO' AND QUERY_PROPERTY5.NAME = 'DATA_ABERTURA' AND TASK.STATE = TASK.STATE.STATE_READY AND NOT TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' ",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}	



// recuperarOcorrenciaBPMTO :: BP4.RECUP_OCORRENCIA_BPMTO.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaBPMTO <BR>");
out.println("<BR> FULL <BR>");

 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED) ");

			
			ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			
			ers = bfm.queryEntities("BP4.RECUP_OCORRENCIA_BPMTO", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			
			result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED)",null,null,null,null);
				
			while(result.next()){
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}

//Parametro:			
//1- 
//IDOCORRENCIA
//NOME WORKBASKET	
//2- 
//IDOCORRENCIA
//LISTA WORKBASKET
//3-
//IDETAPA
//4-
//IDOCORRENCIA		
			

		

// recuperarNumeroProcessosOcorrenciaBPMTO  :: BP4.RECUP_NUM_PROC_OCO_BPMTO.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarNumeroProcessosOcorrenciaBPMTO <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED) ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.RECUP_NUM_PROC_OCO_BPMTO", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED)",null,null,null,null);
				
			while(result.next()){
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}
			
	
	
	
// validarTarefa :: BP4.VALIDAR_TAREFA.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> validarTarefa <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_READY ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.VALIDAR_TAREFA", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND TASK.STATE =  TASK.STATE.STATE_READY ",null,null,null,null);
				//AND (TASK.STATE.STATE_READY OR (TASK.OWNER = '" + mar2TO.mar2IdFuncional + "' 
			while(result.next()){
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}	
			


// recuperarOcorrenciaPorCelulaAreaNegocioUsuarioLista  :: BP4.RECUP_OCO_CEL_A_NEG_USU.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorCelulaAreaNegocioUsuarioLista <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			 ers = bfm.queryEntities("BP4.RECUP_OCO_CEL_A_NEG_USU", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("ID_OCORRENCIA")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK.TKIID, TASK_DESC.DISPLAY_NAME, TASK.TYPE, QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, PROCESS_INSTANCE.PIID AS ID_PROCESSO, TASK.WORK_BASKET AS NM_CELULA, TASK.STATE, TASK.PRIORITY, QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, TASK.OWNER, TASK.IS_WAIT_FOR_SUB_TK",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA'",null,null,null,null);

			while(result.next()){
				out.println("[1]: "+result.getString(4)+"<BR>");			
			}
		


// recuperarOcorrenciaPorCelulaAreaNegocioUsuarioCount  :: BP4.RECUP_OCO_CEL_A_NEG_USU.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorCelulaAreaNegocioUsuarioCount <BR>");
out.println("<BR> FULL <BR>");

filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) ");

out.println("[1]: "+bfm.queryRowCount("BP4.FULL", filterOpts1, authOpts, null));

			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			filterOpts = new FilterOptions();
filterOpts.setDistinctRows(Boolean.TRUE);
filterOpts.setSelectedAttributes(" ID_OCORRENCIA ");
			 count = bfm.queryRowCount("BP4.RECUP_OCO_CEL_A_NEG_USU", filterOpts, authOpts, null);
			out.println("[1]: "+count);			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("COUNT(DISTINCT QUERY_PROPERTY1.STRING_VALUE)",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA'",null,null,null,null);
				
			while(result.next()){
				
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}	



// recuperarProcessoTemplateId :: BP4.RECUP_PROC_TEMPL_ID.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarProcessoTemplateId <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_CLAIMED AND WI.REASON = REASON_OWNER ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			 ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("TKTID")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");
			
			filterOpts = new FilterOptions();
			filterOpts.setQueryCondition(" TAT_NAME = 'TratarOcorrencia$TratarOcorrencia_TratarOcorrencia' AND NAMESPACE = 'http://tratarocorrencia.businessprocess.bp4.itau/TratarOcorrencia' ");

			 ers = bfm.queryEntities("BP4.RECUP_PROC_TEMPL_ID", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("TKTID")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT TASK_TEMPL.TKTID",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK_TEMPL.NAME = 'TratarOcorrencia$TratarOcorrencia_TratarOcorrencia' AND TASK_TEMPL.NAMESPACE = 'http://tratarocorrencia.businessprocess.bp4.itau/TratarOcorrencia' AND TASK_TEMPL.VALID_FROM < CURRENT_DATE    ",null,null,null,null);

			while(result.next()){
				out.println("[1]: "+result.getOID(1)+"<BR>");			
			}





// verificarExistenciaRepactuacao :: BP4.VERIFICAR_EXIST_REPAC.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> verificarExistenciaRepactuacao <BR>");
out.println("<BR> FULL <BR>");
 filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" TKIID ");
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE IN (STATE_READY, STATE_CLAIMED)");

out.println("[1]: "+bfm.queryRowCount("BP4.FULL", filterOpts1, authOpts, null));

			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");	

			filterOpts = new FilterOptions();
filterOpts.setLocale(new Locale("en","US"));
filterOpts.setThreshold(new Integer(20));
filterOpts.setDistinctRows(true);
filterOpts.setSelectedAttributes(" TKIID ");
			count = bfm.queryRowCount("BP4.VERIFICAR_EXIST_REPAC", filterOpts, authOpts, null);
			out.println("[1]: "+count);				

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("COUNT(DISTINCT TASK.TKIID)",
			
			"QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' AND TASK.STATE IN (TASK.STATE.STATE_READY, TASK.STATE.STATE_CLAIMED)",null,null,null,null);

			while(result.next()){
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}




// recuperarVersaoWPS :: BP4.RECUPERAR_VERSAO_WPS.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarVersaoWPS <BR>");
out.println("<BR> FULL <BR>");
filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setDistinctRows(Boolean.TRUE);
filterOpts1.setSelectedAttributes(" PA_VALUE,ID_OCORRENCIA ");
filterOpts1.setQueryCondition(" ID_OCORRENCIA = '14181547355640' ");
			
			ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("PA_VALUE")+"<br>");
	            }
	        }
			
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

filterOpts = new FilterOptions();
filterOpts.setQueryCondition(" ID_OCORRENCIA = '14181547355640' ");

			ers = bfm.queryEntities("BP4.RECUPERAR_VERSAO_WPS", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("PA_VALUE")+"<br>");
	            }
	        }			

			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");

			 result = (QueryResultSetImpl) htm.query("DISTINCT PROCESS_ATTRIBUTE.NAME, PROCESS_ATTRIBUTE.VALUE",
			
			"QUERY_PROPERTY1.STRING_VALUE = '9991000111'",null,null,null,null);

			while(result.next()){
				out.println("[1]: "+result.getString(2)+"<BR>");			
			}		


/*
// TODOS :: BP4.FULL.qtd
out.println("<br>**************************************************************************************************************************************<br>");
out.println("<BR> recuperarOcorrenciaPorUsuarioLista <BR>");
out.println("<BR> FULL <BR>");
FilterOptions filterOpts1 = new FilterOptions();
filterOpts1.setLocale(new Locale("en","US"));
filterOpts1.setThreshold(new Integer(20));
filterOpts1.setQueryCondition(" KIND IN (KIND_HUMAN, KIND_PARTICIPATING) AND STATE = STATE_CLAIMED AND WI.REASON = REASON_OWNER ");

bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			com.ibm.bpe.api.EntityResultSet ers1 = bfm.queryEntities("BP4.FULL", filterOpts1, authOpts, null);
			if(ers1 != null){
	            EntityInfo ei = ers1.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers1.getEntities().size(); i++){
	                Entity entity = (Entity)ers1.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("TKIID")+"<br>");
	            }
	        }
			out.println("<BR><BR><BR> QUERYTABLE <BR><BR><BR>");

			com.ibm.bpe.api.EntityResultSet ers = bfm.queryEntities("BP4.FULL", filterOpts, authOpts, null);
			if(ers != null){
	            EntityInfo ei = ers.getEntityInfo();
	            List aiList = ei.getAttributeInfo();
	            for(int i = 0; i < ers.getEntities().size(); i++){
	                Entity entity = (Entity)ers.getEntities().get(i);
					out.println("[1]: "+entity.getAttributeValue("NUMERO_OCORRENCIA")+"<br>");
	            }
	        }	
			
			out.println("<BR><BR><BR> QUERY <BR><BR><BR>");
			
			QueryResultSetImpl result = (QueryResultSetImpl) htm.query("QUERY_PROPERTY1.STRING_VALUE",
			
			"QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' AND QUERY_PROPERTY2.VARIABLE_NAME = 'configuracaoHT' AND QUERY_PROPERTY1.STRING_VALUE = '14181498625110'", null,null,null,null);

			while(result.next()){
				out.println("[1]: "+result.getString(1)+"<BR>");			
			}
*/
			

/*
QueryResultSetImpl result = (QueryResultSetImpl) htm.query(" DISTINCT TASK.TKIID, "+
" TASK_DESC.DISPLAY_NAME, "+
" TASK.TYPE, "+
" QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, "+
" QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, "+
" PROCESS_INSTANCE.PIID AS ID_PROCESSO, "+
" TASK.WORK_BASKET AS NM_CELULA, "+
" TASK.STATE, "+
" TASK.PRIORITY, "+
" QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, "+
" TASK.OWNER, "+
" QUERY_PROPERTY4.TIMESTAMP_VALUE AS DATA_VENCIMENTO_PRIORIZACAO, "+
" QUERY_PROPERTY5.TIMESTAMP_VALUE AS DATA_ABERTURA ",
" QUERY_PROPERTY0.NAME = 'SOLUTION' "+
" AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' "+
" AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) "+
" AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' "+
" AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' "+
" AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' "+
" AND QUERY_PROPERTY4.NAME = 'DATA_VENCIMENTO_PRIORIZACAO' "+
" AND QUERY_PROPERTY5.NAME = 'DATA_ABERTURA' "+
" AND TASK.STATE = TASK.STATE.STATE_READY "+
" AND NOT TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' "+
" AND TASK.WORK_BASKET IN ( 'AREA_1' ) ",null,null,null,null);

			out.println("size: "+result.size());
			// AND TASK.TKIID = ID('_TKI:a01b0144.279f97f6.fec7573f.b315017f')
			while(result.next()){
				
				out.println("TKIID: "+result.getOID(1)+
							" ---- CONTAINMENT_CTX_ID: "+result.getOID(2)+
							"TASK.IS_WAIT_FOR_SUB_TK: "+result.getString(3)+"<br>");
				String ooid = ""+result.getOID(1);
				// Suportar Tratamento
				if( ooid.contains("a01b0144.2bf91704.fec7573f.b3151268")){
					tkiid = (TKIID) result.getOID(1);
				}
				// Tratar Ocorrencia
				if( ooid.contains("a01b0144.279f97f6.fec7573f.b315017f")){
					tkiid2 = (TKIID) result.getOID(1);
				}				
			}
*/

/*
			
			//Suportar Tratamento
			Task taskI = htm.getTask(tkiid);
			out.println("<BR><BR> Suportar Tratamento ... <br><br>");
out.println("<br> ID = "+taskI.getID().toString());			
out.println("<br> getTopLevelTaskID: "+taskI.getTopLevelTaskID());
out.println("<br> getParentContextID: "+taskI.getParentContextID());
out.println("<br> getContainmentContextID: "+taskI.getContainmentContextID());
out.println("<br> isChild: "+taskI.isChild());
out.println("<br> isInline: "+taskI.isInline());
out.println("<br> isSupportsSubTasksUpdateable: "+taskI.isSupportsSubTasksUpdateable());
out.println("<br> getApplicationDefaultsID: "+taskI.getApplicationDefaultsID());
out.println("<br> getInvokedInstanceID: "+taskI.getInvokedInstanceID());	
			
			
			out.println("<BR><BR> Tratar Ocorrencia ... <br><br>");
			// Tratar Ocorrencia
			Task taskII = htm.getTask(tkiid2);
out.println("<br> ID = "+taskII.getID().toString());			
out.println("<br> getTopLevelTaskID: "+taskII.getTopLevelTaskID());
out.println("<br> getParentContextID: "+taskII.getParentContextID());
out.println("<br> getContainmentContextID: "+taskII.getContainmentContextID());
out.println("<br> isChild: "+taskII.isChild());
out.println("<br> isInline: "+taskII.isInline());
out.println("<br> isSupportsSubTasksUpdateable: "+taskII.isSupportsSubTasksUpdateable());
out.println("<br> getApplicationDefaultsID: "+taskII.getApplicationDefaultsID());
out.println("<br> getInvokedInstanceID: "+taskII.getInvokedInstanceID());			
			
out.println(" <br> FIM <br> ");

out.println(" Testando recuperar variaveis ");
String numeroOcorrencia = "";
numeroOcorrencia = (String) bfm.getVariable(""+taskI.getParentContextID(), "numeroOcorrencia").getObject();
out.println(" <br> numeroOcorrencia ->> "+numeroOcorrencia);

			String selectClause = "DISTINCT QUERY_PROPERTY.PIID";
			String whereClause = "QUERY_PROPERTY.VARIABLE_NAME = 'numeroOcorrencia' and QUERY_PROPERTY.STRING_VALUE = '" + numeroOcorrencia + "'";
			QueryResultSet q = htm.query(selectClause, whereClause, null, null, null, null);
			java.util.List<String> piids = new java.util.ArrayList<String>();
			if(q.size() > 0){
				while(q.next()){
					piids.add("ID('" + q.getOID(1)+"')");
				}
				selectClause = "DISTINCT TASK.TKIID, TASK.NAME, TASK.IS_WAIT_FOR_SUB_TK";
				whereClause = "TASK.CONTAINMENT_CTX_ID IN (" + piids + ") AND " +
						"(TASK.IS_WAIT_FOR_SUB_TK = 1) AND " +
						"(TASK.STATE IN (8, 2))"; //retornar apenas tarefas claimed e ready
				whereClause = whereClause.replace("[", "").replace("]", "");
				String orderByClause = "TASK.STARTED DESC";
				q = htm.query(selectClause, whereClause, orderByClause, null, null, null);
				while(q.next()){
					out.println(" <br> TASK.TKIID>>  "+q.getOID(1).toString());
				}
				
			}





*/
				
			System.out.println("fim ");			
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Erro:"+e.getMessage());
		}
	

%>


<%!

	public static String iniciarTratamento(){
		return 
		"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
		"<p:iniciarTratamentoOcorrencia xsi:type=\"p:iniciarTratamentoOcorrencia_._type\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:p=\"http://iniciartratamento.businessprocess.bp4.itau/\">"+
		"  <ocorrencia>"+
		"	<numeroOcorrencia>2010801</numeroOcorrencia>"+
		"	<aberturaOcorrencia>2012-03-02T13:46:01.000Z</aberturaOcorrencia>"+
		"	<cliente>"+
		"	  <nomeCliente>LEONARDO YUITI MIZUSAKI</nomeCliente>"+
		"	  <tipoCliente>F</tipoCliente>"+
		"	  <segmento>1</segmento>"+
		"	  <areaNegocio></areaNegocio>"+
		"	</cliente>"+
		"	<assuntoOcorrencia>-31459</assuntoOcorrencia>"+
		"	<scoreAtrito>G</scoreAtrito>"+
		"	<ocorrenciaReaberta>False</ocorrenciaReaberta>"+
		"	<ocorrenciaReincidente>False</ocorrenciaReincidente>"+
		"	<tipoManifestacao>2</tipoManifestacao>"+
		"	<canalAtendimento>49</canalAtendimento>"+
		"	<vencimentoOcorrencia>2012-03-09T12:46:00.000Z</vencimentoOcorrencia>"+
		"	<tipoRegistro>2</tipoRegistro>"+
		"	<situacaoOcorrencia>2</situacaoOcorrencia>"+
		"	<codigoPrioridade>7</codigoPrioridade>"+
		"	<vencimentoOriginalOcorrencia>2012-03-09T12:46:00.000Z</vencimentoOriginalOcorrencia>"+
		"  </ocorrencia>"+
		"</p:iniciarTratamentoOcorrencia>";	
		
	}	

	private static void definePOTypes() throws Exception {
		  FileInputStream fis = 
			  new FileInputStream("C:\\workspaces\\itau_ouvidoria_V2_3\\javatesteMatheus\\src\\teste.xsd");
		  XSDHelper.INSTANCE.define(fis, null);
		  fis.close();
	}
	
	public static String getSelectClauseM(){
		return "DISTINCT QUERY_PROPERTY9.STRING_VALUE ";
	}

	public static String getSelectClause(){
			return  " DISTINCT TASK.TKIID, "+
					" TASK_DESC.DISPLAY_NAME, "+
					" TASK.TYPE, "+
					" QUERY_PROPERTY1.STRING_VALUE AS ID_OCORRENCIA, "+
					" QUERY_PROPERTY2.STRING_VALUE AS CD_QUALIFICACAO, "+
					" PROCESS_INSTANCE.PIID AS ID_PROCESSO, "+
					" TASK.WORK_BASKET AS NM_CELULA, "+
					" TASK.STATE, "+
					" TASK.PRIORITY, "+
					" QUERY_PROPERTY3.NUMBER_VALUE AS STATUS_OCORRENCIA, "+
					" TASK.OWNER, "+
					" QUERY_PROPERTY4.TIMESTAMP_VALUE AS DATA_VENCIMENTO_PRIORIZACAO, "+
					" QUERY_PROPERTY9.TIMESTAMP_VALUE AS DATA_ABERTURA ";
	}
	
	public static String getWhereClauseHelper(){
		return "QUERY_PROPERTY0.NAME = 'SOLUTION' AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' " +
        "AND PROCESS_INSTANCE.STATE = PROCESS_INSTANCE.STATE.STATE_RUNNING " +
        "AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' AND QUERY_PROPERTY1.STRING_VALUE = '11' ";
	}
	
	public static String getWhereClauseM(){
		return " PROCESS_INSTANCE.TEMPLATE_NAME='IniciarTratamento' ";
	}
	
	public static String getWhereClause(){
		return 	"   "+
				" QUERY_PROPERTY0.NAME = 'SOLUTION' "+
				" AND QUERY_PROPERTY0.STRING_VALUE = 'BP4' "+
				" AND TASK.KIND IN (TASK.KIND.KIND_HUMAN, TASK.KIND.KIND_PARTICIPATING) "+
				" AND QUERY_PROPERTY1.NAME = 'NUMERO_OCORRENCIA' "+
				" AND QUERY_PROPERTY2.NAME = 'CODIGO_QUALIFICACAO' "+
				" AND QUERY_PROPERTY3.NAME = 'STATUS_OCORRENCIA' "+
				" AND QUERY_PROPERTY4.NAME = 'DATA_VENCIMENTO_PRIORIZACAO' "+
				" AND QUERY_PROPERTY19.NAME = 'DATA_ABERTURA' "+
				" AND TASK.STATE = TASK.STATE.STATE_READY "+
				" AND NOT TASK.NAME = 'IniciarTratamento$IniciarTratamentoOcorrencia_CompletarPreenchimento' "+
				" AND TASK.WORK_BASKET IN ( 'NAO_SE_APLICA' ) ";			
	}

	public void bfmTableBuilder(final String numeroOcorrencia,BusinessFlowManager bfm) throws Exception {
		
		FilterOptions filterOpts = new FilterOptions();
		filterOpts.setLocale(new Locale("en","US"));
		filterOpts.setThreshold(new Integer(20));
		filterOpts.setQueryCondition("WORK_BASKET IN ('"+numeroOcorrencia+"') ");		
	
		// TABLE BUILDER
		EntityResultSet ers = bfm.queryEntities("PREFIX.NAME2", filterOpts, null, null);
		if(ers != null){
            EntityInfo ei = ers.getEntityInfo();
            List aiList = ei.getAttributeInfo();
            for(int i = 0; i < ers.getEntities().size(); i++){
                Entity entity = (Entity)ers.getEntities().get(i);
                System.out.println("Lista AttributeInfo contem " + aiList.size() + " itens");
                for(int j = 0; j < aiList.size(); j++){
                    AttributeInfo ai = (AttributeInfo)aiList.get(j);
                    System.out.println("Label: " + ai.getName()+ " - VALUE: "+entity.getAttributeValue(ai.getName()));
                }
            }
        }
	}
	
	public void bfmQuery(String selectClause, String whereClause, final String numeroOcorrencia,BusinessFlowManager bfm) throws Exception {
		
		QueryResultSetImpl result = (QueryResultSetImpl) bfm.query(selectClause,whereClause,null,null,null,null);
		System.out.println("size: "+result.size());
		while(result.next()){
			System.out.println("sim");
//			System.out.println("TASK.TKIID -> "+result.getOID(0).toString());
		}
	}

	public void htmTableBuilder(final String numeroOcorrencia,HumanTaskManager htm) throws Exception{
		com.ibm.task.api.FilterOptions filterOpts = new com.ibm.task.api.FilterOptions();
		filterOpts.setLocale(new Locale("en","US"));
		filterOpts.setThreshold(new Integer(20));
		filterOpts.setQueryCondition("WORK_BASKET IN ('"+numeroOcorrencia+"') ");
		
		com.ibm.task.api.EntityResultSet ers = htm.queryEntities("PREFIX.NAME2", filterOpts, null, null);
		if(ers != null){
            com.ibm.task.api.EntityInfo ei = ers.getEntityInfo();
            List aiList = ei.getAttributeInfo();
            for(int i = 0; i < ers.getEntities().size(); i++){
                com.ibm.task.api.Entity entity = (com.ibm.task.api.Entity)ers.getEntities().get(i);
                System.out.println("Lista AttributeInfo contem " + aiList.size() + " itens");
                for(int j = 0; j < aiList.size(); j++){
                    com.ibm.task.api.AttributeInfo ai = (com.ibm.task.api.AttributeInfo)aiList.get(j);
                    System.out.println("Label: " + ai.getName()+ " - VALUE: "+entity.getAttributeValue(ai.getName()));
                }
            }
        }
	}
	
	public void htmQuery(String selectClause, String whereClause, final String numeroOcorrencia,HumanTaskManager htm) throws Exception{ 

		QueryResultSetImpl result = (QueryResultSetImpl) htm.query(selectClause,whereClause,null,null,null,null);
		System.out.println("size: "+result.size());
		while(result.next()){
			System.out.println("-> "+result.getString(1));
		}	
		
	}
	
	public void htmTableBuilderRow(final String numeroOcorrencia, HumanTaskManager htm){

		try {	
			
			com.ibm.task.api.FilterOptions filterOpts = new com.ibm.task.api.FilterOptions();
			filterOpts.setLocale(new Locale("en","US"));
			filterOpts.setThreshold(new Integer(20));
			filterOpts.setQueryCondition("WORK_BASKET IN ('"+numeroOcorrencia+"') ");
			
			com.ibm.task.api.RowResultSet ers = htm.queryRows("BP4.SOLICITAR_OCORRENCIA", filterOpts, null, null);
			while(ers.next()){
	            List aiList = ers.getAttributeInfo();
                System.out.println("Lista AttributeInfo contem " + aiList.size() + " itens");
                for(int j = 0; j < aiList.size(); j++){
                    com.ibm.task.api.AttributeInfo ai = (com.ibm.task.api.AttributeInfo)aiList.get(j);
                    System.out.println("Label: " + ai.getName()+ " - VALUE: "+ers.getAttributeValue(ai.getName()));
                }
			}				
			
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
			e.printStackTrace(System.out);
		}

		System.out.println(" END ConsultarAtividadesOcorrencia ");
		
	}
	
	
%>
</body>
</html>