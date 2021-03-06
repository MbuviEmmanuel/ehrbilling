/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

package org.openmrs.module.ehrbilling.web.controller.miscellaneousservice;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.model.MiscellaneousService;
import org.openmrs.module.hospitalcore.util.PagingUtil;
import org.openmrs.module.hospitalcore.util.RequestUtil;
import org.openmrs.web.WebConstants;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;


/**
 *
 */
@Controller
@RequestMapping("/module/ehrbilling/miscellaneousService.list")
public class MiscellaneousServiceListController {
	Log log = LogFactory.getLog(getClass());
    
    @RequestMapping(method=RequestMethod.POST)
    public String deleteMiscellaneousServices(@RequestParam("ids") String[] ids,HttpServletRequest request){
    	
    	HttpSession httpSession = request.getSession();
		Integer miscellaneousServiceId  = null;
		try{
			BillingService billingService = (BillingService)Context.getService(BillingService.class);
			if( ids != null && ids.length > 0 ){
				for(String sId : ids )
				{
					miscellaneousServiceId = Integer.parseInt(sId);
					MiscellaneousService miscellaneousService = billingService.getMiscellaneousServiceById(miscellaneousServiceId);
					if( miscellaneousService != null )
					{
						billingService.deleteMiscellaneousService(miscellaneousService);
					}
				}
			}
		}catch (Exception e) {
			httpSession.setAttribute(WebConstants.OPENMRS_MSG_ATTR,
			"Can not delete miscellaneousService because it has link to bill ");
			log.error(e);
			return "redirect:/module/ehrbilling/miscellaneousService.list";
		}
		httpSession.setAttribute(WebConstants.OPENMRS_MSG_ATTR,
		"MiscellaneousService.deleted");
    	
    	return "redirect:/module/ehrbilling/miscellaneousService.list";
    }
	
    @RequestMapping(method=RequestMethod.GET)
	public String listMiscellaneousService(@RequestParam(value="pageSize",required=false)  Integer pageSize, 
	                         @RequestParam(value="currentPage",required=false)  Integer currentPage,
	                         Map<String, Object> model, HttpServletRequest request){
		
		BillingService billingService = Context.getService(BillingService.class);
		
		int total = billingService.countListMiscellaneousService();
		
		PagingUtil pagingUtil = new PagingUtil( RequestUtil.getCurrentLink(request) , pageSize, currentPage, total );
		
		List<MiscellaneousService> miscellaneousServices = billingService.listMiscellaneousService(pagingUtil.getStartPos(), pagingUtil.getPageSize());
		
		model.put("miscellaneousServices", miscellaneousServices );
		
		model.put("pagingUtil", pagingUtil);
		
		return "/module/ehrbilling/miscellaneousService/list";
	}
}
