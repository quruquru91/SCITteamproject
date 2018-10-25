package global.sesoc.team.vo;

public class Business {
	private String empId;
	private int businessNo;
	private String businessName;
	private int businessWith;
	private String businessColor;
	private String businessStart;
	private String businessEnd;
	private String businessLocationMain;
	private String businessLocationSub;
	private String businessMemo;
	private String businessRepresent;
	public Business() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Business(String empId, int businessNo, String businessName, int businessWith, String businessColor,
			String businessStart, String businessEnd, String businessLocationMain, String businessLocationSub,
			String businessMemo, String businessRepresent) {
		super();
		this.empId = empId;
		this.businessNo = businessNo;
		this.businessName = businessName;
		this.businessWith = businessWith;
		this.businessColor = businessColor;
		this.businessStart = businessStart;
		this.businessEnd = businessEnd;
		this.businessLocationMain = businessLocationMain;
		this.businessLocationSub = businessLocationSub;
		this.businessMemo = businessMemo;
		this.businessRepresent = businessRepresent;
	}
	public String getEmpId() {
		return empId;
	}
	public void setEmpId(String empId) {
		this.empId = empId;
	}
	public int getBusinessNo() {
		return businessNo;
	}
	public void setBusinessNo(int businessNo) {
		this.businessNo = businessNo;
	}
	public String getBusinessName() {
		return businessName;
	}
	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}
	public int getBusinessWith() {
		return businessWith;
	}
	public void setBusinessWith(int businessWith) {
		this.businessWith = businessWith;
	}
	public String getBusinessColor() {
		return businessColor;
	}
	public void setBusinessColor(String businessColor) {
		this.businessColor = businessColor;
	}
	public String getBusinessStart() {
		return businessStart;
	}
	public void setBusinessStart(String businessStart) {
		this.businessStart = businessStart;
	}
	public String getBusinessEnd() {
		return businessEnd;
	}
	public void setBusinessEnd(String businessEnd) {
		this.businessEnd = businessEnd;
	}
	public String getBusinessLocationMain() {
		return businessLocationMain;
	}
	public void setBusinessLocationMain(String businessLocationMain) {
		this.businessLocationMain = businessLocationMain;
	}
	public String getBusinessLocationSub() {
		return businessLocationSub;
	}
	public void setBusinessLocationSub(String businessLocationSub) {
		this.businessLocationSub = businessLocationSub;
	}
	public String getBusinessMemo() {
		return businessMemo;
	}
	public void setBusinessMemo(String businessMemo) {
		this.businessMemo = businessMemo;
	}
	public String getBusinessRepresent() {
		return businessRepresent;
	}
	public void setBusinessRepresent(String businessRepresent) {
		this.businessRepresent = businessRepresent;
	}
	@Override
	public String toString() {
		return "Business [empId=" + empId + ", businessNo=" + businessNo + ", businessName=" + businessName
				+ ", businessWith=" + businessWith + ", businessColor=" + businessColor + ", businessStart="
				+ businessStart + ", businessEnd=" + businessEnd + ", businessLocationMain=" + businessLocationMain
				+ ", businessLocationSub=" + businessLocationSub + ", businessMemo=" + businessMemo
				+ ", businessRepresent=" + businessRepresent + "]";
	}
	
	
}
