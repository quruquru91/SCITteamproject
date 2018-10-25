package global.sesoc.team.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.opencv.core.Mat;
import org.opencv.highgui.Highgui;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import global.sesoc.team.dao.BusinessRepository;
import global.sesoc.team.vo.Business;
import global.sesoc.team.vo.Item;
import global.sesoc.team.vo.Receipt;


@Controller
public class BusinessController {	
	@Autowired
	BusinessRepository repository;
	
	@ResponseBody
	@RequestMapping(value = "insertBusiness", method = RequestMethod.POST)
	public List<Business> insertBusiness(@RequestBody List<Business> BusinessList, HttpSession session) {
		String empId = (String) session.getAttribute("loginId");
		int businessWith = repository.selectBusineeWith();
		businessWith = businessWith + 1;
		for (int i = 0; i < BusinessList.size(); i++) {
			if (empId.equals(BusinessList.get(i).getEmpId())) {
				BusinessList.get(i).setBusinessRepresent("true");
			} else {
				BusinessList.get(i).setBusinessRepresent("false");
			}
			BusinessList.get(i).setBusinessWith(businessWith);
			repository.insertBusiness(BusinessList.get(i));
		}
		return BusinessList;
	}
	
	@ResponseBody
	@RequestMapping(value="/businessMy" ,method=RequestMethod.GET)
	public List<Business> businessMy (HttpSession session){
		String empId = (String)session.getAttribute("loginId");
		List<Business> Blist = repository.businessMy(empId);
		return Blist;
	}
	
	public String addBusiness(String startDate ,String endDate,Model model) {
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return "calendar/addBusiness";
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteBusiness", method = RequestMethod.GET)
	public boolean deleteBusiness(String selectDate, HttpSession session) {
		Map<String, String> map = new HashMap<String, String>();
		String empId = (String) session.getAttribute("loginId");
		String date = selectDate.replace("-", "/");
		map.put("empId", empId);
		map.put("selectDate", date);
		String representer = repository.selectRepersenter(map);
		if(representer.equals(empId)) {
			repository.deleteBusinessNo(map);
			return true;
		}
			return false;
	}
	@ResponseBody
	@RequestMapping(value = "/checkRepresent", method = RequestMethod.GET)
	public String checkRepresent(String businessWith) {
		String empId = repository.checkRepresent(businessWith);
		return empId;
		
}	
	@ResponseBody
	@RequestMapping(value="/checkBusiness",method = RequestMethod.GET)
	public int checkBusiness(String selectDate,HttpSession session) {
		String sd  = selectDate.replace("-","/");
		String empId = (String)session.getAttribute("loginId");
		Map<String,String> map = new HashMap<String,String>();
		map.put("empId",empId);
		map.put("selectDate", sd);
		int businessNo = repository.checkBusiness(map);
		
		return businessNo;
	}
	
	@ResponseBody
	@RequestMapping(value="/seleteBusinessNo", method=RequestMethod.GET)
	public int seleteBusinessNo(String selectDate,HttpSession session) {
		String empId = (String)session.getAttribute("loginId");
		String sd  = selectDate.replace("-","/");

		Map<String,String> map = new HashMap<String,String>();
		map.put("empId",empId);
		map.put("selectDate", sd);
		int businessNo = repository.checkBusiness(map);
		
		return businessNo ; 
	}
	
	@ResponseBody
	@RequestMapping(value="/alreadyBusiness" , method=RequestMethod.GET)
	public boolean alreadyBusiness (String startDate,String endDate,HttpSession session) {
		String empId = (String)session.getAttribute("loginId");
		String sd  = startDate.replace("-","/");
		String ed  = endDate.replace("-","/");
		Map<String,String> map = new HashMap<String,String>();
		map.put("empId",empId);
		map.put("startDate", sd);
		map.put("endDate", ed);
		int result = repository.alreadyBusiness(map);
		if(result == 0) {
			return true;
		}
			return false;
	}
	
	@ResponseBody
	@RequestMapping(value="/selectScheduleDelete" , method=RequestMethod.GET)	
	public List<Integer> selectScheduleDelete(String businessWith,HttpSession session){
		String empId = (String)session.getAttribute("loginId");
		Map<String,String> map = new HashMap<String,String>();
		map.put("empId", empId);
		map.put("businessWith", businessWith);
		List<Integer> list = repository.selectScheduleDelete(map);
		
		return list;
	}
	
	@RequestMapping(value="/insert_reciphoto" , method=RequestMethod.GET)	
	public String reciphoto(String startDate, String scheduleNo, Model model) {
		String sd  = startDate.replace("/", "-");
		model.addAttribute("startDate",sd);
		model.addAttribute("scheduleNo",scheduleNo);
		return "fileUpload";
	}
	
	@ResponseBody
	@RequestMapping(value="/insertReceiptInfo", method=RequestMethod.POST)
	public String insertReceiptInfo(@RequestBody Receipt receipt) {
		// Receipt = scheduleno, recipeday, recipeplace, recipepay, recipememo를 포함
		// recipe 테이블에 영수증내용 저장하고 receiptNo(영수증번호 고유값) 받아오기
		int receiptNo = 0;
		String result = "";
		repository.insertReceipt(receipt);
		receiptNo = repository.selectReceiptNo();
		result = String.valueOf(receiptNo);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/insertItemInfo", method=RequestMethod.POST)
	public int insertItemInfo(@RequestBody ArrayList<Item> item) {
		// Item = recipeNo, itemNo, itemCategory, itemName, itemCount, itemPrice를 포함
		// item 테이블에 상품목록 저장
		int result = 0;
		for(Item i : item) {
			result = repository.insertItem(i);
			if(result == 0) break;
		}
		
		// 영수증 파일 저장하기
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		String uploadedFile = defaultRoute + "uploadedFile.jpg";
	    Mat receiptImage = Highgui.imread(uploadedFile, Highgui.CV_LOAD_IMAGE_COLOR);
	 
	    // 아이디, 날짜에 맞는 디렉토리 만들기
		int count = 0;
		int scheduleNo = item.get(0).getItemNo();
		String exc = ".jpg";
		String dir_scheduleNo = defaultRoute + "\\" + scheduleNo + "\\"; 	// ~\일정번호\
		String dir_fullpath = dir_scheduleNo + "\\" + "1" + exc; 			// ~\일정번호\1.jpg
		File fdir_scheduleNo = new File(dir_scheduleNo);
		File fdir_fullpath = new File(dir_fullpath);

		try {
			// 일정번호에 해당하는 폴더가 없으면 만든다
			if (!fdir_scheduleNo.exists()) {
				fdir_scheduleNo.mkdirs();
			}
			// 아이디/날짜/에다가 카운트1씩 늘려가면서 저장
			while (fdir_fullpath.exists()) {
				count++;
				dir_fullpath = dir_scheduleNo + "\\" + count + exc;
				fdir_fullpath = new File(dir_fullpath);
			}
			// 업로드한 영수증이미지 저장
			Highgui.imwrite(dir_fullpath, receiptImage);
		} catch (Exception e) {
			// e.printStackTrace();
		}
		
		return result;
	}
	
	@RequestMapping(value="/goBack", method=RequestMethod.POST)
	public String calendar() {
		return "calendar";
	}
}
