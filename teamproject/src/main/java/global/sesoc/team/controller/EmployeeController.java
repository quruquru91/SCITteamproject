package global.sesoc.team.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import global.sesoc.team.dao.EmployeeRepository;
import global.sesoc.team.vo.Business;
import global.sesoc.team.vo.Employee;


@Controller
public class EmployeeController {
	List<Employee> EList = new ArrayList<Employee>();
	
	@Autowired
	EmployeeRepository repository;
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String login() {
		
		return "login";
	}
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(HttpSession session, String empid, String password,HttpServletResponse response) throws IOException {
		Employee employee = new Employee();
		employee.setEmpid(empid);
		employee.setEmppassword(password);
		Employee emp = repository.login(employee);
		if(emp!=null) {
			
		session.setAttribute("loginId", emp.getEmpid());
		session.setAttribute("loginName", emp.getEmpname());
		session.setAttribute("companyNo", emp.getCompanyno());
		session.setAttribute("empAuthorization", emp.getEmpauthorization());
		return "calendar";
		}
		else {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('해당 아이디나 비밀번호가 없습니다');</script>");
			out.flush();
			return "login";
		}
	}
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
	
	@RequestMapping(value="/signup", method=RequestMethod.GET)
	public String signup() {
		
		return "signup";
	}
	
	@RequestMapping(value="/signup", method=RequestMethod.POST)
	public String signup(Employee employee) {
		repository.insertEmployee(employee);
		
		return "login";
	}
	
	@ResponseBody
	@RequestMapping(value="/checkId", method=RequestMethod.POST)
	public Integer checkId(@RequestBody Employee employee) {
		Employee emp = repository.selectOne(employee);
		if(emp != null) {
			return 1;
		}else {
			return 0;
		}
	}
	
	@RequestMapping(value="/updateEmployee", method=RequestMethod.GET)
	public String updateEmployee(HttpSession session, Model model) {
		String empId = (String)session.getAttribute("loginId");
		Employee employee = new Employee();
		employee.setEmpid(empId);
		Employee emp = repository.login(employee);
		model.addAttribute("employee", emp);
		
		return "updateEmployee";
	}
	
	@RequestMapping(value="/updateEmployee", method=RequestMethod.POST)
	public String updateEmployee(Employee employee) {
		repository.updateEmployee(employee);
		
		return "redirect:/";
	}
	
	@RequestMapping(value="/calendar", method=RequestMethod.GET)
	public String calendar(HttpSession session,HttpServletResponse response) throws IOException {
		String empId = (String)session.getAttribute("loginId");
		if(empId !=null) {
			return "calendar";
		}
		else {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('로그인 후 사용해주세요');</script>");
			out.flush();
			return "login";
		}
		
		
	}
	
	@RequestMapping(value="/statistic", method=RequestMethod.GET)
	public String statistic(Model model, HttpSession session,HttpServletResponse response) throws IOException {
		String loginId = (String)session.getAttribute("loginId");
		if(loginId!=null) {
		List<Map<String, Object>> businessTrips = repository.selectAllTrip(loginId);
		model.addAttribute("businessTrips", businessTrips);
		return "statistic";
	}
	else {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('로그인 후 사용해주세요');</script>");
		out.flush();
		return "login";
	}
}
	
	@RequestMapping(value="/statisticManager", method=RequestMethod.GET)
	public String statisticManger(HttpSession session, Model model) {
		List<Employee> employees = new ArrayList<Employee>();
		String companyNoBefore = (String)session.getAttribute("companyNo");
		int companyNo = Integer.parseInt(companyNoBefore);
		employees = repository.selectEmpAll(companyNo);
		model.addAttribute("employees", employees);
		return "statisticManager";
	}
	
	@RequestMapping(value="/statisticCompany", method=RequestMethod.GET)
	public String statisticCompany() {

		return "statisticCompany";
	}

