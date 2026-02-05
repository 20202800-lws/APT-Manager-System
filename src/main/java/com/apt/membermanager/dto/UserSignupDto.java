package com.apt.membermanager.dto;

import com.apt.membermanager.entity.User;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class UserSignupDto {
    private String userId;
    private String userPw;
    private String userName;
    private String dong;
    private String ho;
    private String phone;
    private String email;
    private String birthDate; // 생년월일
    private String genderDigit; // 주민번호 뒷자리 첫글자

    // DTO -> Entity 변환 메서드 (서비스에서 씀)
    public User toEntity() {
        User user = new User();
        user.setUserId(this.userId);
        user.setUserPw(this.userPw); // 나중에 암호화 필요
        user.setUserName(this.userName);
        user.setDong(this.dong);
        user.setHo(this.ho);
        user.setPhone(this.phone);
        user.setEmail(this.email);
        user.setBirthDate(this.birthDate);
        user.setGenderDigit(this.genderDigit);
        user.setIsApproved("N"); // 초기엔 미승인 상태
        return user;
    }
}