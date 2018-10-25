package global.sesoc.team.vo;

public class Receipt {
	private int scheduleNo;
	private int receiptNo;
	private String recipeDay;
	private String recipePlace;
	private String recipePay;
	private String recipeMemo;
	
	public Receipt() {
		super();
	}
	
	public Receipt(int scheduleNo, int receiptNo, String recipeDay, String recipePlace, String recipePay,
			String recipeMemo) {
		super();
		this.scheduleNo = scheduleNo;
		this.receiptNo = receiptNo;
		this.recipeDay = recipeDay;
		this.recipePlace = recipePlace;
		this.recipePay = recipePay;
		this.recipeMemo = recipeMemo;
	}
	
	public int getScheduleNo() {
		return scheduleNo;
	}
	public void setScheduleNo(int scheduleNo) {
		this.scheduleNo = scheduleNo;
	}
	public int getReceiptNo() {
		return receiptNo;
	}
	public void setReceiptNo(int receiptNo) {
		this.receiptNo = receiptNo;
	}
	public String getRecipeDay() {
		return recipeDay;
	}
	public void setRecipeDay(String recipeDay) {
		this.recipeDay = recipeDay;
	}
	public String getRecipePlace() {
		return recipePlace;
	}
	public void setRecipePlace(String recipePlace) {
		this.recipePlace = recipePlace;
	}
	public String getRecipePay() {
		return recipePay;
	}
	public void setRecipePay(String recipePay) {
		this.recipePay = recipePay;
	}
	public String getRecipeMemo() {
		return recipeMemo;
	}
	public void setRecipeMemo(String recipeMemo) {
		this.recipeMemo = recipeMemo;
	}
	
	@Override
	public String toString() {
		return "Receipt [scheduleNo=" + scheduleNo + ", receiptNo=" + receiptNo + ", recipeDay=" + recipeDay
				+ ", recipePlace=" + recipePlace + ", recipePay=" + recipePay + ", recipeMemo=" + recipeMemo + "]";
	}
}