	@RequestMapping(value="/statisticChoice", method=RequestMethod.GET)
	public String statisticChoice() {

		return "statisticChoice";
	}
	
	@ResponseBody
	@RequestMapping(value="/bringLcData", method=RequestMethod.GET)
	public List<Object> bringLcData(String companyNo) {
		List<Object> dates = new ArrayList<Object>();
		dates = repository.selectLocation(companyNo);
		
		
		return dates;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/bringEmployees", method=RequestMethod.GET)
	public ArrayList<Employee> bringEmployees(HttpSession session) {
		String companynumber = (String)session.getAttribute("companyNo");
		int companyno = Integer.parseInt(companynumber);
		ArrayList<Employee> employees = repository.selectEmpAll(companyno);
		return employees;
	}
	
	@ResponseBody
	@RequestMapping(value="/bringTrip", method=RequestMethod.GET)
	public List<Map<String, Object>> bringTrip(String empid) {
		List<Map<String, Object>> businessTrips = new ArrayList<Map<String,Object>>();
		businessTrips = repository.selectAllTrip(empid);
		return businessTrips;
	}
	
	@RequestMapping(value="/addCoworker", method=RequestMethod.GET)
	public String addCoworker() {
		return "calendar/addCoworker";
	}
	
	
	@ResponseBody
	@RequestMapping(value="/searchName", method=RequestMethod.GET) 
	public List<Employee> searchName(String companyNo , String empname) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("companyno", companyNo);
		map.put("empname", empname);
		List<Employee> list = repository.searchName(map);
		
		return list; 
	}
	
	@ResponseBody
	@RequestMapping(value="/selectCompanyCoworker" , method=RequestMethod.GET)
	public List<Employee> selectCompanyCoworker(String companyNo,HttpSession session){
		String empId = (String)session.getAttribute("loginId");
		List<Employee> EmployeeList = new ArrayList<Employee>();
		Map<String,String> map = new HashMap<String,String>();
		
		map.put("empId",empId);
		map.put("companyno", companyNo);
		EmployeeList = repository.selectCompanyCoworker(map);
		return EmployeeList; // 이거 고친거
	}
	
	@ResponseBody
	@RequestMapping(value="/sendBw", method=RequestMethod.GET) 
	public Map<String,Object> sendBw(String businessWith) {
		Map<String,Object> container = new HashMap<String,Object>();
		List<Map<String,Object>> schedules = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> schedules2 = new ArrayList<Map<String,Object>>();
		List<String> dates = new ArrayList<String>();


		
		Business business = repository.selectBusiness(businessWith);
		int businessNo = business.getBusinessNo();
		schedules = repository.selectAllitems2(businessNo);
		schedules2 = repository.selectAllitems3(businessNo);
		dates = repository.selectScheduleDays(businessNo);
		
		
		container.put("schedules", schedules);
		container.put("dates", dates);
		container.put("schedules2", schedules2);
		

		
		return container; 
	}
	
	@ResponseBody
	@RequestMapping(value="/sendSc", method=RequestMethod.GET) 
	public List<Map<String, Object>> sendSc(String businessWith, String date) {
		Map<String, String> container = new HashMap<String, String>();
		List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		
		Business business = repository.selectBusiness(businessWith);
		int businessNo = business.getBusinessNo();
		

		String businessNumber = businessNo +"";
		container.put("businessNumber", businessNumber);
		container.put("date", date);
		items = repository.selectAllitems(container);

		return items; 
	}
	
