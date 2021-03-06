<%--
* This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
--%>
<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="Edit Bill" otherwise="/login.htm"
	redirect="/module/ehrbilling/main.form" />

<%@ include file="/WEB-INF/template/header.jsp"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/jquery-ui-1.8.2.custom.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/ui.core.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/ui.tabs.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/common.js"></script>
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/css/start/ui.tabs.css" />
<script type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/moduleResources/ehrbilling/scripts/jquery/css/start/jquery-ui-1.8.2.custom.css"></script>
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/moduleResources/ehrbilling/styles/common.css" />
<style>
span {
	color: white;
}
</style>
${tabs }
<script type="text/javascript">
jQuery(document).ready(function(){ 
    $('#container-1 ul').tabs();
    //required: Dealing with Dead Patient
     jQuery('#container-1').hide();
    
    /**
    * Text box when bill is voided & Print out of a bill that is voided
    */
	if(jQuery("#action").val() != "void")
		jQuery('#descriptionDiv').hide();
});
</script>


<script type="text/javascript">
	function addToBill( conceptId, serviceName, servicePrice, qty) {
		servicePrice = parseFloat(servicePrice);
		var colorSelected = "rgb(170, 255, 170)";
		if(document.getElementById("com_"+conceptId+"_div") != null){
			deleteInput(conceptId, serviceName, servicePrice, qty);
		}
		else
		{
			var deleteString = 'deleteInput(\"'+conceptId+'\", \"'+serviceName+'\", '+servicePrice+','+qty+')';

			var checkprice = '\"'+conceptId+'\", '+servicePrice+', this.value';

	       	var htmlText =  "<div id='com_"+conceptId+"_div'>"
	       	 +"<input name='cons' type='checkbox' value='"+conceptId+"' style='display:none; visibility:hidden;' checked='true'> "
	       	 +"<input id='"+conceptId+"_name'  name='"+conceptId+"_name' type='text' size='25' value='"+serviceName+"'  readonly='readonly'/>&nbsp;"
	       	 +"<input name='"+conceptId+"_unitPrice' value='"+servicePrice+"' type='hidden'/>" 
	       	 +"<input type='text' name='"+conceptId+"_qty' id='"+conceptId+"_qty'  class='qtyField' onblur='updatePrice("+checkprice+");' value='1' size='3'/>&nbsp;"
	       	 +"<input type='text' id='"+conceptId+"_price' name='"+conceptId+"_price' value='"+servicePrice+"' size='5'  readonly='readonly'/>"
	      	 +"<a style='color:red' href='#' onclick='"+deleteString+"' >[X]</a>"					
	       	 +"</div>";
	       	
	        var newElement = document.createElement('div');
	        newElement.setAttribute("id", conceptId);
		        
		 	newElement.innerHTML = htmlText;

	        var fieldsArea = document.getElementById('extra');
			fieldsArea.appendChild(newElement);
			var totalprice = parseFloat(document.getElementById('totalprice').value);
			document.getElementById('totalprice').value = totalprice  + servicePrice;
			document.getElementById('box_'+conceptId).style.backgroundColor=colorSelected;
			var serName = jQuery("#"+conceptId+"_name").val();
			serName = serName.replace("#","\'");
			jQuery("#"+conceptId+"_name").val(serName);
		}
	}

	function updateToBill( conceptId, serviceName, servicePrice, amount, billItemId, qty) {
		amount = parseFloat(amount);
		var colorSelected = "rgb(170, 255, 170)";
		if(document.getElementById("com_"+conceptId+"_div") != null){
			deleteInput(conceptId, serviceName, servicePrice, qty);
		}
		else
		{
			var deleteString = 'deleteInput(\"'+conceptId+'\", \"'+serviceName+'\", '+servicePrice+','+qty+')';

			var checkprice = '\"'+conceptId+'\", '+servicePrice+', this.value';

	       	var htmlText =  "<div id='com_"+conceptId+"_div'>"
	       	 +"<input name='cons' type='checkbox' value='"+conceptId+"' style='display:none; visibility:hidden;' checked='true'> "
	       	 +"<input id='"+conceptId+"_name'  name='"+conceptId+"_name' type='text' size='25' value='"+serviceName+"'  readonly='readonly'/>&nbsp;"
	       	 +"<input name='"+conceptId+"_unitPrice' value='"+servicePrice+"' type='hidden'/>"
	       	 +"<input name='"+conceptId+"_itemId' value='"+billItemId+"' type='hidden'/>" 
	       	 <%--  #342 [edit quantity of service after print]
	       	 previously value='1' modified to value='"+qty+"' --%>
	       	 +"<input type='text' name='"+conceptId+"_qty' id='"+conceptId+"_qty'  class='qtyField' onblur='updatePrice("+checkprice+");' value='"+qty+"' size='3'/>&nbsp;"
	       	 +"<input type='text' id='"+conceptId+"_price' name='"+conceptId+"_price' value='"+amount+"' size='5'  readonly='readonly'/>"
	      	 +"<a style='color:red' href='#' onclick='"+deleteString+"' >[X]</a>"					
	       	 +"</div>";
	       	
	        var newElement = document.createElement('div');
	        newElement.setAttribute("id", conceptId);
		        
		 	newElement.innerHTML = htmlText;

	        var fieldsArea = document.getElementById('extra');
			fieldsArea.appendChild(newElement);
			var totalprice = parseFloat(document.getElementById('totalprice').value);
			document.getElementById('totalprice').value = totalprice  + amount;
			document.getElementById('box_'+conceptId).style.backgroundColor=colorSelected;
			var serName = jQuery("#"+conceptId+"_name").val();
			serName = serName.replace("#","\'");
			jQuery("#"+conceptId+"_name").val(serName);
		}
	}

	
		function deleteInput( conceptId, serviceName, servicePrice,  qty) {
			var parentDiv = 'extra';
			servicePrice = parseInt(servicePrice);
		   if (conceptId == parentDiv) {
		        alert("The parent Element cannot be removed.");
		   }
		   else if (document.getElementById(conceptId)) {     
		        var child = document.getElementById(conceptId);
		        var parent = document.getElementById(parentDiv);
		        var removevalue = parseFloat(document.getElementById(conceptId+'_price').value);
		        parent.removeChild(child);
		        var totalprice = parseFloat(document.getElementById('totalprice').value);
		        document.getElementById('totalprice').value = totalprice  - removevalue;
		        document.getElementById('box_'+conceptId).style.backgroundColor="#FCCFFF";
		   }
		   else {
		        alert("Element has already been removed or does not exist.");
		        return false;
		   }
		}

		
		function updatePrice(conceptId, servicePrice, qty){
			var objRegExp  = /^ *[0-9]+ *$/;
			if( !objRegExp.test(qty) || qty=='' || qty <=0){
				alert("Please enter valid quantity!!!");
				var ele = document.getElementById(conceptId+'_qty');
				ele.focus();
			}else{		
				var initvalue = parseFloat(document.getElementById(conceptId+'_price').value);
				document.getElementById(conceptId+'_price').value = servicePrice * qty;
				var diff = parseFloat((servicePrice * qty) - initvalue);
				var total = parseFloat(document.getElementById('totalprice').value);
				document.getElementById('totalprice').value = total + diff;
			}
		}
		function submitBillForm(){
			$('#totalprice').focus();
			var ok = true;
			var objRegExp  = /^ *[0-9]+ *$/;
			jQuery(".qtyField").each(function(){
				var qty = jQuery(this).val();
				if( !objRegExp.test(qty) || qty=='' || qty <=0){
					ok = false;
				}
			});
			if( !ok ) {
				alert("Please enter valid quantity!!!");
			}else if(! jQuery("input[type='checkbox']","div#extra").length ) {
				alert("Please select item for billing");
			}else {
				jQuery("#subm").attr("disabled", "disabled");
				jQuery("#billForm").submit();
			}
		}
		function voidBill(){
			jQuery("#action").val("void");
			jQuery("#descriptionDiv").show();
			jQuery("#voi").attr("disabled", "disabled");
			return 0;
/*			jQuery("#subm").attr("disabled", "disabled");
			jQuery("#billForm").submit();*/
		}

