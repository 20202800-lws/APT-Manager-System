package com.apt.membermanager.beans;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.apt.membermanager.entity.User;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class MemberBean {
	
	private String userId;
    private String userPw;
    private String userName;
    private String email;
    private String phone;
    private String dong;
    private String ho;
    private String birthdate;
    private String genderDigit;
    private String userRole;
    private boolean approvalStatus;
    private boolean parentRoleApply;
    private String status; // ADM, ACT, WAIT, WDR
    private String joinDate;
    private String withdrawalDate;
    
	public MemberBean(String userId, String userPw, String userName, String email, String phone, String dong,
			String ho, String birthdate, String genderDigit, String userRole, boolean approvalStatus, 
            boolean parentRoleApply, LocalDateTime join_date, LocalDateTime withdrawal_date) {
		super();
		this.userId = userId;
		this.userPw = userPw;
		this.userName = userName;
		this.email = email;
		this.phone = phone;
		this.dong = dong;
		this.ho = ho;
		this.birthdate = birthdate;
		this.genderDigit = genderDigit;
		this.userRole = userRole;
		this.approvalStatus = approvalStatus;
        this.parentRoleApply = parentRoleApply;
		
        // ★ [로직 수정] 탈퇴일이 존재하면 최우선으로 '탈퇴(WDR)' 상태 부여
		if (withdrawal_date != null) {
            this.status = "WDR";
        } else if ("ADMIN".equals(userRole)) {
	        this.status = "ADM";
	    } else if (this.approvalStatus) {
	        this.status = "ACT";
	    } else {
	        this.status = "WAIT";
	    }
		
		this.joinDate = (join_date != null) ? join_date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")): null;
		this.withdrawalDate = (withdrawal_date != null) ? withdrawal_date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")): null;
	}
    
	public static MemberBean fromMember(User user) {
    	return new MemberBean(user.getUsername(), user.getPassword(), user.getRealName(), user.getEmail(),
    			user.getPhone(), user.getDong(), user.getHo(), user.getBirthDate(),
    			user.getGenderDigit(), user.getUserRole(), user.isApprovalStatus(), 
                user.isParentRoleApply(), 
                user.getJoinDate(), user.getWithdrawalDate());
    }
}