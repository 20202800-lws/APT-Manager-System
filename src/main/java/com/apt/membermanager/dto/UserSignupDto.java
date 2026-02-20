package com.apt.membermanager.dto;

import com.apt.membermanager.entity.User;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class UserSignupDto {

	@NotBlank(message = "아이디를 입력하세요")
	@Size(min = 6, message = "아이디는 6자리 이상 입력하세요")
	@Pattern(regexp = "^[a-zA-Z0-9]*$")
	private String userId;

	@NotBlank(message = "비밀번호를 입력하세요")
	@Size(min = 8, message = "비밀번호는 8자리 이상으로 입력하세요")
	@Pattern(regexp = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]+$", message = "비밀번호는 영문, 숫자, 특수기호를 모두 포함해야 합니다.")
	private String userPw;

	@NotBlank(message = "비밀번호가 일치하지 않습니다.")
	private String userPwCheck;

	@NotBlank(message = "이름을 입력하세요")
	private String userName;

	@NotBlank(message = "동을 입력하세요")
	private String dong;

	@NotBlank(message = "호수를 입력하세요")
	private String ho;

	@NotBlank(message = "전화번호를 입력하세요")
	@Pattern(regexp = "^01[016789]-\\d{3,4}-\\d{4}$", message = "올바른 전화번호 형식이 아닙니다.")
	private String phone;

	@NotBlank(message = "이메일 주소를 입력하세요")
	@Email(message = "올바른 주소를 입력하세요")
	private String email;

	@NotBlank(message = "생년월일을 입력하세요")
	private String birthDate;

	@NotBlank(message = "주민번호 뒷자리 첫번째 번호를 입력하세요")
	@Pattern(regexp = "^[1-4]$")
	private String genderDigit;

	// ★ DTO -> Entity 변환 (여기가 핵심!)
	public User toEntity(String encodePw) {

		return User.builder().userId(this.userId).userPw(encodePw).userName(this.userName).birthDate(this.birthDate)
				.genderDigit(this.genderDigit).email(this.email).phone(this.phone).dong(this.dong).ho(this.ho)
				// [수정됨] int(0) -> Boolean(false)
				// 가입 초기엔 "승인 안 됨(false)" 상태로 설정
				.approvalStatus(false).userRole("USER").build();
	}
}