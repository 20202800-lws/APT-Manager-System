-- ==========================================
-- 1. 데이터베이스 생성 및 선택
-- ==========================================
CREATE DATABASE IF NOT EXISTS apt_management;
USE apt_management;

-- ==========================================
-- 2. 테이블 생성 (최신 ERD 구조 100% 반영)
-- ==========================================

-- 1. 사용자 (USERS) - 모든 테이블의 최상위 부모
CREATE TABLE USERS (
    user_id VARCHAR(50) PRIMARY KEY COMMENT '아이디',
    user_pw VARCHAR(255) NOT NULL COMMENT '비밀번호',
    user_name VARCHAR(50) NOT NULL COMMENT '이름',
    dong VARCHAR(20) COMMENT '동',
    ho VARCHAR(20) COMMENT '호수',
    user_role VARCHAR(20) DEFAULT 'USER' COMMENT '권한',
    phone VARCHAR(20) COMMENT '전화번호',
    email VARCHAR(100) COMMENT '이메일',
    birth_date VARCHAR(20) COMMENT '생년월일',
    gender_digit CHAR(1) COMMENT '성별코드',
    approval_status TINYINT(1) DEFAULT 0 COMMENT '승인여부(0:대기,1:승인)',
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    withdrawal_date DATETIME COMMENT '탈퇴일시'
);

-- 2. 시설 정보 (FACILITY)
CREATE TABLE FACILITY (
    fac_id VARCHAR(20) PRIMARY KEY COMMENT '시설ID',
    fac_name VARCHAR(50) COMMENT '시설명',
    unit_price INT COMMENT '이용료',
    capacity INT COMMENT '수용인원',
    fac_location VARCHAR(100) COMMENT '위치',
    available TINYINT(1) DEFAULT 1 COMMENT '운영여부(0:중지,1:운영)'
);

-- 3. 프로그램 (PROGRAM)
CREATE TABLE PROGRAM (
    prog_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '강습번호',
    prog_name VARCHAR(100) COMMENT '강습명',
    instructor VARCHAR(50) COMMENT '강사',
    target_day VARCHAR(50) COMMENT '요일',
    fee INT COMMENT '수강료',
    description TEXT COMMENT '설명',
    capacity INT DEFAULT 0 COMMENT '정원'
);

-- 4. 관리비 (MANAGE_FEE)
CREATE TABLE MANAGE_FEE (
    fee_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '관리비번호',
    dong VARCHAR(20) COMMENT '동',
    ho VARCHAR(20) COMMENT '호',
    use_year INT COMMENT '년',
    use_month INT COMMENT '월',
    total_cost INT COMMENT '총금액',
    payment_status TINYINT(1) DEFAULT 0 COMMENT '납부여부(0:미납, 1:완납)'
);

-- 5. 관리비 상세 (FEE_DETAIL)
CREATE TABLE FEE_DETAIL (
    detail_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '상세번호',
    fee_id BIGINT NOT NULL COMMENT '관리비번호',
    item_name VARCHAR(50) NOT NULL COMMENT '항목명(전기,수도,일반관리비 등)',
    amount INT NOT NULL COMMENT '금액',
    FOREIGN KEY (fee_id) REFERENCES MANAGE_FEE(fee_id) ON DELETE CASCADE
);

-- 6. 관리비 로그 (FEE_LOG)
CREATE TABLE FEE_LOG (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '로그번호',
    fee_id BIGINT COMMENT '관리비번호',
    admin_id VARCHAR(50) COMMENT '작업자',
    action_type VARCHAR(20) COMMENT '유형',
    change_desc TEXT COMMENT '내용',
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '일시',
    FOREIGN KEY (fee_id) REFERENCES MANAGE_FEE(fee_id) ON DELETE CASCADE
);

