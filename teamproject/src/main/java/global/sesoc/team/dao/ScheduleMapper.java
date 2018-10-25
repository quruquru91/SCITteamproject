package global.sesoc.team.dao;

import java.util.List;
import java.util.Map;

import global.sesoc.team.vo.Schedule;


public interface ScheduleMapper {

	public int insert(Schedule schedule);
	public List<Schedule> selectAll();
	public int deleteSchedule(int scheduleNo);
	public int selectSeq();
	public int insertPlan(Schedule schedule);
	public List<Integer> selectbusinessNoList(String selectDate);
	public Integer selectBusinessWith(Map<String, String> map);
	public List<Integer> selectBusinessNos(int businessWith);
	public List<Schedule> selectMySchedule(String empId);
	public Schedule init(String scheduleDay);
	public Schedule selectScheduleOne(int scheduleNo);
	public int updateSchedule(Schedule schedule);
	public int selectBusinessNo(Map<String,String>map);
	public List<Integer> selectBusinessWithNo(String empId);
	public int selectBusinessNoRepresenter(int businessWith);
	public List<Schedule> selectRepresentSchedule(int businessNo);
	public int selectScheduleNo();
	public String updateCheck(int Eventid);
	public int checkScheduleNo(Map<String, String> map);
	public String checkRepresenter(int no);
}
