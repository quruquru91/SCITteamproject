package global.sesoc.team.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import global.sesoc.team.vo.Business;
import global.sesoc.team.vo.Item;
import global.sesoc.team.vo.Receipt;

@Repository
public class BusinessRepository {

	@Autowired
	SqlSession session;
	BusinessRepository repository;

	public List<Business> selectAll() {
		return null;

	}

	public int insertBusiness(Business business) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int result = mapper.insertBusiness(business);
		return result;
	}

	public List<Business> businessMy(String empId) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		List<Business> Blist = mapper.businessMy(empId);
		return Blist;
	}

	public int selectBusineeWith() {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int businessWith = mapper.selectBusinessWith();

		return businessWith;

	}

	public int deleteBusinessNo(Map<String, String> map) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int result = mapper.deleteBusinessNo(map);
		return result;
	}

	public String checkRepresent(String businessWith) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		String empId = mapper.checkRepresent(businessWith);
		return empId;
	}

	public int checkBusiness(Map<String, String> map) {

		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int businessNo = mapper.checkBusiness(map);

		return businessNo;

	}

	public String selectRepersenter(Map<String, String> map) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		String representer = mapper.selectRepersenter(map);
		return representer;
	}

	public Integer alreadyBusiness(Map<String, String> map) {

		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		Integer result = mapper.alreadyBusiness(map);
		if (result == null) {
			return 0;
		} else {
			return result;
		}
	}

	public int selectBusinessDelete(Map<String, String> map) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int businessNo = mapper.selectBusinessDelete(map);

		return businessNo;
	}

	public List<Integer> selectScheduleDelete(Map<String,String>map) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		List<Integer> list = mapper.selectScheduleDelete(map);
		return list;
	}

	public int insertReceipt(Receipt receipt) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int result = mapper.insertReceipt(receipt);
		return result;
	}

	public int selectReceiptNo() {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int result = mapper.selectReceiptNo();
		return result;
	}

	public int insertItem(Item item) {
		BusinessMapper mapper = session.getMapper(BusinessMapper.class);
		int result = mapper.insertItem(item);
		return result;
	}

}
