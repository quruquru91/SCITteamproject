package global.sesoc.team.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import global.sesoc.team.dao.ScheduleRepository;
import global.sesoc.team.vo.Schedule;

@Controller
public class ScheduleController {
	@Autowired
	ScheduleRepository repository;
	@Autowired
	SqlSession session;

	
	
/*	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String planDate() {
		return "planCheck";
	}*/
	@ResponseBody
	@RequestMapping(value = "/selectMySchedule", method = RequestMethod.GET)
	public List<Schedule> selectMySchedule(HttpSession session) {

		List<Schedule> totalList = new ArrayList<Schedule>();
		List<Integer> businessNoList = new ArrayList<Integer>();
		List<Schedule> scheduleList = new ArrayList<Schedule>();

		String empId = (String) session.getAttribute("loginId");

		List<Integer> businessWithList = repository.selectBusinessWithNo(empId);

		for (int i = 0; i < businessWithList.size(); i++) {

			businessNoList.add(repository.selectBusinessNoRepresenter(businessWithList.get(i)));
		}

		for (int j = 0; j < businessNoList.size(); j++) {
			int temp = businessNoList.get(j);
			scheduleList = repository.selectRepresentSchedule(temp);

			for (int k = 0; k < scheduleList.size(); k++) {
				totalList.add(scheduleList.get(k));
			}
		}

		return totalList;

	}

	
	@RequestMapping(value = "/Date", method = RequestMethod.POST)
	public void date(String startDate, String endDate) {
	}
	
	@RequestMapping(value = "/addPlan", method = RequestMethod.GET)
	public String addPlan(String selectDate,String businessWith,Model model) {
		model.addAttribute("selectDate",selectDate);
		model.addAttribute("businessWith",businessWith);
		return "calendar/addPlan";
	}
	

	

	
	@ResponseBody
	@RequestMapping(value = "/selectDate", method = RequestMethod.POST)
	public String selectDate(@RequestBody String startDate , String endDate) {

		return "";
	}
	
	@RequestMapping(value="/addBusiness" , method=RequestMethod.GET)
	public String addBusiness(String startDate , String endDate, Model model) {
		model.addAttribute("startDate",startDate);
		model.addAttribute("endDate",endDate);
		return "calendar/addBusiness";
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteSchedule", method = RequestMethod.GET)
	public boolean deleteSchedule(String scheduleNo, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		int scheduleNo1 = Integer.parseInt(scheduleNo);
		String emp = repository.updateCheck(scheduleNo1);
		if (loginId.equals(emp)) {
			repository.deleteSchedule(scheduleNo1);
			return true;
		} 
			return false;
	}
/*	--------------------------------------------------------------*/	
	
	
	
	@ResponseBody
	@RequestMapping(value="selectbusinessWithNo" , method=RequestMethod.GET)
	public int selectbusinessWithNo(String selectDate,HttpSession session) {
		
		String selectDate1 = selectDate.replace("-", "/");
		String empId = (String)session.getAttribute("loginId");
		Map<String,String> map = new HashMap<String,String>();
		map.put("empId", empId);
		map.put("selectDate", selectDate1);
		int businessWith = repository.selectBusinessWith(map);
		
		return businessWith;
	}
	
	@ResponseBody
	@RequestMapping(value = "/selectBusinessNo", method = RequestMethod.GET)
	public int selectBusinessNo(HttpSession session, String businessWith) {
		String empId = (String) session.getAttribute("loginId");
		Map<String, String> map = new HashMap<String, String>();
		map.put("empId", empId);
		map.put("businessWith", businessWith);
		int businessNo = repository.selectBusinessNo(map);
		return businessNo;
	}

	
	@ResponseBody
	@RequestMapping(value = "/insertPlan", method = RequestMethod.POST)
	public Schedule insertPlan(@RequestBody Schedule schedule) {
		String No = schedule.getScheduleDay().replace("-", "/");
		schedule.setScheduleDay(No);
		repository.insertPlan(schedule);
		Schedule s1  = new Schedule();
		return s1;
	}
	
	@ResponseBody
	@RequestMapping(value = "/init", method = RequestMethod.GET)
	public Schedule init(String scheduleDay) {

		Schedule s1 = new Schedule();
		s1 = repository.init(scheduleDay);
		return s1;
	}

	@RequestMapping(value = "/checkSchedule", method = RequestMethod.GET)
	public String checkSchedule(int scheduleNo, Model model) {
		Schedule sch = repository.selectScheduleOne(scheduleNo);

		model.addAttribute("Schedule", sch);
		return "calendar/checkSchedule";
	}

	@ResponseBody
	@RequestMapping(value = "/updateSchedule", method = RequestMethod.POST)
	public String updateSchedule(@RequestBody Schedule schedule) {
		repository.updateSchedule(schedule);
		return "123";
	}

	@ResponseBody
	@RequestMapping(value = "/selectScheduleNo", method = RequestMethod.GET)
	public int selectScheduleNo() {
		int result = repository.selectScheduleNo();
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/updateCheck", method = RequestMethod.GET)
	public String updateCheck(int scheduleNo) {
		String empId = repository.updateCheck(scheduleNo);
		return empId;
	}

	@ResponseBody
	@RequestMapping(value = "/checkScheduleNo", method = RequestMethod.GET)
	public int checkScheduleNo(String selectDay, HttpSession session) {
		String empId = (String) session.getAttribute("loginId");
		Map<String, String> map = new HashMap<String, String>();
		String sd = selectDay.replace("-", "/");		map.put("empId", empId);
		map.put("scheduleDay", sd);
		int scheduleNo = repository.checkScheduleNo(map);
		return scheduleNo;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/checkRepresenter", method = RequestMethod.GET)
	public String checkRepresenter(String scheduleNo) {
		int No = Integer.parseInt(scheduleNo);
		String empId = repository.checkRepresenter(No);
		return empId;
	}
}
