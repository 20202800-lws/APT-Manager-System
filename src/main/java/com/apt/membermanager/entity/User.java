package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Builder
@Entity
@Table(name = "USERS")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails{

    @Id
    @Column(name = "user_id", length = 50)
    private String userId;

    @Column(name = "user_pw", nullable = false)
    private String userPw;

    @Column(name = "user_name", nullable = false)
    private String userName;

    @Column(name = "dong")
    private String dong;

    @Column(name = "ho")
    private String ho;

    @Column(name = "user_role")
    private String userRole; 

    @Column(name = "phone")
    private String phone;

    @Column(name = "email")
    private String email;
    
    @Column(name = "birth_date")
    private String birthDate;

    @Column(name = "gender_digit", length = 1)
    private String genderDigit;
    
    @Column(name = "profile_img")
    private String profileImg;

    //시큐리티는 이 메소드로 비밀번호를 가져감
    @Override
    public String getPassword() {
    	return this.userPw;
    }
    
    //시큐리티는 이 메소드로 아이디를 가져감 
    @Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return this.userId;
	}
    
    // ★ [추가됨] 프론트엔드(JSP)에서 실제 이름을 가져올 때, 
    // 시큐리티의 getUsername()과 톰캣이 헷갈리지 않도록 명확한 통로를 제공
    public String getRealName() {
        return this.userName;
    }
    
    // ★ [수정됨] int -> Boolean
    // DB의 TINYINT(1)을 자바의 Boolean(true/false)으로 자동 변환해줍니다.
    @Column(name = "approval_status")
    @ColumnDefault("false") // DB 기본값 설정 (선택사항)
    private boolean approvalStatus; 

    @CreationTimestamp
    @Column(name = "join_date", updatable = false)
    private LocalDateTime joinDate;

    @Column(name = "withdrawal_date")
    private LocalDateTime withdrawalDate;
    
    @Override
	public boolean isAccountNonExpired() { return true; }

	@Override
	public boolean isAccountNonLocked() { return true; }

	@Override
	public boolean isCredentialsNonExpired() { return true; }

	@Override
	public boolean isEnabled() { return true; }
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return List.of(new SimpleGrantedAuthority("ROLE_" + this.userRole));
	}

	
}