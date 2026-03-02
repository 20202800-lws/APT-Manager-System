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
public class User implements UserDetails {

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

    @Override
    public String getPassword() { return this.userPw; }
    
    @Override
    public String getUsername() { return this.userId; }
    
    public String getRealName() { return this.userName; }
    
    @Column(name = "approval_status")
    @ColumnDefault("false")
    private boolean approvalStatus; 
    
    // ★ 학부모 권한 신청 여부 필드 추가
    @Column(name = "parent_role_apply")
    @ColumnDefault("false")
    private boolean parentRoleApply; 

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
        return List.of(new SimpleGrantedAuthority("ROLE_" + this.userRole));
    }

    public void updateRole(String userRole, boolean approvalStatus) {
        this.userRole = userRole;
        this.approvalStatus = approvalStatus;
    }
}