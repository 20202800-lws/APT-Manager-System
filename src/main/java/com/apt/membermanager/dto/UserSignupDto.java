package com.apt.membermanager.dto;

import com.apt.membermanager.entity.User;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

@Getter @Setter
@ToString
@NoArgsConstructor
public class UserSignupDto {

    private String userId;
    private String userPw;
    private String userName;
    private String dong;
    private String ho;
    private String phone;
    private String email;
    private String birthDate;
    private String genderDigit;

    // ★ DTO -> Entity 변환 (여기가 핵심!)
    public User toEntity() {
        User user = new User();
        user.setUserId(this.userId);
        user.setUserPw(this.userPw); 
        user.setUserName(this.userName);
        user.setDong(this.dong);
        user.setHo(this.ho);
        user.setPhone(this.phone);
        user.setEmail(this.email);
        user.setBirthDate(this.birthDate);
        user.setGenderDigit(this.genderDigit);
        
        // [수정됨] int(0) -> Boolean(false)
        // 가입 초기엔 "승인 안 됨(false)" 상태로 설정
        user.setApprovalStatus(false); 
        
        user.setUserRole("USER"); 
        
        return user;
    }
}