package global.sesoc.team.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import global.sesoc.team.vo.Business;
import global.sesoc.team.vo.Employee;
import global.sesoc.team.vo.Schedule;

public interface EmployeeMapper {
	public Employee login(Employee employee);
	public Employee selectOne(Employee employee);
	public ArrayList<Employee> selectEmpAll(int companyno);
	public int insertEmployee(Employee employee);
	public int updateEmployee(Employee employee);
	public List<Map<String, Object>> selectAllTrip(String empid);
	public List<Employee> searchName(Map<String,String> map);
	public Business selectBusiness(String businessWith);
	public List<Schedule> selectSchedules(int businessNo);
	public List<String> selectScheduleDays(int businessNo);
	public List<Map<String, Object>> selectAllitems(Map<String,String> container);
	public List<Map<String, Object>> selectAllitems2(int businessNo);
	public List<Map<String, Object>> selectAllitems3(int businessNo);
	public List<Map<String, Object>> selectCompanyItems(String companyNo);
	public List<Map<String, Object>> selectLocationItems(Map<String,String> map);
	public List<Object> selectLocation(String companyNo);
	public List<Map<String, Object>> selectCategory(Map<String,String> map);
	public List<Map<String, Object>> selectAllCategory(String companyNo);
	public String selectDays(Map<String,String> map);
	public String selectDays2(Map<String,String> map);
	public List<Employee> selectCompanyCoworker(Map<String, String> map);
	public List<String> selectYear(String companyNo);
	public List<Map<String, Object>> selectYearData(Map<String,String> map);
}
