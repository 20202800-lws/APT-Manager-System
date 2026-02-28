package com.apt.membermanager.beans;

import com.apt.membermanager.entity.FacilityRes;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResListBean {
    private Long resId;
    private String facId;      
    private String userId;
    private String userName;
    private String dongHo;     
    private String useTime;    
    private String resStatus;  

    public ResListBean(FacilityRes entity) {
        this.resId = entity.getResId();
        
        // ★ [추가됨] DB의 한글 시설명을 JS가 인식하는 영문 코드로 변환 (탭 필터링 버그 해결)
        String type = entity.getFacilityType();
        if (type != null) {
            if (type.contains("수영")) this.facId = "POOL";
            else if (type.contains("피트니스") || type.contains("헬스")) this.facId = "GYM";
            else if (type.contains("골프")) this.facId = "GOLF";
            else if (type.contains("게스트")) this.facId = "GUEST";
            else this.facId = type; // 혹시 모를 예외 상황엔 원본 그대로 유지
        }
        
        if (entity.getUser() != null) {
            this.userId = entity.getUser().getUserId();
            this.userName = entity.getUser().getRealName();
            this.dongHo = entity.getUser().getDong() + "동 " + entity.getUser().getHo() + "호";
        } else {
            this.userName = "알 수 없음";
            this.dongHo = "-";
        }
        
        this.useTime = entity.getReserveDate() + " (" + 
                       (entity.getDetailInfo() != null ? entity.getDetailInfo() : "상세없음") + ")";
        
        // ★ 중요: 이용완료/취소 상태 매핑 로직 완벽 적용
        String status = entity.getResStatus();
        if ("예약완료".equals(status) || "승인완료".equals(status) || "APPROVED".equals(status)) {
            this.resStatus = "APPROVED";
        } else if ("취소".equals(status) || "예약취소".equals(status) || "취소됨".equals(status) || "CANCELLED".equals(status)) {
            this.resStatus = "CANCELLED";
        } else if ("이용완료".equals(status) || "COMPLETED".equals(status)) {
            this.resStatus = "COMPLETED"; // 날짜 지난 이용완료 대응
        } else {
            this.resStatus = "WAITING";
        }
    }
}