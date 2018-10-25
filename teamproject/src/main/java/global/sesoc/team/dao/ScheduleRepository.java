package global.sesoc.team.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import global.sesoc.team.vo.Schedule;

@Repository
public class ScheduleRepository {
	@Autowired
	SqlSession session;
	public int insert(Schedule schedule) {
		
		return 0;
		
	}
	public List<Schedule> selectAll(){
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Schedule>list = mapper.selectAll();
		return list;
			
	}
	public int deleteSchedule(int scheduleNo) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int result = mapper.deleteSchedule(scheduleNo); 
		return result;
	}
	public int selectSeq() {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int result = mapper.selectSeq();
		return result;
	}
	public int insertPlan(Schedule schedule) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int result = mapper.insertPlan(schedule);
		
		return result;
		
	}
	public List<Integer> selectbusinessNoList(String selectDate) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Integer> list = mapper.selectbusinessNoList(selectDate);
		return list;
	}
	public int selectBusinessWith(Map<String, String> map) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int businessWith = mapper.selectBusinessWith(map);
		return businessWith;
	}
	public List<Integer> selectBusinessNos(int businessWith) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Integer> list = mapper.selectBusinessNos(businessWith);
		return list;
	}
	public List<Schedule> selectMySchedule(String empId) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Schedule> list = mapper.selectMySchedule(empId);

		return list;
	}
	public Schedule init(String scheduleDay) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		Schedule s1 = mapper.init(scheduleDay);
		return s1;
	}
	public Schedule selectScheduleOne(int scheduleNo) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		Schedule s1 = mapper.selectScheduleOne(scheduleNo);
		return s1;
	}
	public int updateSchedule(Schedule schedule) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int result = mapper.updateSchedule(schedule);
		return result;
	}
	public int selectBusinessNo(Map<String,String> map) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int businessNo = mapper.selectBusinessNo(map);
		return businessNo;
	}
	public List<Integer> selectBusinessWithNo(String empId) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Integer> rlist = mapper.selectBusinessWithNo(empId);
		return rlist;
	}
	
	public int selectBusinessNoRepresenter(int businessWith) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int r = mapper.selectBusinessNoRepresenter(businessWith);
		return r;
	}
	
	public List<Schedule> selectRepresentSchedule(int businessNo) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		List<Schedule> sList = mapper.selectRepresentSchedule(businessNo);
		return sList;
	}
	public int selectScheduleNo() {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int result  = mapper.selectScheduleNo();
		
		return result;
	}
	public String updateCheck(int scheduleNo) {
		
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		String empId = mapper.updateCheck(scheduleNo);
		
		return empId;
	}
	public int checkScheduleNo(Map<String, String> map) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		int scheduleNo = mapper.checkScheduleNo(map);
		return scheduleNo;
	}
	
	public String checkRepresenter(int no) {
		ScheduleMapper mapper = session.getMapper(ScheduleMapper.class);
		String empId = mapper.checkRepresenter(no);
		return empId;
	}
	
}