-- 7. 통합 게시판 (BOARD) - 자유, 익명 등 통합
CREATE TABLE BOARD (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글번호',
    user_id VARCHAR(50) COMMENT '작성자',
    category VARCHAR(20) DEFAULT 'FREE' COMMENT '구분(FREE, ANON)',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT COMMENT '내용',
    anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부(0:실명, 1:익명)',
    views INT DEFAULT 0 COMMENT '조회수',
    like_count INT DEFAULT 0 COMMENT '좋아요수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 8. 댓글 (COMMENT) - 대댓글 구조 포함
CREATE TABLE COMMENT (
    reply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글번호',
    board_id BIGINT NOT NULL COMMENT '게시글ID',
    user_id VARCHAR(50) COMMENT '작성자',
    content TEXT COMMENT '내용',
    anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부',
    parent_id BIGINT DEFAULT NULL COMMENT '부모댓글ID(NULL이면 최상위)',
    depth INT DEFAULT 0 COMMENT '계층(0:댓글, 1:대댓글)',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (board_id) REFERENCES BOARD(board_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES COMMENT(reply_id) ON DELETE CASCADE
);

-- 9. 학부모 의견 피드 (PARENT_OPINION)
CREATE TABLE PARENT_OPINION (
    opinion_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '의견번호',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자',
    content TEXT NOT NULL COMMENT '내용(텍스트)',
    like_count INT DEFAULT 0 COMMENT '좋아요수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 10. 학부모 의견 피드 댓글 (PARENT_REPLY)
CREATE TABLE PARENT_REPLY (
    reply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글번호',
    opinion_id BIGINT NOT NULL COMMENT '의견번호',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자',
    content VARCHAR(500) NOT NULL COMMENT '내용',
    parent_id BIGINT DEFAULT NULL COMMENT '부모댓글ID',
    depth INT DEFAULT 0 COMMENT '계층(0:댓글, 1:대댓글)',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (opinion_id) REFERENCES PARENT_OPINION(opinion_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES PARENT_REPLY(reply_id) ON DELETE CASCADE
);

-- 11. 공지사항 (NOTICE)
CREATE TABLE NOTICE (
    notice_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '공지번호',
    writer_id VARCHAR(50) COMMENT '작성자',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    views INT DEFAULT 0 COMMENT '조회수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (writer_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 12. 민원 게시판 (COMPLAINT)
CREATE TABLE COMPLAINT (
    comp_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '민원번호',
    user_id VARCHAR(50) COMMENT '작성자',
    category VARCHAR(50) COMMENT '분류',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    reply TEXT COMMENT '관리자 답변',
    phone VARCHAR(20) COMMENT '비상연락처',
    comp_status VARCHAR(20) DEFAULT 'WAIT' COMMENT '상태',
    secret TINYINT(1) DEFAULT 1 COMMENT '비밀글(0:공개,1:비밀)',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    receipt_date DATETIME COMMENT '접수일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 13. 어린이집 알림장 (DAYCARE_NOTICE)
CREATE TABLE DAYCARE_NOTICE (
    notice_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '알림장번호',
    category VARCHAR(50) COMMENT '분류',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    writer_id VARCHAR(50) COMMENT '작성자',
    views INT DEFAULT 0 COMMENT '조회수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (writer_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 14. 차량 정보 (VEHICLE)
CREATE TABLE VEHICLE (
    car_number VARCHAR(20) PRIMARY KEY COMMENT '차량번호',
    user_id VARCHAR(50) COMMENT '소유주',
    phone VARCHAR(20) COMMENT '연락처',
    status VARCHAR(20) DEFAULT '승인대기' COMMENT '상태',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 15. 방문 차량 예약 (VISIT_VEHICLE)
CREATE TABLE VISIT_VEHICLE (
    visit_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '방문증번호',
    user_id VARCHAR(50) COMMENT '초대자',
    car_number VARCHAR(20) COMMENT '차량번호',
    visit_purpose VARCHAR(100) COMMENT '목적',
    visit_date DATE COMMENT '방문일',
    visit_status VARCHAR(20) COMMENT '상태',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 16. 시설 예약 (FACILITY_RES) - ★ 최신 유연한 구조로 교체 완료
CREATE TABLE FACILITY_RES (
    res_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '예약번호',
    user_id VARCHAR(50) COMMENT '예약자',
    facility_type VARCHAR(50) COMMENT '시설 종류(수영장, 스크린골프 등)',
    detail_info VARCHAR(200) COMMENT '상세 내역(3번 타석, A타입 등)',
    reserve_date VARCHAR(100) COMMENT '이용 날짜 및 기간',
    price VARCHAR(50) COMMENT '결제 금액',
    res_status VARCHAR(20) DEFAULT '예약완료' COMMENT '상태',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 17. 프로그램 신청 (PROGRAM_APPLY)
CREATE TABLE PROGRAM_APPLY (
    apply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '신청번호',
    prog_id BIGINT COMMENT '강습번호',
    user_id VARCHAR(50) COMMENT '신청자',
    apply_status VARCHAR(20) COMMENT '상태',
    apply_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (prog_id) REFERENCES PROGRAM(prog_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 18. 첨부파일 (ATTACHMENTS)
CREATE TABLE ATTACHMENTS (
    file_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '파일ID',
    ref_table VARCHAR(50) COMMENT '참조테이블명',
    ref_id BIGINT COMMENT '참조글번호',
    org_file_name VARCHAR(255) COMMENT '원본명',
    saved_file_name VARCHAR(255) COMMENT '저장명',
    file_path VARCHAR(500) COMMENT '경로',
    file_size BIGINT COMMENT '크기',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일'
);

-- 19. 알림 (NOTIFICATIONS)
CREATE TABLE NOTIFICATIONS (
    noti_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '알림ID',
    user_id VARCHAR(50) COMMENT '수신자',
    message VARCHAR(500) COMMENT '내용',
    read_state TINYINT(1) DEFAULT 0 COMMENT '읽음여부(0:안읽음,1:읽음)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '발송일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 20. 시스템 활동 로그 (SYSTEM_LOG) - 관리자 감사용
CREATE TABLE SYSTEM_LOG (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '로그번호',
    admin_id VARCHAR(50) COMMENT '처리자(관리자) ID',
    module_name VARCHAR(50) NOT NULL COMMENT '작업 메뉴',
    action_type VARCHAR(20) NOT NULL COMMENT '작업 유형',
    target_id VARCHAR(100) COMMENT '대상이 된 식별자',
    action_desc TEXT NOT NULL COMMENT '상세 작업 내용',
    ip_address VARCHAR(50) COMMENT '처리자 접속 IP',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '처리 일시',
    FOREIGN KEY (admin_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

COMMIT;ㄴ