</script>

<!-- Right side div for bill collection -->
<div id="billDiv">
	<form method="POST" id="billForm" onsubmit="return false">
		<input type="hidden" value="" name="action" id="action" />
		<div>
			<input type="button" onclick="submitBillForm()" id="subm" name="subm"
				value="<spring:message code='billing.bill.save'/>" /> <input
				type="button" id="voi" onclick="voidBill()"
				value="<spring:message code='billing.bill.void'/>" /> <input
				type="button" value="<spring:message code='general.cancel'/>"
				onclick="javascript:window.location.href='patientServiceBill.list?patientId=${patientId}'" />
			<!-- 
		    <select name="enctype"  tabindex="20" >
                <c:forEach items="${encounterTypes}" var="enct">
                    <option value="${enct.encounterTypeId}">${enct.name}</option>
                </c:forEach>
            </select>
		 -->
			<input type="button" id="toogleBillBtn" value="-"
				onclick="toogleBill(this);" class="min" style="float: right" />
		</div>
		<div id="total"
			style="background: #f6f6f6; border: 1px #808080 solid; padding: 0.3em; margin: 0.3em 0em; width: 100%;">
			<input type='text' size='25' value='Total:' />&nbsp; <input
				type='text' size='3' value='' readonly="readonly" />&nbsp; <input
				type='text' id='totalprice' name='totalprice' size='5' value='0'
				readonly="readonly" />&nbsp; <b>
		</div>

		<div id="extra" class="cancelDraggable"
			style="background: #f6f6f6; border: 1px #808080 solid; padding: 0.3em; margin: 0.3em 0em; width: 100%;">
			<input type='text' size='25' value='Service Name' readonly='readonly' />&nbsp;
			<input type='text' size="3" value='Qty' readonly="readonly" />&nbsp;
			<input type='text' size='5' value='Price' readonly="readonly" />&nbsp;</b>
			<hr />
		</div>

		<div id="descriptionDiv">
			<span style="color: blue; font-style: oblique; font-weight: bolder;">
				Description:</span> <input type="text" size="50" value=""
				name="description" id="description" class="cancelDraggable" />
		</div>


	</form>
</div>
<c:forEach items="${bill.billItems}" var="item">
<%--  [Billing]print of void bill  --%>
<c:if test="${item.voidedDate==null}">
	<c:set var="search" value="\'" />
	<c:set var="replace" value="#" />
	<c:set var="serviceName"
		value="${fn:replace(item.name,search,replace)}" />
	<script type="text/javascript">
		updateToBill(${item.service.conceptId},'${serviceName}', ${item.unitPrice},  ${item.amount}, ${item.patientServiceBillItemId}, ${item.quantity});
	</script>
	</c:if>
</c:forEach>
<%@ include file="/WEB-INF/template/footer.jsp"%>
