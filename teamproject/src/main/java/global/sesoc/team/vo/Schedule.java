package global.sesoc.team.vo;

public class Schedule {

	private int businessNo;
	private int scheduleNo;
	private String scheduleTitle;
	private String scheduleDay;
	private String scheduleContext;
	private String schedulePlace;

	public Schedule() {
	}

	public Schedule(int businessNo, int scheduleNo, String scheduleTitle, String scheduleDay, String scheduleContext,
			String schedulePlace) {
		super();
		this.businessNo = businessNo;
		this.scheduleNo = scheduleNo;
		this.scheduleTitle = scheduleTitle;
		this.scheduleDay = scheduleDay;
		this.scheduleContext = scheduleContext;
		this.schedulePlace = schedulePlace;
	}

	public int getBusinessNo() {
		return businessNo;
	}

	public void setBusinessNo(int businessNo) {
		this.businessNo = businessNo;
	}

	public int getScheduleNo() {
		return scheduleNo;
	}

	public void setScheduleNo(int scheduleNo) {
		this.scheduleNo = scheduleNo;
	}

	public String getScheduleTitle() {
		return scheduleTitle;
	}

	public void setScheduleTitle(String scheduleTitle) {
		this.scheduleTitle = scheduleTitle;
	}

	public String getScheduleDay() {
		return scheduleDay;
	}

	public void setScheduleDay(String scheduleDay) {
		this.scheduleDay = scheduleDay;
	}

	public String getScheduleContext() {
		return scheduleContext;
	}

	public void setScheduleContext(String scheduleContext) {
		this.scheduleContext = scheduleContext;
	}

	public String getSchedulePlace() {
		return schedulePlace;
	}

	public void setSchedulePlace(String schedulePlace) {
		this.schedulePlace = schedulePlace;
	}

	@Override
	public String toString() {
		return "Schedule [businessNo=" + businessNo + ", scheduleNo=" + scheduleNo + ", scheduleTitle=" + scheduleTitle
				+ ", scheduleDay=" + scheduleDay + ", scheduleContext=" + scheduleContext + ", schedulePlace="
				+ schedulePlace + "]";
	}

}
