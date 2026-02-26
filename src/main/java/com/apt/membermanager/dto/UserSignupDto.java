package com.apt.membermanager.dto;

import com.apt.membermanager.entity.User;

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
	@Pattern(regexp = "^[a-zA-Z0-9]*$", message = "아이디는 영문과 숫자만 사용할 수 있습니다.")
	private String userId;

	@NotBlank(message = "비밀번호를 입력하세요")
	// ★ 비밀번호 정규식 강화 (영문, 숫자, 특수문자 포함 8자 이상)
	@Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&~^])[A-Za-z\\d@$!%*#?&~^]{8,}$", message = "비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.")
	private String userPw;

	@NotBlank(message = "비밀번호 확인을 입력하세요")
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

	// ★ 이메일 선택 입력 처리 (빈칸(^$) 허용 또는 정확한 이메일 형식)
	@Pattern(regexp = "^$|^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.(com|net|org|kr|co\\.kr|go\\.kr|ac\\.kr)$", message = "유효하지 않은 이메일 형식입니다. (예: example@naver.com)")
	private String email;

	@NotBlank(message = "생년월일을 입력하세요")
	@Size(min = 6, max = 6, message = "생년월일은 6자리로 입력하세요 (예: 990101)")
	private String birthDate;

	@NotBlank(message = "주민번호 뒷자리 첫번째 번호를 입력하세요")
	@Pattern(regexp = "^[1-4]$", message = "성별 코드는 1~4 사이의 숫자여야 합니다.")
	private String genderDigit;

	// ★ DTO -> Entity 변환
	public User toEntity(String encodePw) {
		return User.builder()
				.userId(this.userId)
				.userPw(encodePw)
				.userName(this.userName)
				.birthDate(this.birthDate)
				.genderDigit(this.genderDigit)
				.email(this.email)
				.phone(this.phone)
				.dong(this.dong)
				.ho(this.ho)
				// 가입 초기엔 "승인 안 됨(false)" 상태로 설정
				.approvalStatus(false)
				.userRole("USER")
				.build();
	}
}