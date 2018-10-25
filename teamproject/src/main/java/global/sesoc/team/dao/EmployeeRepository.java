package global.sesoc.team.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import global.sesoc.team.vo.Business;
import global.sesoc.team.vo.Employee;
import global.sesoc.team.vo.Schedule;

@Repository
public class EmployeeRepository {
	@Autowired
	SqlSession session;
	
	public Employee login(Employee employee) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		Employee emp = mapper.login(employee);
		
		return emp;
	}

	public Employee selectOne(Employee employee) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		Employee emp = mapper.login(employee);
		
		return emp;
	}
	
	public ArrayList<Employee> selectEmpAll(int companyno) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		ArrayList<Employee> employees = mapper.selectEmpAll(companyno);
		
		return employees;
	}

	public int insertEmployee(Employee employee) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		int result = mapper.insertEmployee(employee);
	
		return result;
	}
	
	public int updateEmployee(Employee employee) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		int result = mapper.updateEmployee(employee);
	
		return result;
		
	}
	
	public List<Map<String, Object>> selectAllTrip(String empid) {
		
		List<Map<String, Object>> businessTrips = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		businessTrips = mapper.selectAllTrip(empid);
		return businessTrips;
	}
	
	public List<Employee> searchName(Map<String,String>map) {
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		List<Employee> list = mapper.searchName(map);
		return list;
	}
	
	public Business selectBusiness(String businessWith) {
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		Business business = mapper.selectBusiness(businessWith);
		return business;
	}
	
	public List<Schedule> selectSchedules(int businessNo) {
		List<Schedule> schedules = new ArrayList<Schedule>();
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		schedules = mapper.selectSchedules(businessNo);
		return schedules;
	}
	
	public List<String> selectScheduleDays(int businessNo) {
		List<String> scheduleDays = new ArrayList<String>();
		
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		scheduleDays = mapper.selectScheduleDays(businessNo);
		return scheduleDays;
	}
	
	public List<Map<String, Object>> selectAllitems(Map<String,String> container) {
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		items = mapper.selectAllitems(container);
		return items;
	}
	
	public List<Map<String, Object>> selectAllitems2(int businessNo) {
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		items = mapper.selectAllitems2(businessNo);
		return items;
	}
	
	public List<Map<String, Object>> selectAllitems3(int businessNo) {
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		items = mapper.selectAllitems3(businessNo);
		return items;
	}
	
	public List<Map<String, Object>> selectCompanyItems(String companyNo) {
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		items = mapper.selectCompanyItems(companyNo);
		return items;
	}
	
	public List<Map<String, Object>> selectLocationItems(Map<String,String> map) {
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		items = mapper.selectLocationItems(map);
		return items;
	}
	
	public List<Object> selectLocation(String companyNo) {
		List<Object> dates = new ArrayList<Object>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		dates = mapper.selectLocation(companyNo);
		return dates;
	}
	
	public List<Map<String, Object>> selectCategory(Map<String,String> map) {
		List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		categories = mapper.selectCategory(map);
		return categories;
	}
	
	public List<Map<String, Object>> selectAllCategory(String companyNo) {
		List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		categories = mapper.selectAllCategory(companyNo);
		return categories;
	}
	
	public String selectDays(Map<String,String> map) {
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		String days = mapper.selectDays(map);
		return days;
	}
	
	public String selectDays2(Map<String,String> map) {
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		String days = mapper.selectDays2(map);
		return days;
	}
	
	public List<Employee> selectCompanyCoworker(Map<String, String> map) {
		// TODO Auto-generated method stub
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		List<Employee>list = mapper.selectCompanyCoworker(map);
		return list;
	}
	
	public List<String> selectYear(String companyNo) {
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		List<String> year = mapper.selectYear(companyNo);
		return year;
	}
	
	public List<Map<String, Object>> selectYearData(Map<String,String> map) {
		List<Map<String, Object>> yearData = new ArrayList<Map<String, Object>>();
		EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
		yearData = mapper.selectYearData(map);
		return yearData;
	}
}