	@ResponseBody
	@RequestMapping(value="/sendManagerBw", method=RequestMethod.GET) 
	public Map<String,Object> sendManagerBw(String businessWith, String locationMain, HttpSession session) {
		Map<String,Object> container = new HashMap<String,Object>();
		Map<String,String> factors = new HashMap<String,String>();
		List<Map<String,Object>> schedules = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> schedules2 = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> locationItems = new ArrayList<Map<String,Object>>();
		List<String> dates = new ArrayList<String>();
		Map<String,String> factors2 = new HashMap<String,String>();
		Map<String,String> factors3 = new HashMap<String,String>();
		String days = "";
		String companyNo = (String)session.getAttribute("companyNo");
		String days2 = "";

		
		Business business = repository.selectBusiness(businessWith);
		int businessNo = business.getBusinessNo();
		schedules = repository.selectAllitems2(businessNo);
		schedules2 = repository.selectAllitems3(businessNo);
		dates = repository.selectScheduleDays(businessNo);
		factors.put("companyNo", companyNo);
		factors.put("location", locationMain);
		locationItems =  repository.selectLocationItems(factors);
		
		factors2.put("companyNo", companyNo);
		factors2.put("location", locationMain);
		days = repository.selectDays(factors2);
		
		factors3.put("companyNo", companyNo);
		factors3.put("location", locationMain);
		factors3.put("businessWith", businessWith);
		days2 = repository.selectDays2(factors3);

		container.put("schedules", schedules);
		container.put("dates", dates);
		container.put("schedules2", schedules2);
		container.put("locationItems", locationItems);
		container.put("days", days);
		container.put("days2", days2);
		
		return container; 
	}
	
	@ResponseBody
	@RequestMapping(value="/sendManagerSc", method=RequestMethod.GET) 
	public List<Map<String, Object>> sendManagerSc(String businessWith, String date) {
		Map<String, String> container = new HashMap<String, String>();
		List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		
		Business business = repository.selectBusiness(businessWith);
		int businessNo = business.getBusinessNo();
		

		String businessNumber = businessNo +"";
		container.put("businessNumber", businessNumber);
		container.put("date", date);
		items = repository.selectAllitems(container);

		return items; 
	}
	
	@ResponseBody
	@RequestMapping(value="/bringCompanyItems", method=RequestMethod.GET) 
	public List<Map<String, Object>> bringCompanyItems(String companyNo) {
		List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		items = repository.selectCompanyItems(companyNo);
		
		return items; 
	}
	
	@ResponseBody
	@RequestMapping(value="/sendLocation", method=RequestMethod.GET) 
	public List<Map<String, Object>> sendLocation(String location, HttpSession session) {
		String companyNo = (String)session.getAttribute("companyNo");
		List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		Map<String,String> factors = new HashMap<String, String>();
		
		factors.put("companyNo", companyNo);
		factors.put("location", location);
		items = repository.selectLocationItems(factors);
		return items; 
	}
	
	@ResponseBody
	@RequestMapping(value="/sendCategory", method=RequestMethod.GET) 
	public List<Map<String, Object>> sendCategory(String category, HttpSession session) {
		String companyNo = (String)session.getAttribute("companyNo");
		List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		Map<String,String> factors = new HashMap<String, String>();
		
		factors.put("companyNo", companyNo);
		factors.put("category", category);
		items = repository.selectCategory(factors);
		
		return items; 
	}
	
	@ResponseBody
	@RequestMapping(value="/getYear", method=RequestMethod.GET) 
	public List<String> getYear(HttpSession session) {
		List<String> years = new ArrayList<>();
		String companyNo = (String)session.getAttribute("companyNo");
		years = repository.selectYear(companyNo);
		
		return years; 
	}
	
	@ResponseBody
	@RequestMapping(value="/getYearData", method=RequestMethod.GET) 
	public List<Map<String, Object>> getYearData(HttpSession session, String yearData) {
		List<Map<String, Object>> yearDatas = new ArrayList<>();
		Map<String, String> factor = new HashMap<String, String>();
		String companyNo = (String)session.getAttribute("companyNo");
		factor.put("companyNo", companyNo);
		String yearDataC = yearData.substring(2);
		factor.put("year", yearDataC);
		yearDatas = repository.selectYearData(factor);
		
		return yearDatas; 
	}
}
