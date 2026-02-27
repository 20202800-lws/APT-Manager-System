package com.apt.membermanager.beans;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.apt.membermanager.entity.Complaint;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class ComplaintListBean {

	
	private Long compId;         
	private String category;     
	private String title;        
	private String content;      
	private String compStatus;   
	private String reply;
	
	private String userName;     
    private String userId;       
    private String regDate;      
    
    
    public static ComplaintListBean fromEntity(Complaint complaint) {
    	String authorName = (complaint.getUser() != null) ? complaint.getUser().getRealName() : "알 수 없음";
        String authorId = (complaint.getUser() != null) ? complaint.getUser().getUserId() : "unknown";
    	return ComplaintListBean.builder()
    			.compId(complaint.getCompId())
                .category(complaint.getCategory())
                .title(complaint.getTitle())
                .content(complaint.getContent()) // 추가: 상세 보기용
                .compStatus(complaint.getCompStatus())
                .reply(complaint.getReply())     // 추가: 답변 확인용
                .userName(authorName)            // 수정: 실명을 이름 필드에
                .userId(authorId)                // 추가: ID를 ID 필드에
                .regDate(formatReceiptDate(complaint.getRegDate())) 
                .build();
    }
    
    private static String formatReceiptDate(LocalDateTime dateTime) {
        if (dateTime == null) return "-";
        LocalDateTime now = LocalDateTime.now();
        
        if (dateTime.toLocalDate().equals(now.toLocalDate())) {
            return dateTime.format(DateTimeFormatter.ofPattern("HH:mm"));
        } else {
            return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
    }
}
